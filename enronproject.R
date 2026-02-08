# ENRON EMAIL NETWORK ANALYSIS
# -------------------------------------------------------------

library(tidyverse)
library(lubridate)
library(stringr)
library(igraph)
library(ggplot2)
library(tidytext)
library(topicmodels)
library(wordcloud)

set.seed(123)

# -----------------------------
# Load data
# -----------------------------
path <- "C:/Users/dell/Desktop/DataScience/emails.csv"
raw_data <- read_csv(path)

data_test <- head(raw_data, 10000)  # increase if needed
nrow(data_test)

# -----------------------------
# Parse emails
# -----------------------------
emails_sample <- data_test %>%
  mutate(
    from     = str_extract(message, "(?<=From: )\\S+"),
    to       = str_extract(message, "(?<=To: )\\S+"),
    date_raw = str_extract(message, "(?<=Date: ).*(?=\\n)"),
    date     = dmy_hms(str_sub(date_raw, 6, 31), quiet = TRUE),
    body     = str_extract(message, "(?s)(?<=\\n\\n).*")
  ) %>%
  select(date, from, to, body) %>%
  filter(!is.na(date), !is.na(from), !is.na(to))

head(emails_sample)

# -----------------------------
# Build graph
# -----------------------------
edges <- emails_sample %>%
  select(from, to) %>%
  filter(from != "", to != "")

g <- graph_from_data_frame(edges, directed = TRUE)
g

# ===================================================================================================================
# Q1 — Which employees are the most central in the network, in terms of emails received and sent?
# ===================================================================================================================

top_in <- tibble(email = names(degree(g, mode = "in")),
                 received = as.numeric(degree(g, mode = "in"))) %>%
  arrange(desc(received)) %>%
  slice_head(n = 10)

ggplot(top_in, aes(x = reorder(email, received), y = received)) +
  geom_col() +
  coord_flip() +
  labs(title = "Top 10 Employees by Emails Received",
       x = "Employee", y = "Emails Received") +
  theme_minimal()

top_out <- tibble(email = names(degree(g, mode = "out")),
                  sent = as.numeric(degree(g, mode = "out"))) %>%
  arrange(desc(sent)) %>%
  slice_head(n = 10)

ggplot(top_out, aes(x = reorder(email, sent), y = sent)) +
  geom_col() +
  coord_flip() +
  labs(title = "Top 10 Employees by Emails Sent",
       x = "Employee", y = "Emails Sent") +
  theme_minimal()

# ===================================================================================================================
# Q2 — Which employees are the most influential in the email network? 
# ===================================================================================================================

pr <- page.rank(g)$vector
top_pr <- tibble(email = names(pr), pagerank = as.numeric(pr)) %>%
  arrange(desc(pagerank)) %>%
  slice_head(n = 10)

ggplot(top_pr, aes(x = reorder(email, pagerank), y = pagerank)) +
  geom_col() +
  coord_flip() +
  labs(title = "Top 10 Employees by PageRank",
       x = "Employee", y = "PageRank") +
  theme_minimal()

ev <- eigen_centrality(g)$vector
top_ev <- tibble(email = names(ev), eigenvector = as.numeric(ev)) %>%
  arrange(desc(eigenvector)) %>%
  slice_head(n = 10)

ggplot(top_ev, aes(x = reorder(email, eigenvector), y = eigenvector)) +
  geom_col() +
  coord_flip() +
  labs(title = "Top 10 Employees by Eigenvector Centrality",
       x = "Employee", y = "Eigenvector Score") +
  theme_minimal()

# ===================================================================================================================
# Q3 — Are there any communities in the email network?
# ===================================================================================================================

comm <- cluster_walktrap(as.undirected(g))
comm_sizes <- sizes(comm)

cat("Number of communities:", length(comm), "\n")

comm_df <- tibble(
  community = factor(seq_along(comm_sizes)),
  size = as.numeric(comm_sizes)
)

ggplot(comm_df, aes(x = community, y = size)) +
  geom_col() +
  labs(title = "Community Sizes (Walktrap)",
       x = "Community ID", y = "Number of Nodes") +
  theme_minimal()

# ===================================================================================================================
# Q4 — Are there any isolated employees in the email network?
# ===================================================================================================================

deg_all <- degree(g, mode = "all")
isolated_count <- sum(deg_all == 0)

data.frame(Metric = "Isolated employees", Count = isolated_count)

# ===================================================================================================================
# Q5 — Who acts as a bridge between different groups?
# ===================================================================================================================

bet <- betweenness(g, directed = TRUE)
top_bridges <- tibble(email = names(bet), betweenness = as.numeric(bet)) %>%
  arrange(desc(betweenness)) %>%
  slice_head(n = 10)

ggplot(top_bridges, aes(x = reorder(email, betweenness), y = betweenness)) +
  geom_col() +
  coord_flip() +
  labs(title = "Top 10 Bridge Employees (Betweenness)",
       x = "Employee", y = "Betweenness") +
  theme_minimal()

# =============================================================
# Q6 — Fragmentation over time (monthly)
# =============================================================

df_month <- emails_sample %>%
  mutate(month = floor_date(as.POSIXct(date, tz = "UTC"), "month")) %>%
  filter(month >= as.Date("2000-01-01"),
         month <= as.Date("2002-12-31"))

frag_metrics <- function(x) {
  gm <- graph_from_data_frame(x[, c("from", "to")], directed = TRUE)
  if (vcount(gm) == 0) return(tibble(percent_gcc = NA_real_, num_components = NA_integer_))
  comp <- components(gm, mode = "weak")
  tibble(
    percent_gcc = max(comp$csize) / vcount(gm),
    num_components = comp$no
  )
}

frag_results <- df_month %>%
  group_by(month) %>%
  group_modify(~ frag_metrics(.x)) %>%
  ungroup()

ggplot(frag_results, aes(x = month, y = percent_gcc)) +
  geom_line(linewidth = 1) +
  labs(title = "Giant Connected Component (Share of Nodes)",
       x = "Month", y = "Percent GCC") +
  theme_minimal()

ggplot(frag_results, aes(x = month, y = num_components)) +
  geom_line(linewidth = 1) +
  labs(title = "Number of Connected Components",
       x = "Month", y = "Components") +
  theme_minimal()

# =============================================================
# Q7 — Activity over time (daily + monthly)
# =============================================================

daily_activity <- emails_sample %>%
  mutate(day = as.Date(date)) %>%
  count(day, name = "email_count")

ggplot(daily_activity, aes(x = day, y = email_count)) +
  geom_line(linewidth = 1) +
  labs(title = "Daily Email Activity",
       x = "Date", y = "Number of Emails") +
  theme_minimal()

monthly_activity <- emails_sample %>%
  mutate(month = floor_date(as.Date(date), "month")) %>%
  count(month, name = "email_count")

ggplot(monthly_activity, aes(x = month, y = email_count)) +
  geom_line(linewidth = 1) +
  labs(title = "Monthly Email Activity",
       x = "Month", y = "Number of Emails") +
  theme_minimal()

# =============================================================
# Wordcloud — Before vs During the crisis
# =============================================================

stop_words_df <- tidytext::stop_words
remove_terms <- c("enron","email","subject","ect","hou","http","ees","corp","www",
                  "align","span","size","image","width","nbsp","font","style","left",
                  "class","mail","message")

before_crisis <- emails_sample %>%
  mutate(day = as.Date(date)) %>%
  filter(day < as.Date("2001-10-01"))

during_crisis <- emails_sample %>%
  mutate(day = as.Date(date)) %>%
  filter(day >= as.Date("2001-10-01"),
         day <= as.Date("2001-12-31"))

prep_words <- function(df, top_n = 200) {
  df %>%
    filter(!is.na(body), nchar(body) > 0) %>%
    unnest_tokens(word, body) %>%
    mutate(word = str_to_lower(word)) %>%
    anti_join(stop_words_df, by = "word") %>%
    filter(str_detect(word, "^[a-z]+$"),
           nchar(word) >= 3,
           !word %in% remove_terms) %>%
    count(word, sort = TRUE) %>%
    slice_head(n = top_n)
}

w_before <- prep_words(before_crisis)
w_during <- prep_words(during_crisis)

par(mfrow = c(1, 2), bg = "black", mar = c(0, 0, 2, 0))

wordcloud(w_before$word, w_before$n,
          max.words = 200, random.order = FALSE,
          colors = c("gray80", "gray60", "chartreuse3", "green3"),
          scale = c(3.5, 0.6))
title("Before the Crisis", col.main = "gray80")

wordcloud(w_during$word, w_during$n,
          max.words = 200, random.order = FALSE,
          colors = c("gray80", "gray60", "red", "red"),
          scale = c(3.5, 0.6))
title("During the Crisis", col.main = "gray80")

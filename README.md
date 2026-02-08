# Enron Email Network Analysis

---

## Project Overview

This repository contains a **Network Science and Text Mining analysis** of the **Enron Email Network**.  
The goal of the project is to analyze internal communication patterns within Enron and to identify structural, temporal, and semantic changes related to the company crisis.

The project combines:
- **Network Analysis** (centrality, communities, bridges, isolation, fragmentation)
- **Temporal Analysis** (activity and network evolution over time)
- **Text Mining** (content comparison before and during the crisis)

---

## Dataset

The dataset is derived from the **Enron Email Dataset**, which contains internal email communications among Enron employees.

Each email includes:
- sender (`from`)
- receiver (`to`)
- timestamp (`date`)
- email body (`body`)

The repository contains:
- `dataset.xlsx` — a cleaned and reduced version of the dataset used for the analysis

> Note: The original dataset was preprocessed and reduced in size to improve performance and comply with repository constraints.

---

## Research Questions

### Network Structure & Centrality
**Q1** — Which employees are the most central in the network (emails sent and received)?

**Q2** — Who are the most influential employees according to PageRank and Eigenvector centrality?

---

### Communities & Roles
**Q3** — Are there communities in the email network?

**Q4** — Are there isolated employees in the network?

**Q5** — Who acts as a bridge between different groups?

---

### Temporal Analysis
**Q6** — Does the Enron email network show signs of fragmentation before the crisis?

**Q7** — Does the network’s activity change over time?

---

### Text Mining
**Q8** — Does the content of internal email communication change before and during the Enron crisis?

---

## Methodology

The analysis follows these main steps:

1. **Email preprocessing**
   - extraction of sender, receiver, date, and message body
   - data cleaning and filtering

2. **Network construction**
   - creation of a directed email communication graph
   - nodes represent employees
   - edges represent emails sent

3. **Centrality analysis**
   - in-degree and out-degree
   - PageRank
   - Eigenvector centrality
   - Betweenness centrality

4. **Community detection**
   - Walktrap algorithm (applied to an undirected version of the network)
   - analysis of community sizes

5. **Isolation analysis**
   - identification of employees with zero total degree

6. **Temporal network analysis**
   - monthly activity analysis
   - fragmentation analysis using connected components
   - Giant Connected Component (GCC) evolution over time

7. **Text mining**
   - tokenization of email content
   - removal of stopwords and domain-specific terms
   - comparison of frequent words before and during the crisis
   - visualization using word clouds

---

## Project Structure


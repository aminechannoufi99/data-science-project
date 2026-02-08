# data-science-project
Enron Email Network Analysis
Project Overview

This repository contains a comprehensive Network Science and Text Mining analysis of the Enron Email Network.
The goal of the project is to study internal communication patterns within Enron and to identify structural, temporal, and semantic changes, especially in relation to the company crisis.

The project combines:

Network Analysis (centrality, communities, bridges, fragmentation)

Text Mining (content comparison before and during the crisis)

Dataset

The dataset used in this project is derived from the Enron Email Dataset, which contains internal email communications among Enron employees.

Each email includes:

sender (from)

receiver (to)

timestamp (date)

email body (body)

The repository contains:

dataset.xlsx — a cleaned and reduced version of the dataset used for the analysis

Note: The original dataset was preprocessed and reduced in size to improve performance and comply with repository constraints.

Research Questions
Network Structure & Centrality

Q1 — Who are the most central employees in the email network in terms of emails sent and received?

Q2 — Who are the most influential employees according to PageRank and Eigenvector centrality?

Community & Roles

Q3 — Are there communities in the email network?

Q4 — Are there isolated employees in the network?

Q5 — Who acts as a bridge between different groups in the network?

Temporal & Global Network Analysis

Q6 — Does the Enron email network show signs of fragmentation before the crisis?

Text Mining Analysis

Q8 — Does the content of internal email communication change before and during the Enron crisis?

Methodology

The analysis follows these main steps:

Email preprocessing

extraction of sender, receiver, date, and message body

data cleaning and filtering

Network construction

creation of a directed email communication graph

nodes represent employees

edges represent emails sent

Centrality analysis

in-degree and out-degree

PageRank

Eigenvector centrality

Betweenness centrality

Community detection

Walktrap algorithm (on an undirected version of the network)

analysis of community sizes

Isolation analysis

identification of employees with zero connections

Temporal fragmentation analysis

monthly network construction

analysis of connected components

Giant Connected Component (GCC) evolution over time

Text mining

tokenization of email content

stopword and domain-specific term removal

comparison of frequent terms before and during the crisis

visualization using word clouds

Project Structure
.
├── README.md
├── dataset.xlsx
├── enronproject.R


enronproject.R — main R script containing all analyses

dataset.xlsx — dataset used for the project

README.md — project documentation

Requirements

R ≥ 4.3

RStudio

Main R packages

tidyverse

igraph

tidygraph

ggraph

ggplot2

tidytext

lubridate

wordcloud

How to Run the Project

Clone or download the repository

Open RStudio

Set the working directory to the project folder

Run the main script:

source("enronproject.R")


All analyses and visualizations will be generated automatically.

Results & Insights

The analysis highlights:

a small group of highly central and influential employees

the presence of distinct communication communities

employees acting as bridges between different groups

isolated nodes with no communication links

increasing fragmentation of the network over time

noticeable changes in email content during the crisis period

Conclusion

# ISA 401 Job Scout Chat: ask questions, get SQL, a table, or a chart back
library(shiny)
library(bslib)
library(DBI)
library(RSQLite)
library(ellmer)
library(querychat)

con = DBI::dbConnect(RSQLite::SQLite(), "data/midwest_airbnb.db")

client = ellmer::chat_openai(
  model  = "gpt-5.6-luna",
  params = ellmer::params(reasoning_effort = "none")
)

ui = page_sidebar(
  theme = bs_theme(
    version = 5,
    preset = "flatly",
    primary = "#2c3e50"
  ),
  title = "Midwest Airbnb Intelligence Hub",
  
qc = querychat::querychat(
  con, "listings",
  client             = client,
  tools              = c("filter", "query", "visualize"),
  greeting           = "Ask me about 14,887 Airbnb listings in Chicago, Columbus, and the Twin Cities.",
  data_description   = "data/data_desc.md",
  extra_instructions = "data/extra_instructions.md"
)

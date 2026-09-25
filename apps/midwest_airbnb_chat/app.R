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
  
  sidebar = sidebar(
    width = 350,
    h4("About This App"),
    p("This application explores 14,887 Airbnb listings across three major Midwest regions from Inside Airbnb snapshots:"),
    tags$ul(
      tags$li("Chicago (2026-07-20)"),
      tags$li("Columbus (2026-07-23)"),
      tags$li("Twin Cities (2026-07-21)")
    ),
    hr(),
    p(tags$small("Created by Jesse Rosner as part of Business Intelligence coursework."))
  ),

  querychat::querychat_ui("qc")
)
  
server = function(input, output, session) {
  querychat::querychat_server(
    "qc",
  con                = con,
  table              = "listings",
  client             = client,
  tools              = c("filter", "query", "visualize"),
  greeting           = "Ask me about 14,887 Airbnb listings in Chicago, Columbus, and the Twin Cities.",
  data_description   = "data/data_desc.md",
  extra_instructions = "data/extra_instructions.md"
)
}

shinyApp(ui, server)

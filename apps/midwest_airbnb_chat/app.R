# ISA 401 Job Scout Chat: ask questions, get SQL, a table, or a chart back
library(querychat)

con = DBI::dbConnect(RSQLite::SQLite(), "data/midwest_airbnb.db")

client = ellmer::chat_openai(
  model  = "gpt-5.6-luna",
  params = ellmer::params(reasoning_effort = "none")
)

qc = querychat::querychat(
  con, "listings",
  client             = client,
  tools              = c("filter", "query", "visualize"),
  greeting           = "Ask me about 14,887 Airbnb listings in Chicago, Columbus, and the Twin Cities.",
  data_description   = "data/data_desc.md",
  extra_instructions = "data/extra_instructions.md"
)

library(shiny)
library(bslib)

ui = page_sidebar(
  title = "Midwest Airbnb Explorer",
  theme = bs_theme(bootswatch = "flatly", primary = "#FF5A5F"),
  sidebar = qc$sidebar(),
  
  card(
    card_header("About"),
    "Ask questions about 14,887 Airbnb listings in Chicago, Columbus, and the Twin Cities.
     Data: Inside Airbnb, July 2026. The SQL for each answer is shown below."
  ),
  card(
    card_header("SQL query"),
    verbatimTextOutput("sql")
  ),
  card(
    full_screen = TRUE,
    card_header("Data"),
    DT::DTOutput("table")
  )
)

server = function(input, output, session) {
  qc_vals = qc$server()
  
  output$sql = renderText({
    if (isTruthy(qc_vals$sql())) qc_vals$sql() else "SELECT * FROM listings"
  })
  
  output$table = DT::renderDT({
    qc_vals$df()
  })
}

shinyApp(ui, server)
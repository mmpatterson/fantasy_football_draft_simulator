library(shiny)
library(bslib)
library(shinyWidgets)
library(DT)
library(reticulate)
library(purrr)
library(config)
library(httr2)
library(glue)

# Load your virtual environment
use_virtualenv("./venv", required = TRUE)

# Source your Python module
league_utils <- import_from_path("utils", path = "src/")

# Load the config file
app_config <- config::get()

# Load all R files
purrr::walk(list.files("R", pattern = "\\.R$", full.names = TRUE), source)

ui <- page_sidebar(
  title = "Fantasy Draft Assistant",
  sidebar = sidebar(
    textInput("league_id", "Enter League ID", value = "1183113127652892672", placeholder = "e.g. 123456"),
    
    selectInput("platform", "Platform", choices = c("ESPN", "Sleeper", "Yahoo"), selected = "Sleeper"),
    
    actionButton("load_league", "Load League Info", icon = icon("download")),
    
    br(), br(),
    
    actionButton("make_pick", "Make My Pick", icon = icon("check-circle"))
  ),
  
  mainPanel(
    h3("Live Draft Board"),
    DTOutput("draft_table"),
    
    hr(),
    
    h4("Recommended Pick"),
    verbatimTextOutput("suggested_pick"),
    
    hr(),
    
    h4("Your Selection"),
    uiOutput("player_picker")
  )
)

server <- function(input, output, session) {
  
  # Load all reactive values
  rv_league_obj <- reactiveVal(NULL)
  draft_data <- reactiveVal(NULL)
  
  rv_league_id <- reactiveVal(NULL)
  rv_draft_id <- reactiveVal(NULL)
  rv_num_teams <- reactiveVal(NULL)
  rv_league_name <- reactiveVal(NULL)
  rv_league_settings <- reactiveVal(NULL)
  rv_roster_positions <- reactiveVal(NULL)
  
  # Compile all reactive values into one list
  rv <- reactiveValues(rv_league_id = rv_league_id, rv_draft_id = rv_draft_id, rv_num_teams = rv_num_teams, rv_league_name = rv_league_name, rv_league_settings = rv_league_settings, rv_roster_positions = rv_roster_positions)
  
  # Load all observable functions
  load_observers(input, output, rv, session)

  
  
  
  # Placeholder: simulated draft board
  # draft_data <- reactiveVal(
  #   league_obj <- rv_league_obj()
  #   
  #   league_obj$draft
  # )
  
  # Output: Draft Table
  # output$draft_table <- renderDataTable({
  #   draft_data()
  # })
  
  # Output: Suggested Pick (placeholder logic)
  output$suggested_pick <- renderText({
    req(input$load_league)
    isolate({
      paste("Suggested pick for your team:", sample(c("Ekeler", "Diggs", "Hurts"), 1))
    })
  })
  
  # Output: Picker for player selection (placeholder UI)
  output$player_picker <- renderUI({
    selectInput("selected_player", "Select your pick:", 
                choices = c("Ekeler", "Diggs", "Hurts", "Lamb", "Barkley"))
  })
}

shinyApp(ui, server)
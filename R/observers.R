

load_observers <- function(input, output, rv, session) {
  # Logic to run when 'load league button is pushed'
  observeEvent(input$load_league, {
      league_id <- input$league_id
      print('Test')
      print(league_id)
      platform <- input$platform
      
      if(platform == 'ESPN') {
        tryCatch({
          league <- league_utils$get_league(league_id, year)  # Construct the object
          rv_league_obj(league)
          
          draft_data(league$draft)
        },
        error = function(e) {
          # Code to execute if an error occurs
          showNotification("Error getting league details :(!", type = "error", duration = 5)
        })
      } else if (platform == 'Sleeper'){
        league_data <- sleeper_league_data(league_id)
        
        # Set all reactive variables
        league_id <- league_data$league_id 
        rv$rv_league_id(league_id)
        print('Set rv_league_id')
        
        draft_id <- league_data$draft_id
        rv$rv_draft_id(draft_id)
        print('Set rv_draft_id')

        num_teams <- league_data$total_rosters
        rv$rv_num_teams(num_teams)
        
        league_name <- league_data$name
        rv$rv_league_name(league_name)
        
        league_settings <- league_data$scoring_settings
        rv$rv_league_settings(league_settings)
        
        roster_positions <- league_data$roster_positions
        rv$rv_roster_positions(roster_positions)
      }
      print('Done with load_league')
    })
  
  observeEvent(rv$rv_draft_id(), {
    
    print('ObserveEvent(rv$rv_draft_id()) ')
    print(rv$rv_draft_id())
    req(!is.null(rv$rv_draft_id()))
    draft_selections <- sleeper_get_draft_selections(rv$rv_draft_id())
    
    output$draft_table <- renderDT({
      req(draft_selections)  # ensure it's not NULL
      datatable(draft_selections)
    })
  })
}

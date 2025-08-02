

sleeper_get_draft_metadata <- function(draft_id){
  print('Getting Sleeper Draft Metadata')
  url <- config::get()$sleeper_draft_metadata
  response <- request(glue::glue(url, draft_id = draft_id)) %>% 
    req_perform()
  
  data <- resp %>%
    resp_body_json()
  print('Got Sleeper Draft Metadata')
  return(data)
}

sleeper_get_draft_selections <- function(draft_id){
  print('Getting Sleeper Draft Data')
  url <- config::get()$sleeper_draft_selections
  response <- request(glue::glue(url, draft_id = draft_id)) %>% 
    req_perform()
  
  data <- response %>%
    resp_body_json()
  
  draft_dataframe <- map_dfr(data, function(x) {
    data.frame(
      draft_slot = x$draft_slot,
      round      = x$round,
      pick_no    = x$pick_no,
      picked_by  = x$picked_by,
      player_id  = x$player_id,
      roster_id  = x$roster_id,
      first_name = x$metadata$first_name,
      last_name  = x$metadata$last_name,
      position   = x$metadata$position,
      team       = x$metadata$team,
      status     = x$metadata$status
      # Add more fields as needed
    )
  })
  print('Got SLeeper Draft Raw Data')
  return(draft_dataframe)
}

sleeper_league_data <- function(league_id){
  url <- config::get()$sleeper_league_identifiers
  print('Getting Sleeper League Data')
  response <- request(glue::glue(url, league_id = league_id)) %>%
    # req_url_path_param(league_id = league_id) %>% 
    req_perform()
  
  data <- response %>%
    resp_body_json()
  print('Got Sleeper League Data')
  return(data)
}
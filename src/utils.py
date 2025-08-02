from espn_api.football import League

def get_league(league_id: int, year: int, s2: str = None, swid: str = None) -> League:
  try:
    
    if s2 is None and swid is None:
      # League is public
      league = League(league_id = league_id, year = year)
    else:
      # League is private
      pass
    
    return league
  except ValueError as err:
      print(err.args)

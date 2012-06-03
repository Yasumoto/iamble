# __author__ = russ@iamble

def GenerateSuggestions(ambler, suggestions=10, location)
  """Generates a list of top suggestions for the given ambler."""
  # get all places within the ambler default radius for the given location
  # create a temporary place object for each that will be used to store suggestion ratings
  # check places against ambler's checkins
  # check places against user preferences
  # grab the top x suggestions, cache them
  rated_places = {}
  local_places = data_utils.GetPlacesInArea(
      location.lat, location.lng, constants.DISTANCE_MAPPING[ambler.distance])
  for place in local_places:
    # parse out relevant place data
    # query datastore on place data, find that place and all related ambler checkin children
    if stored_checkins:
      for checkin in stored_checkins:
        # check stored checkin info to see if we can generate a good rating
        # check place mentions if available
        # check signal likes if they're available
        # increment the place weight
    # check ambler recent likes and dislikes
    # weight based on distance
    # weight based on price
    # weight based on type
    # append to rated_places with calculated weight 
    
    
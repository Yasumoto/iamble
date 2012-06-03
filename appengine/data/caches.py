import datetime

EXPIRE_CACHE_DAYS = 7

def GetPersistentCache(ambler, max_suggestions, location=None):
  """Collect and remove from cache the provided number of suggestions for the given ambler."""
  location = location or ambler.default_location
  today = datetime.datetime.today()
  suggestions = ambler.persistent_suggestion_cache
  valid_suggestions = []
  for suggestion in suggestions[:max_suggestions]:
    if (today - suggestion.cache_timestamp) < 7:
      valid_suggestions.append(suggestion)
    # Add logic for location determination
  suggestions_needed = max_suggestions - len(valid_suggestions)
  if suggestions_needed > 0:
     valid_suggestions.extend(SetPersistentCache(ambler,
                                                 suggestions_needed,
                                                 location))
  SetPersistentCache(ambler, location=location)
  return valid_suggestions

def SetPersistentCache(ambler, num_suggestions=10, location=None):
  """Set the given number of persistent cache values for the given ambler."""
  location = location or ambler.default_location
  pass
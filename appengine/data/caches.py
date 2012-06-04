import datetime
from profiles import models

EXPIRE_CACHE_DAYS = 7

def GetPersistentCache(ambler, max_suggestions, location=None):
  """Collect and remove from cache the provided number of suggestions for the given ambler."""
  #location = location or ambler.default_location
  today = datetime.datetime.today()
  suggestions = ambler.persistent_suggestion_cache or []
  valid_suggestions = []
  for suggestion in suggestions[:max_suggestions]:
    if (today - suggestion.cache_timestamp) < datetime.timedelta(7):
      valid_suggestions.append(suggestion)
    ambler.persistent_suggestion_cache.remove(suggestion)
  ambler.put()
  return valid_suggestions

def SetPersistentCache(ambler, suggestions):
  """Set the given number of persistent cache values for the given ambler."""
  for suggestion in suggestions:
    suggestion_object = models.CachedPlace()
    suggestion_object.lat = suggestion['lat']
    suggestion_object.lng = suggestion['lng']
    suggestion_object.name = suggestion['name']
    suggestion_object.food_type = suggestion['food_type']
    suggestion_object.cost = suggestion['cost']
    suggestion_object.why_description1 = suggestion['why_description1']
    suggestion_object.why_description2 = suggestion['why_description2']
    suggestion_object.cache_timestamp = suggestion['cache_timestamp']
    suggestion_object.address = suggestion['address']
    ambler.persistent_suggestion_cache.append(suggestion_object)
  ambler.put()

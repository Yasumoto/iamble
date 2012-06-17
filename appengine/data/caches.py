import datetime
import constants
from profiles import models

EXPIRE_CACHE_DAYS = 7


def PopTopCache(ambler):
  """Pop the first persistent cache value and do a in place health check."""
  today = datetime.datetime.today()
  suggestions = ambler.persistent_suggestion_cache
  for suggestion in suggestions:
    if (today - suggestion.cache_timestamp) < datetime.timedelta(constants.STALE_CACHE_DAYS):
      ambler.persistent_suggestion_cache.remove(suggestion)
      ambler.recent_places.append(models.RecentPlace(address=suggestion.address))
      ambler.put()
      return suggestion
    ambler.persistent_suggestion_cache.remove(suggestion)
  ambler.put()


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

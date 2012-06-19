import logging
import signal
import caches
import constants
from profiles import models as profile_models

def GetSuggestion(request_type, user=None, location=None):
  """Directs the request type to the proper collection method.

  Returns:
    Either a single suggestion for the web handler or a set of ten suggestions for mobile.
  """
  #Generate current user and location info
  current_user = user or users.get_current_user()
  ambler = profile_models.Ambler.get_by_id(current_user.email())
  current_location = location or ambler.default_location
  #Call the function for the specific incoming request type
  if (request_type == constants.GET_DEFAULT) and (location is None):
    top_suggestion = caches.PopTopCache(ambler)
    if not top_suggestion:
      signal_engine = signal.SignalEngine(current_user, current_location)
      signal_engine.FullDataProcess(constants.SET_CACHE)
      return caches.PopTopCache(ambler)
    return top_suggestion
    #defer a cache health check
  elif request_type == constants.FIRE_CACHE_BUILDER:
    pass
    #defer a cache health check
  elif (request_type == '') and (location is not None):
    signal_engine = signal.SignalEngine(current_user, current_location)
    # TODO(russ): Check the return of suggest.GenerateSuggestion to be sure it returns in the correct format
    return signal_engine.FullDataProcess(constants.DO_NOT_SET_CACHE)

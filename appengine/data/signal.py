# __author__ = russ@iamble

import data_models
import data_utils
import handler
from profiles import models as profile_models


class SignalEngine(object):  # Name needs work
  """Generates signals based on input I'll fill in later."""
  
  @handler.RequiresLogin
  def init(self, ambler):
    """Initializes a signal generation object"""
    # Gather ambler stats before any data is aggregated
    self.ambler = ambler
  
  def FirstLogin(self)
    """Does a massive data gather on all activated services."""
    json_checkins = data_utils.GetCheckinsForUser(self.ambler)
    for checkin in json_checkins:
      self.ParseAndStoreCheckin(checkin)
    
  def ParseAndStoreCheckin(self, signal)
    """Takes signal as an argument representing an item that is to be analyzed."""
    pass
    # Check place against existing datastore places
      # If exists call ExistingPlace function
    # Else
      # Add place to db
      # Determine signal type
      # Parse signal on type
      # Add signal to datastore
      # Determine signal source
      # Determine signal price
    
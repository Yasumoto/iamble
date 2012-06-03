"""
data_utils.py

Processes data from Singly into datastore.
"""

import config
import data_models
from profiles import models
from utils import singly_utils
from utils import decorators

@decorators.RequiresSinglyAccessToken
def GetCheckinsForUser(ambler):
  """Gets all Singly checkins for an Ambler.
  
  Args:
    ambler: models.Ambler.
  """
  status_code, json_object = singly_utils.SinglyGetCheckinsFeed(ambler)
  return json_object
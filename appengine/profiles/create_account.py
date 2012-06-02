# __author__ = russ@iamble

import logging
import models
from utils.template import render_template
from google.appengine.ext import webapp
from google.appengine.ext.webapp import template
from google.appengine.api import users

class CreateAccountHandler(webapp.RequestHandler):
  """Handler for areating accounts."""
  URL_PATH = '/create_account'
  TEMPLATE = 'templates/create_account.html'

  def get(self):
    """Handles get request for Create Account functions."""
    # Render a blank create account template
    template_params = dict()
    user = users.get_current_user()
    if user:
      ambler = models.Ambler.get_by_id(user.email())
      template_params['message'] = 'Welcome to the party! You are a user! Continue on to creating preferences'
      template_params['user'] = ambler.key.id()
    else:
      # Redirect to google login
      template_params['message'] = 'Looks like there was not Google user. Fix that!'
    render_template(self, self.TEMPLATE, template_params)
  
  def post(self):
    """Handles posts for Account Creation functions."""
    form_data = self._ParseFormInput()
    template_params = dict()
    user = users.get_current_user()
    if user:
      ambler = models.Ambler.get_or_insert(user.email())
      ambler.name_first = form_data['name_first']
      ambler.name_last = form_data['name_last']
      ambler.preferences.append(models.Preference(name='distance', value=form_data['distance']))
      ambler.preferences.append(models.Preference(name='walk', value=form_data['walk']))
      ambler.preferences.append(models.Preference(name='bike', value=form_data['bike']))
      ambler.preferences.append(models.Preference(name='drive', value=form_data['drive']))
      ambler.put()
      template_params['message'] = 'Welcome to the party! You are a user!'
      template_params['user'] = ambler.key.id()
    else:
      # Redirect to google login
      template_params['message'] = 'Looks like there was not Google user. Fix that!'
    render_template(self, self.TEMPLATE, template_params)
  
  def _ParseFormInput(self):
    """Parses the form input, catches any funky data."""
    form_data = {
      'name_first': self.request.get('name_first'),
      'name_last': self.request.get('name_last'),
      'distance': self.request.get('distance'),
      'walk': self.request.get('walk'),
      'bike': self.request.get('bike'),
      'drive': self.request.get('drive')
      }
    return form_data
    
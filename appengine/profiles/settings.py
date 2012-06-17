# __author__ = russ@cypht

import logging
import models
import handler

from utils import template
from google.appengine.ext import webapp
from google.appengine.api import users

class SettingsHandler(webapp.RequestHandler):
  """Handler for creating accounts."""
  URL_PATH = '/settings'
  TEMPLATE = 'templates/settings.html'

  NO_PROFILE = 'Hey! You should fill in all your profile info!'

  SAVED_PREFERENCES = 'Your preferences were successfully saved!'

  @handler.RequiresLogin
  def get(self):
    """Handles get request for settings functions."""
    # Render a blank create account template
    template_params = template.get_params()
    user = users.get_current_user()
    if user:
      ambler = models.Ambler.get_by_id(user.email())

      if not ambler:
        ambler = models.Ambler.get_or_insert(user.email())
        template_params['warning_messages'].append(self.NO_PROFILE)

      template_params['user'] = ambler
    else:
      self.redirect('/login')
    template.render_template(self, self.TEMPLATE, template_params)
  
  @handler.RequiresLogin
  def post(self):
    """Handles posts for settings functions."""
    form_data = self._ParseFormInput()
    template_params = template.get_params()
    user = users.get_current_user()
    if user:
      ambler = models.Ambler.get_or_insert(user.email())

      first_time = ambler.first_time

      ambler.name_first = form_data['name_first']
      ambler.name_last = form_data['name_last']
      ambler.default_location = models.Coordinate(
          lat=form_data['latitude'], lng=form_data['longitude'])
      ambler.first_time = False
      ambler.budget = form_data['budget']
      ambler.distance = form_data['distance']
      ambler.default_address = form_data['address']
      ambler.static_address = form_data['static_address']

      ambler.put()

    if first_time:
      self.redirect('/')
    else:
      template_params['success_messages'].append(self.SAVED_PREFERENCES)
      template_params['user'] = ambler
      template.render_template(self, self.TEMPLATE, template_params)
  
  def _ParseFormInput(self):
    """Parses the form input, catches any funky data."""
    #TODO(zms): add error checking for when the web ui passes back blank lat/long
    form_data = {
      'name_first': self.request.get('name_first'),
      'name_last': self.request.get('name_last'),
      'latitude': float(self.request.get('latitude')),
      'longitude': float(self.request.get('longitude')),
      'address': self.request.get('address'),
      'budget': float(self.request.get('budget')),
      'distance': self.request.get('distance'),
      'static_address': (self.request.get('static_address') == 'true')
      }
    return form_data

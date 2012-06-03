# __author__ = russ@iamble

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
      preferences_dict = dict((p.name, p.value) for p in ambler.preferences)

      if ambler:
        template_params['user'] = ambler
        template_params['preferences'] = preferences_dict
      else:
        template_params['warning_messages'].append(self.NO_PROFILE)
        ambler = models.Ambler.get_or_insert(user.email())
        template_params['user'] = ambler
        template_params['preferences'] = preferences_dict
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

      originally_setup = ambler.setup

      ambler.name_first = form_data['name_first']
      ambler.name_last = form_data['name_last']
      ambler.setup = True

      ambler = self._SavePreference(ambler, 'budget', form_data['budget'])
      ambler = self._SavePreference(ambler, 'walk', form_data['walk'])
      ambler = self._SavePreference(ambler, 'bike', form_data['bike'])
      ambler = self._SavePreference(ambler, 'drive', form_data['drive'])

      ambler.put()

    if not originally_setup:
      self.redirect('/')
    else:
      preferences_dict = dict((p.name, p.value) for p in ambler.preferences)

      template_params['success_messages'].append(self.SAVED_PREFERENCES)
      template_params['user'] = ambler
      template_params['preferences'] = preferences_dict
      template.render_template(self, self.TEMPLATE, template_params)
  
  def _ParseFormInput(self):
    """Parses the form input, catches any funky data."""
    form_data = {
      'name_first': self.request.get('name_first'),
      'name_last': self.request.get('name_last'),
      'budget': self.request.get('budget'),
      'walk': self.request.get('walk'),
      'bike': self.request.get('bike'),
      'drive': self.request.get('drive')
      }
    return form_data

  def _SavePreference(self, ambler, name, value):
    """"""
    preferences = dict((p.name, p) for p in ambler.preferences)

    if name in preferences:
      preference = preferences[name]
      preference.value = value
      preference.put()
    else:
      ambler.preferences.append(models.Preference(name=name, value=value))
    return ambler

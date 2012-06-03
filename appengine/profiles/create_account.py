# __author__ = russ@iamble

import logging
import models
import handler

from utils import template
from google.appengine.ext import webapp
from google.appengine.api import users

class CreateAccountHandler(webapp.RequestHandler):
  """Handler for creating accounts."""
  URL_PATH = '/create_account'
  TEMPLATE = 'templates/create_account.html'

  WELCOME = 'Welcome to the party! You are a user!'

  CREATE_PREFERENCES = 'Continue on to creating preferences'

  NO_PROFILE = """Hey! You should fill in all the profile info that will
  eventually be here!"""

  @handler.RequiresLogin
  def get(self):
    """Handles get request for Create Account functions."""
    # Render a blank create account template
    template_params = template.get_params()
    user = users.get_current_user()
    if user:
      ambler = models.Ambler.get_by_id(user.email())
      if ambler:
        template_params['success_messages'].append(
            '%s %s' % (self.WELCOME, self.CREATE_PREFERENCES))
        template_params['user'] = ambler
        template_params['preferences'] = self._PreferencesToDict(ambler)
      else:
        template_params['warning_messages'].append(self.NO_PROFILE)
        ambler = models.Ambler.get_or_insert(user.email())
        template_params['user'] = ambler
        template_params['preferences'] = self._PreferencesToDict(ambler)
    else:
      self.redirect('/login')
    template.render_template(self, self.TEMPLATE, template_params)
  
  @handler.RequiresLogin
  def post(self):
    """Handles posts for Account Creation functions."""
    form_data = self._ParseFormInput()
    template_params = template.get_params()
    user = users.get_current_user()
    if user:
      ambler = models.Ambler.get_or_insert(user.email())
      ambler.name_first = form_data['name_first']
      ambler.name_last = form_data['name_last']
      ambler.preferences.append(models.Preference(name='budget', value=form_data['budget']))
      ambler.preferences.append(models.Preference(name='walk', value=form_data['walk']))
      ambler.preferences.append(models.Preference(name='bike', value=form_data['bike']))
      ambler.preferences.append(models.Preference(name='drive', value=form_data['drive']))
      ambler.put()

      template_params['success_messages'].append(self.CREATE_PREFERENCES)
      template_params['user'] = ambler
      template_params['preferences'] = self._PreferencesToDict(ambler)
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

  def _PreferencesToDict(self, ambler):
    return dict((p.name, p.value) for p in ambler.preferences)

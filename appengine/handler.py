import json
import logging
from data import signal,signal_handler,constants
from urlparse import urlparse
from utils import template
from profiles import models

from google.appengine.api import oauth
from google.appengine.api import users
from google.appengine.ext import webapp

import config

UNDER_CONSTRUCTION = """This site is currently under construction.
Amble on back when you have a chance and check us out!"""

HOME_TEMPLATE = 'templates/home.html'
LANDING_TEMPLATE = 'templates/landing.html'
REDIRECT_TEMPLATE = 'templates/redirect.html'


def RequiresLogin(handler_method):

  def CheckLogin(self, *args):
    if users.get_current_user():
      return handler_method(self, *args)
    self.redirect(config.LOGIN_URL)

  return CheckLogin


def RequiresOAuth(handler_method):

  def CheckOAuth(self, *args):
    try:
      user = oauth.get_current_user()
      if user:
        self.response.set_status(200)
        return handler_method(self, *args)
    except oauth.Error as error:
      logging.error('oautherror... HEADERS: %s', self.request.headers)
      self.response.set_status(400)
  
  return CheckOAuth


class BaseHandler(webapp.RequestHandler):
  """"""

  def get(self):
    """"""
    template_params = template.get_params()
    template_params['warning_messages'].append(UNDER_CONSTRUCTION)

    if users.get_current_user():
      self.get_auth(template_params)
    else:
      self.get_noauth(template_params)

  def get_auth(self, template_params):
    """"""
    template.render_template(self, HOME_TEMPLATE, template_params)

  def get_noauth(self, template_params):
    """"""
    template.render_template(self, LANDING_TEMPLATE, template_params)

  @RequiresLogin
  def post(self):
    """"""
    user = users.get_current_user()

    suggestion_address = self.request.get('suggestion_address')
    suggestion_vote = self.request.get('suggestion_vote')

    ambler = models.Ambler.get_by_id(user.email())

    if suggestion_vote is not 0:
      # save vote and id
      if suggestion_vote > 0:
        ambler.recent_places.append(models.RecentPlace(
            address=suggestion_address,
            like_dislike=True))
      if suggestion_vote < 0:
        ambler.recent_places.append(models.RecentPlace(
            address=suggestion_address,
            like_dislike=False))
      ambler.put()
    top_suggestion = signal_handler.GetSuggestion(constants.GET_DEFAULT, user)
    response = {'lat': top_suggestion.lat,
                'lng': top_suggestion.lng,
                'name': top_suggestion.name,
                'why_description1': top_suggestion.why_description1,
                'why_description2': top_suggestion.why_description2,
                'address': top_suggestion.address
               }
    self.response.out.write(json.dumps(response))


class RedirectHandler(webapp.RequestHandler):
  """"""

  def get(self):
    """"""
    template_params = template.get_params()
    template_params['duration'] = 3
    template_params['warning_messages'].append(self.request.get('message'))
    
    url =  self.request.get('url')
    template_params['url'] = url
    template_params['host'] = urlparse(url).netloc
    logging.info('ASDFASDFASDFASDF URL: %s', urlparse(url).netloc)
    template.render_template(self, REDIRECT_TEMPLATE, template_params)

import json
import logging
from data import signal
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

    suggestion_type = self.request.get('type')
    suggestion_id = self.request.get('id')
    suggestion_vote = self.request.get('vote')

    ambler = models.Ambler.get_by_id(user.email())

    if suggestion_vote is not 0:
      # save vote and id
      if suggestion_vote > 0:
        ambler.recent_likes.append(suggestion_id)
      if suggestion_vote < 0:
        ambler.recent_dislikes.append(suggestion_id)
      ambler.put()
    suggestion_generator = signal.SignalEngine(user)
    top_suggestion = suggestion_generator.SignalMaster('get_top_default')[0]
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

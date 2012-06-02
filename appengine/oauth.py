
import config

import logging

from google.appengine.ext.webapp import template
from google.appengine.ext import webapp

UNDER_CONSTRUCTION = """This is OAuth2. Start handshaking!"""

HOME_TEMPLATE = 'templates/oauth.html'

class Service(object):
  pass

class FacebookService(Service):
  name = "Facebook"
  url = config.SINGLY_OAUTH_URL_TEMPLATE + 'facebook'

class TwitterService(Service):
  name = "Twitter"
  url = config.SINGLY_OAUTH_URL_TEMPLATE + 'twitter'

class OAuth2Handler(webapp.RequestHandler):
  """"""
  URL_PATH = '/oauth'

  def get(self):
    """"""
    template_params = dict()
    template_params['services'] = list()
    template_params['services'].append(FacebookService)
    template_params['services'].append(TwitterService)
    
    rendered_page = template.render(HOME_TEMPLATE, template_params)
    self.response.out.write(str(rendered_page))

class OAuth2CallbackHandler(webapp.RequestHandler):

  URL_PATH = '/oauth_callback'

  def get(self):
    logging.info('HTTPGET ARGS: %s', self.request.arguments())
  
  def post(self):
    logging.info('POSTED ARGS: %s', self.request.arguments())
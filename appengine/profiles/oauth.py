# python imports
import logging
import simplejson
import urllib

# app engine imports
from google.appengine.api import urlfetch
from google.appengine.ext.webapp import template
from google.appengine.ext import webapp

# iamble imports
import config
import models

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

class FoursquareService(Service):
  name = "Foursquare"
  url = config.SINGLY_OAUTH_URL_TEMPLATE + 'foursquare'

class GoogleContactsService(Service):
  name = "Google Contacts"
  url = config.SINGLY_OAUTH_URL_TEMPLATE + 'gcontacts'


class OAuth2Handler(webapp.RequestHandler):
  """"""
  URL_PATH = '/oauth'

  def get(self):
    """"""
    template_params = dict()
    template_params['services'] = list()
    template_params['services'].append(FacebookService)
    template_params['services'].append(TwitterService)
    template_params['services'].append(FoursquareService)
    template_params['services'].append(GoogleContactsService)
    
    rendered_page = template.render(HOME_TEMPLATE, template_params)
    self.response.out.write(str(rendered_page))

class OAuth2CallbackHandler(webapp.RequestHandler):

  URL_PATH = '/oauth_callback'

  def get(self):
    code = self.request.get('code')
    post_params = {
        'client_id': config.CLIENT_ID,
        'client_secret': config.CLIENT_SECRET,
        'code': code,
    }
    post_data = urllib.urlencode(post_params)
    result = urlfetch.fetch(url=config.SINGLY_API_ACCESS_TOKEN_URL,
                            payload=post_data,
                            method=urlfetch.POST,
                            headers=config.DEFAULT_POST_HEADERS)
    logging.info(result.content)
    access_token = simplejson.loads(result.content)['access_token']

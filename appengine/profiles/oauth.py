# python imports
import logging
import json
import urllib

# app engine imports
from google.appengine.api import urlfetch
from google.appengine.api import users
from google.appengine.ext import webapp
from google.appengine.ext.webapp import template

# cypht imports
import config
import handler
import models
from data import data_utils
from utils import singly_utils
from utils import template

UNDER_CONSTRUCTION = """This is OAuth2. Start handshaking!"""

HOME_TEMPLATE = 'templates/oauth.html'


class Service(object):

  def __init__(self, ambler=None, enabled=False):
    user = users.get_current_user()
    self.ambler = None
    self.enabled = enabled
    if user:
      self.ambler = ambler or models.Ambler.get_by_id(user.email())

  @property
  def oauth_url(self):
    url = config.SINGLY_OAUTH_URL_TEMPLATE + self.service_name
    if self.ambler.singly_id:
      url += '&account=%s' % self.ambler.singly_id
    service_url = urllib.quote_plus(url)
    message = 'Redirecting you through Singly to the %s authorization page.' % self.name
    return '/redirect?url=%s&message=%s' % (service_url, message)

  @property
  def profile_url(self):
    return config.SINGLY_API_PROFILES + '/' + self.service_name


class FacebookService(Service):
  name = "Facebook"
  service_name = 'facebook'
  icon = '/static/images/facebook.png'


class TwitterService(Service):
  name = "Twitter"
  service_name = 'twitter'
  icon = '/static/images/twitter.png'


class FoursquareService(Service):
  name = "Foursquare"
  service_name = 'foursquare'
  icon = '/static/images/foursquare.png'


class GoogleContactsService(Service):
  name = "Google Contacts"
  service_name = 'gcontacts'
  icon = '/static/images/google.png'


class OAuth2Handler(webapp.RequestHandler):
  """"""
  URL_PATH = '/oauth'

  SERVICS = [FacebookService,
             TwitterService,
             FoursquareService]


  @handler.RequiresLogin
  def get(self):
    """"""
    template_params = template.get_params()
    this_user = models.Ambler.get_by_id(users.get_current_user().email())

    existing_services = this_user.GetActiveServices() if this_user else []

    service_list = list()
    for service in self.SERVICS:
      enabled = service.service_name in existing_services
      initialized_service = service(this_user, enabled)
      service_list.append(initialized_service)

    template_params['services'] = service_list
    template_params['user'] = this_user

    template.render_template(self, HOME_TEMPLATE, template_params)

class OAuth2CallbackHandler(webapp.RequestHandler):

  URL_PATH = '/oauth_callback'

  @handler.RequiresLogin
  def get(self):
    this_user = models.Ambler.get_by_id(users.get_current_user().email())
    code = self.request.get('code')
    post_params = {
        'client_id': config.CLIENT_ID,
        'client_secret': config.CLIENT_SECRET,
        'code': code,
    }
    post_data = urllib.urlencode(post_params)
    status_code, response_object = singly_utils.SinglyPOST(
        config.SINGLY_API_ACCESS_TOKEN_URL, post_params)
    this_user.singly_access_token = response_object['access_token']
    this_user.put()
    self.redirect('/oauth')

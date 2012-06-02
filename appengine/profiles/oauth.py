# python imports
import logging
import json
import urllib

# app engine imports
from google.appengine.api import urlfetch
from google.appengine.api import users
from google.appengine.ext import webapp
from google.appengine.ext.webapp import template

# iamble imports
import config
import handler
import models

UNDER_CONSTRUCTION = """This is OAuth2. Start handshaking!"""

HOME_TEMPLATE = 'templates/oauth.html'

class Service(object):

  def __init__(self, ambler=None):
    user = users.get_current_user()
    self.ambler = None
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

class TwitterService(Service):
  name = "Twitter"
  service_name = 'twitter'

class FoursquareService(Service):
  name = "Foursquare"
  service_name = 'foursquare'

class GoogleContactsService(Service):
  name = "Google Contacts"
  service_name = 'gcontacts'


class OAuth2Handler(webapp.RequestHandler):
  """"""
  URL_PATH = '/oauth'

  @handler.RequiresLogin
  def get(self):
    """"""
    template_params = dict()
    this_user = models.Ambler.get_by_id(users.get_current_user().email())
    logging.info('THIS USER: %s', this_user)
    existing_services = this_user.GetActiveServices()
    services = [FacebookService(this_user),
                TwitterService(this_user),
                FoursquareService(this_user),
                GoogleContactsService(this_user)]
    new_services = []
    for service in services:
      logging.info('%s:%s', service.service_name, existing_services)
      logging.info('OAUTH_URL: %s', service.oauth_url)
      if service.service_name not in existing_services:
        new_services.append(service)
    profile_data = []
    for service in existing_services:
      profile_data.append(this_user.GetProfileServiceData(service))
    template_params['new_services'] = new_services
    template_params['existing_services'] = existing_services
    template_params['profile_data'] = profile_data
    rendered_page = template.render(HOME_TEMPLATE, template_params)
    self.response.out.write(str(rendered_page))

class OAuth2CallbackHandler(webapp.RequestHandler):

  URL_PATH = '/oauth_callback'

  @handler.RequiresLogin
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
    this_user = models.Ambler.get_by_id(users.get_current_user().email())
    
    this_user.singly_access_token = json.loads(result.content)['access_token']
    this_user.put()
    self.redirect('/oauth')

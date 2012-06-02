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

  @property
  def url(self):
    return config.SINGLY_OAUTH_URL_TEMPLATE + self.service_name

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
    services = [FacebookService(),
                TwitterService(),
                FoursquareService(),
                GoogleContactsService()]
    this_user = models.Ambler.get_by_id(users.get_current_user().email())
    logging.info('THIS USER: %s', this_user)
    existing_services = this_user.GetActiveServices()
    for service in services:
      if service.service_name in existing_services:
        services.remove(service)
    template_params['new_services'] = services
    template_params['existing_services'] = existing_services
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
    access_token = json.loads(result.content)['access_token']

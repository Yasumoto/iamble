# __author__ = russ@iamble

import handler
import wsgiref.handlers

from google.appengine.ext import webapp

from api import mobile_endpoint
from profiles import login, oauth, settings

URL_MAPPINGS = [
    ('/', handler.BaseHandler),
    ('/redirect', handler.RedirectHandler),
    (login.LoginHandler.URL_PATH, login.LoginHandler),
    (login.LogoutHandler.URL_PATH, login.LogoutHandler),
    (mobile_endpoint.MobileHandler.URL_PATH, mobile_endpoint.MobileHandler),
    (oauth.OAuth2Handler.URL_PATH, oauth.OAuth2Handler),
    (oauth.OAuth2CallbackHandler.URL_PATH, oauth.OAuth2CallbackHandler),
    (settings.SettingsHandler.URL_PATH, settings.SettingsHandler)]

def main():
  application = webapp.WSGIApplication(URL_MAPPINGS, debug=True)
  wsgiref.handlers.CGIHandler().run(application)


if __name__ == '__main__':
  main()

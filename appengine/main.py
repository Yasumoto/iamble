# __author__ = russ@iamble

import handler
import wsgiref.handlers

from google.appengine.ext import webapp

from api import mobile
from profiles import login, oauth, settings, signup

URL_MAPPINGS = [
    ('/', handler.BaseHandler),
    ('/redirect', handler.RedirectHandler),
    (login.LoginHandler.URL_PATH, login.LoginHandler),
    (login.LogoutHandler.URL_PATH, login.LogoutHandler),
    (mobile.NewServiceHandler.URL_PATH, mobile.NewServiceHandler),
    (mobile.RecommendationHandler.URL_PATH, mobile.RecommendationHandler),
    (oauth.OAuth2Handler.URL_PATH, oauth.OAuth2Handler),
    (oauth.OAuth2CallbackHandler.URL_PATH, oauth.OAuth2CallbackHandler),
    (settings.SettingsHandler.URL_PATH, settings.SettingsHandler),
    (signup.SignupHandler.URL_PATH, signup.SignupHandler)]

def main():
  application = webapp.WSGIApplication(URL_MAPPINGS, debug=True)
  wsgiref.handlers.CGIHandler().run(application)


if __name__ == '__main__':
  main()

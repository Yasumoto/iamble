# __author__ = russ@iamble

import handler
import oauth
import profiles.login
import wsgiref.handlers
from google.appengine.ext import webapp

URL_MAPPINGS = [
    ('/', handler.BaseHandler),
    (oauth.OAuth2Handler.URL_PATH, oauth.OAuth2Handler),
    (oauth.OAuth2CallbackHandler.URL_PATH, oauth.OAuth2CallbackHandler),
    (login.LoginHandler.URL_PATH, login.LoginHandler)]

def main():
  application = webapp.WSGIApplication(URL_MAPPINGS, debug=True)
  wsgiref.handlers.CGIHandler().run(application)


if __name__ == '__main__':
  main()
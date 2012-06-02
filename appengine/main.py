# __author__ = russ@iamble

import handler
import wsgiref.handlers
from profiles import login, create_account, oauth
from google.appengine.ext import webapp

URL_MAPPINGS = [
    ('/', handler.BaseHandler),
    (oauth.OAuth2Handler.URL_PATH, oauth.OAuth2Handler),
    (oauth.OAuth2CallbackHandler.URL_PATH, oauth.OAuth2CallbackHandler),
    (login.LoginHandler.URL_PATH, login.LoginHandler),
    (create_account.CreateAccountHandler.URL_PATH, create_account.CreateAccountHandler)]

def main():
  application = webapp.WSGIApplication(URL_MAPPINGS, debug=True)
  wsgiref.handlers.CGIHandler().run(application)


if __name__ == '__main__':
  main()
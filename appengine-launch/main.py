# __author__ = russ@iamble

import handler
import wsgiref.handlers

from google.appengine.ext import webapp

URL_MAPPINGS = [
    ('/', handler.BaseHandler)]

def main():
  application = webapp.WSGIApplication(URL_MAPPINGS, debug=True)
  wsgiref.handlers.CGIHandler().run(application)


if __name__ == '__main__':
  main()

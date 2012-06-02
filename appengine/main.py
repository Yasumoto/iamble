# __author__ = russ@iamble

import handler
import wsgiref.handlers
from google.appengine.ext import webapp

def main():
  application = webapp.WSGIApplication([
    ('/', handler.DefaultHandler)],
    debug=True)
  wsgiref.handlers.CGIHandler().run(application)

if __name__ == '__main__':
  main()
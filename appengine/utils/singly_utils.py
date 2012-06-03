#!/usr/bin/env python
# encoding: utf-8
"""
singly_urls.py

Created by James Meador on 2012-06-02.
Copyright (c) 2012 __MyCompanyName__. All rights reserved.
"""

import json
import urllib

from google.appengine.api import urlfetch

import config

def SinglyGET(url, query_params):
   """GETs a URL from Singly.
   
   Args:
     url: string of the base URL.
     query_params: dictionary mapping of key: value for query arguments.
   Returns:
     A tuple of status code, json object
   """
   get_params = urllib.urlencode(query_params)
   get_url = '%s?%s' %(url, get_params)
   response = urlfetch.fetch(url=get_url, method=urlfetch.GET)
   return response.status_code, json.loads(response.content)


def SinglyPOST(url, query_params):
  """POSTs to a Singly URL.
  
  Args:
    url: string of the base URL.
    query_params: dictionary mapping of key: value for query arguments.
  Returns:
    A tuple of status code, json object
  """
  post_params = urllib.urlencode(query_params)
  response = urlfetch.fetch(url=url,
                            method=urlfetch.POST,
                            payload=post_params,
                            headers=config.DEFAULT_POST_HEADERS)
  return response.status_code, json.loads(response.content)

# Convenience methods

def SinglyGetMyCheckins(ambler):
  query_params = {'access_token': ambler.singly_access_token}
  return SinglyGET(config.SINGLY_API_MY_CHECKINS, query_params)

def SinglyGetCheckinsFeed(ambler):
  query_params = {'access_token': ambler.singly_access_token}
  return SinglyGET(config.SINGLY_API_CHECKIN_FEED, query_params)
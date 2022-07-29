#!/usr/bin/python

import os
import json
import requests

def getdestinations(key):
   API_ENDPOINT = 'https://api.newrelic.com/graphql'
   #NR_ACCT_ID = os.getenv('NR_ACCT_ID')
   NR_ACCT_ID = '2292606'

   dest_found = False
   headers = {
       "Api-Key": key,
       "Content-Type": "application/json"
   }
   
   data = {"query":"{"
     "actor {"
       "account(id: " + NR_ACCT_ID + ") {"
         "aiNotifications {"
           "destinations {"
             "entities {"
               "id\n name"
             "}"
           "}"
         "}"
       "}"
     "}"
   "}", "variables":""}

   try:
     response = requests.post(API_ENDPOINT, headers=headers, data=json.dumps(data), allow_redirects=False)
   except requests.exceptions.RequestException as e:
     raise SystemExit(e)

   print(response.json())
   
   def find_by_key(data, target):
    for key, value in data.items():
        if isinstance(value, dict):
            yield from find_by_key(value, target)
        elif key == target:
            yield value
   
   for x in find_by_key(response.json(), 'entities'):
     entities = x

   for x in entities:
     print(x['id'])

     data = {"query":"mutation {"
       "aiNotificationsDeleteDestination(accountId: " + NR_ACCT_ID + ", destinationId: " + x['id'] + ") {"
         "ids\n"
         "error {"
           "details"
         "}"
       "}"
     "}", "variables":""}

     try:
       response = requests.post(API_ENDPOINT, headers=headers, data=json.dumps(data), allow_redirects=False)
     except requests.exceptions.RequestException as e:
       raise SystemExit(e)
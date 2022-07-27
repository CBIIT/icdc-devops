#!/usr/bin/python

import os
import json
import requests
from monitors.alerts.channels import set_email_channel

def setalertemail(dest_name, project, tier, key):
   API_ENDPOINT = 'https://api.newrelic.com/graphql'
   NR_ACCT_ID = os.getenv('NR_ACCT_ID')
   EMAIL = os.getenv('EMAIL')

   dest_found = False
   headers = {
       "Api-Key": key,
       "Content-Type": "application/json"
   }
   
   data = {"query":"{"
     "actor {"
       "account(id: " + NR_ACCT_ID + ") {"
         "aiNotifications {"
           "destinations(filters: {"
             "name: \"" + dest_name + "\""
           "}) {"
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

   def find_by_key(data, target):
    for key, value in data.items():
        if isinstance(value, dict):
            yield from find_by_key(value, target)
        elif key == target:
            yield value
   
   for x in find_by_key(response.json(), 'entities'):
     entities = x

   for x in entities:
     if dest_name in x.get("name", "none"):
       dest_found = True
       dest_id = x.get('id')

       data = {"query":"mutation {"
           "aiNotificationsUpdateDestination(accountId: " + NR_ACCT_ID + ", destinationId: \"" + dest_id + "\", destination: {"
             "name: \"" + dest_name + "\""
           "}) {"
             "destination {"
               "id\n"
               "name"
             "}"
           "}"
       "}", "variables":""}

       try:
         response = requests.post(API_ENDPOINT, headers=headers, data=json.dumps(data), allow_redirects=False)
       except requests.exceptions.RequestException as e:
         raise SystemExit(e)

   if not dest_found:
     data = {"query":"mutation {"
         "aiNotificationsCreateDestination(accountId: " + NR_ACCT_ID + ", destination: {"
         "type: EMAIL,"
         "name: \"" + dest_name + "\","
         "properties: ["
           "{"
             "key: \"email\","
             "value: \"" + EMAIL + "\""
           "}"
         "]"
         "}) {"
           "destination {"
             "id\n"
             "name"
           "}"
         "}"
     "}", "variables":""}

     try:
       response = requests.post('{}'.format(API_ENDPOINT), headers=headers, data=json.dumps(data), allow_redirects=False)
     except requests.exceptions.RequestException as e:
       raise SystemExit(e)
     print("Destination {} was created".format(dest_name))
     dest_id = response.json()['data']['aiNotificationsCreateDestination']['destination']['id']
   else:
     print("Destination {} was found".format(dest_name))
   
   channel_id = set_email_channel.setalertemailchannel(dest_name + "-" + project + "-" + tier, dest_id, key)
   
   return(channel_id)
#!/usr/bin/python

import os
import json
import requests
from monitors.alerts.channels import set_slack_channel

def setalertslack(dest_name, project, tier, key):
   API_ENDPOINT = 'https://api.newrelic.com/graphql'
   NR_ACCT_ID = os.getenv('NR_ACCT_ID')

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
       
   if dest_found:
     print("Destination {} was found".format(dest_name))
     channel_id = set_slack_channel.setalertslackchannel(dest_name + "-" + project + "-" + tier, dest_id, tier, key)
     return(channel_id)
   else:
     raise SystemExit("Destination " + dest_name + " not found - this destination must be created in the New Relic UI.")
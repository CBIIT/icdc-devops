#!/usr/bin/python

import json
import requests

def getalertchannels(project, tier, key):
   API_ENDPOINT = 'https://api.newrelic.com/v2/alerts_channels.json'

   headers = {'Api-Key': key}

   try:
     response = requests.get('{}'.format(API_ENDPOINT), headers=headers)
   except requests.exceptions.RequestException as e:
     raise SystemExit(e)

   print('Alert Channels:')
   for x in response.json()['channels']:
     if project.lower() in x.get("name", "none").lower() and tier.lower() in x.get("name", "none").lower():
       print('  ' + x.get("name", "none"))
   print()

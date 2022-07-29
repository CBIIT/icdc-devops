#!/usr/bin/python

import os
import json
import requests
from monitors.alerts.conditions import set_nginx_perf_condition, set_nginx_error_condition

def setnginxalertpolicy(project, tier, key):
   API_ENDPOINT = 'https://api.newrelic.com/v2/alerts_policies.json'

   policy_name = '{}-{} Nginx Policy'.format(project.title(), tier.title())
   policy_found = False
   headers = {'Api-Key': key}

   try:
     response = requests.get('{}'.format(API_ENDPOINT), headers=headers)
   except requests.exceptions.RequestException as e:
     raise SystemExit(e)

   for x in response.json()['policies']:
     if policy_name in x.get("name", "none"):
       policy_found = True
       policy_id = x.get("id", "none")

   headers = {
     "Api-Key": key,
     "Content-Type": "application/json"
   }

   data = {
     "policy": {
       "incident_preference": "PER_POLICY",
       "name": policy_name
     }
   }

   if not policy_found:

     # create policy
     try:
       response = requests.post('{}'.format(API_ENDPOINT), headers=headers, data=json.dumps(data), allow_redirects=False)
     except requests.exceptions.RequestException as e:
       raise SystemExit(e)
     policy_id = response.json()['policy'].get("id", "none")

     try:
       response = requests.put('https://api.newrelic.com/v2/alerts_policy_channels.json', headers=headers, data=json.dumps(data), allow_redirects=False)
     except requests.exceptions.RequestException as e:
       raise SystemExit(e)
     print('{} Created'.format(policy_name))

   else:
     print('{} already exists - updating with the latest configuration'.format(policy_name))

     API_ENDPOINT = 'https://api.newrelic.com/v2/alerts_policies/{}.json'.format(policy_id)

     # update policy
     try:
       response = requests.put('{}'.format(API_ENDPOINT), headers=headers, data=json.dumps(data), allow_redirects=False)
     except requests.exceptions.RequestException as e:
       raise SystemExit(e)

   # add nginx conditions
   set_nginx_perf_condition.setnginxconditions(key, project, tier, policy_id)
   set_nginx_error_condition.setnginxconditions(key, project, tier, policy_id)
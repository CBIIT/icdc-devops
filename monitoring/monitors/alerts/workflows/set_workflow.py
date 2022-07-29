#!/usr/bin/python

import os
import json
import requests

def setalertworkflow(workflow_name, email_id, slack_id, project, tier, key):
   API_ENDPOINT = 'https://api.newrelic.com/graphql'
   NR_ACCT_ID = os.getenv('NR_ACCT_ID')

   workflow_found = False
   headers = {
       "Api-Key": key,
       "Content-Type": "application/json"
   }

   data = {"query":"{"
     "actor {"
       "account(id: " + NR_ACCT_ID + ") {"
         "aiWorkflows {"
           "workflows(filters: {name: \"" + workflow_name + "\"}) {"
             "entities {"
               "id\n"
               "name\n"
               "destinationConfigurations {"
                 "channelId\n"
                 "name\n"
                 "type"
               "}"
             "}"
             "nextCursor\n"
             "totalCount"
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
     if workflow_name in x.get("name", "none"):
       workflow_found = True
       workflow_id = x.get('id')

       data = {"query":"mutation {"
         #"aiWorkflowsUpdateWorkflow(accountId: " + NR_ACCT_ID + ", updateWorkflowData: {name: \"" + workflow_name + "\", issuesFilter: {name: \"" + workflow_name + "\", predicates: [{ attribute: \"policyName\", operator: CONTAINS, values:[\"" + project.capitalize() + "-" + tier.capitalize() + "\"]}], type: FILTER}, destinationConfigurations: [{channelId: \"" + email_id + "\"},{channelId: \"" + slack_id + "\"}], id: \"" + workflow_id + "\"}) {"
         "aiWorkflowsUpdateWorkflow(accountId: " + NR_ACCT_ID + ", updateWorkflowData: {name: \"" + workflow_name + "\", destinationConfigurations: [{channelId: \"" + email_id + "\"},{channelId: \"" + slack_id + "\"}], id: \"" + workflow_id + "\"}) {"
           "workflow {"
             "id\n"
             "name\n"
             "destinationConfigurations {"
               "channelId\n"
               "name\n"
               "type"
             "}"
             "enrichmentsEnabled\n"
             "destinationsEnabled\n"
             "issuesFilter {"
               "accountId\n"
               "id\n"
               "name\n"
               "predicates {"
                 "attribute\n"
                 "operator\n"
                 "values"
               "}"
               "type"
             "}"
             "lastRun\n"
             "workflowEnabled\n"
             "mutingRulesHandling"
           "}"
           "errors {"
             "description\n"
             "type"
           "}"
         "}"
       "}", "variables":""}

       try:
         response = requests.post(API_ENDPOINT, headers=headers, data=json.dumps(data), allow_redirects=False)
       except requests.exceptions.RequestException as e:
         raise SystemExit(e)

   if not workflow_found:
     data = {"query":"mutation {"
       "aiWorkflowsCreateWorkflow(accountId: " + NR_ACCT_ID + ", createWorkflowData: {destinationsEnabled: true, workflowEnabled: true, name: \"" + workflow_name + "\", issuesFilter: {name: \"" + workflow_name + "\", predicates: [{ attribute: \"policyName\", operator: CONTAINS, values:[\"" + project.capitalize() + "-" + tier.capitalize() + "\"]}], type: FILTER}, destinationConfigurations: [{channelId: \"" + email_id + "\"},{channelId: \"" + slack_id + "\"}], enrichmentsEnabled: true, enrichments: {nrql: []}, , mutingRulesHandling: DONT_NOTIFY_FULLY_MUTED_ISSUES}) {"
         "workflow {"
           "id\n"
           "name\n"
           "destinationConfigurations {"
             "channelId\n"
             "name\n"
             "type"
           "}"
           "enrichmentsEnabled\n"
           "destinationsEnabled\n"
           "issuesFilter {"
             "accountId\n"
             "id\n"
             "name\n"
             "predicates {"
               "attribute\n"
               "operator\n"
               "values"
             "}"
             "type"
           "}"
           "lastRun\n"
           "workflowEnabled\n"
           "mutingRulesHandling"
         "}"
         "errors {"
           "description\n"
           "type"
         "}"
       "}"
     "}", "variables":""}

     try:
       response = requests.post('{}'.format(API_ENDPOINT), headers=headers, data=json.dumps(data), allow_redirects=False)
     except requests.exceptions.RequestException as e:
       raise SystemExit(e)
     print("workflow {} created".format(workflow_name))
     workflow_id = response.json()['data']['aiWorkflowsCreateWorkflow']['workflow']['id']
   else:
     print("Workflow {} was found".format(workflow_name))

   return(workflow_id)
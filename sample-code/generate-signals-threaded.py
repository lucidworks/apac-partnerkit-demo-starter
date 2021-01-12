#!/usr/local/bin/python3
#-*- coding:utf-8 -*-

import sys
import requests
import json
import random
import time
from pprint import pprint

from datetime import datetime as dt
from concurrent.futures import ProcessPoolExecutor
from concurrent.futures import ThreadPoolExecutor

# CHANGE=======================================================
# Fusion connection settings
fusion_ip = "f5"
fusion_port = "6764"
fusion_protocol = "http"
fusion_user = "admin" # Fusion username
fusion_password = "password123!" # Fusion password
fusion_app = "movielens" # Fusion App to call API on
fusion_query_profile = "movielens" # Query Profile that will process the user query
fusion_collection = "movielens" # Collection with Signals ENABLED
documentLabel = "title_t" # Name of the field containing the document label
# Example of field containing document label e.g. "product_title"
# Example of document label value e.g.

# CHANGE=======================================================
# IDs of users making search and generating signals
users = ["claire", "andrew", "nick", "masa", "michael"]
# List of query terms used by each user in the users list
queryTerms = {
    users[0]:["lucidworks", "partner program", "fusion 5", "use cases"],
    users[1]:["fusion 5", "fusion", "query intent", "tutorial", "spark"],
    users[2]:["query intent", "classification", "search relevancy", "relevancy"],
    users[3]:["relevancy", "solr", "apache solr", "query intent"],
    users[4]:["apache solr", "machine learning for search", "ml for search", "search optimization"]
}
# Item position(s) each user clicks
documentsToClick = [0,2,4,5]

# CHANGE (OPTIONAL)=======================================================
# Optional data for App Insight 
appList = ["pc"] # Applications generating the signals
ipList = ["10.0.0.1"] # User IP
page_title = "Search" # Search page title
path = "/search" # Search page path

# DO NOT CHANGE=======================================================
# API
queryURL = fusion_protocol+"://"+fusion_ip+":"+fusion_port+"/api/apps/"+fusion_app+"/query/"+fusion_query_profile
signalURL = fusion_protocol+"://"+fusion_ip+":"+fusion_port+"/api/signals/"+fusion_collection


sc=0
s = ["|", "/", "-", "\\", "|" , "/", "-", "\\","|"]
def spin():
    global sc
    #global s
    print("\b" + s[sc%9], flush=True, end="")
    sc = sc + 1

def generateSignals(user,termsArray):
    # For each user send a request for each query in query list
    # termsArray = queryTerms[user]
    totalTerms = len(termsArray)
    current = 1

    # print("@" + user )

    # Create random values for session, app_id, and ip
    session = str(random.getrandbits(128))

    randomIdx = random.randint(0, len(appList)-1)
    app_id = appList[randomIdx]

    randomIdx = random.randint(0, len(ipList)-1)
    ip = ipList[randomIdx]

    # while True :

    for term in termsArray:
        headers = {"Content-Type": "application/json"}
        params = {"q":term,"session":session,"app_id":app_id}
        response = requests.get(queryURL,auth=(fusion_user,fusion_password),headers=headers,params=params)

        if response.status_code == 200 or response.status_code == 204:
            responseJson = response.json()
            responseDocs = responseJson['response']['docs']
            fusionQueryId = responseJson['responseHeader']['params']['fusionQueryId'] 

            requestSignalPayload = [
                {
                    "type": "request",
                    "params": {
                        "query": term,
                        "user_id": user,
                        "session":session,
                        "app_id": app_id,
                        "page_title": page_title,
                        "path": path,
                        "ip_address": ip
                    }
                }
            ]

            requestSignalResponse = requests.post(signalURL,auth=(fusion_user,fusion_password),headers=headers,data=json.dumps(requestSignalPayload))

            if requestSignalResponse.status_code == 200 or requestSignalResponse.status_code == 204:
                pass
            else:
                print('----REQUEST SIGNAL [FAIL] {0} failed with code {1}'.format(requestSignalResponse.text, requestSignalResponse.status_code))

            if len(responseDocs) > 0 :
                for idx in documentsToClick:
                    try:
                        document = responseDocs[idx]
                        clickedDocId = responseDocs[idx]["id"]
                        clickedDocLabel = responseDocs[idx][documentLabel] 
                        clickSignalPayload = [
                            {
                                "type": "click",
                                "params": {
                                    "fusion_query_id": fusionQueryId,
                                    "query": term,
                                    "user_id": user,
                                    "doc_id": clickedDocId,
                                    "session":session,
                                    "app_id":app_id,
                                    "ip_address": ip,
                                    "label": clickedDocLabel
                                }
                            }
                        ]
                        time.sleep(0.2)

                        clickSignalResponse = requests.post(
                            signalURL,
                            auth=(fusion_user,fusion_password),
                            headers=headers,
                            data=json.dumps(clickSignalPayload))

                        if clickSignalResponse.status_code == 200 or clickSignalResponse.status_code == 204:
                            spin() #pass
                        else:
                            print('----CLICK SIGNAL [FAIL] {0} failed with code {1}'.format(clickSignalResponse.text, clickSignalResponse.status_code))

                    except Exception as e:
                        # print(e)
                        print(user + " queried '"+ term + "', but click failed: probably no result at result pos=" + str(idx))
                        break
        else:
            print('QUERY REQUEST {0} failed with code {1}'.format(response.text, response.status_code))
            exit()

if __name__ == '__main__':
    executor = ThreadPoolExecutor(max_workers=len(users))
    # executor = ProcessPoolExecutor(max_workers=len(users))

    for user in users:
        # print(filename)
        executor.submit( generateSignals, user, queryTerms[user] )
    executor.shutdown()

    print ("signals generated : " + str(sc) )

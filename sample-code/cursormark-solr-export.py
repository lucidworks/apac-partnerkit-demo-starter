#!/usr/local/bin/python3
#-*- coding:utf-8 -*-

# this is a simple script to show the use of cursor mark and this will fetch from url (a querypipeline/collection) and store it as csv to a file.

import sys
import requests
import json
#import random
#import time
#from pprint import pprint
import pandas as pd

url = "http://localhost:8983/solr/perproduct_signals/select"

headers = { 
    "Content-Type": "application/json" 
}

currCur = "*"
isDone = False

df_all = pd.DataFrame()

while ( not isDone ) :

    params = {
        "q":"*:*",
        "fl":"id,timestamp_tdt,query_t,user_id,geo_country_iso",
        "wt":"json",
        "sort":"id asc",
        "rows":"100000",
        "cursorMark":currCur
        }  
    
    response = requests.get(
        url,
        headers=headers,
        params=params
        )

    if ( response.status_code != 200 ) :
        print('failed {0}, {1}'.format(response.status_code, response.text))
        break

    responseJson = response.json()
    nextCur = responseJson['nextCursorMark'] 
    
    if ( currCur == nextCur ) :
        print ( "-- end --" )
        break
    
    currCur = nextCur    
    docs = responseJson['response']['docs']
    print ( currCur + " : " + str(len(docs)) )
    df_all = df_all.append(pd.DataFrame(docs), ignore_index=True)

df_all.to_csv('exported.csv',index=False)

# print( df_all )
exit()


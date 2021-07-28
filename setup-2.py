#!/usr/local/bin/python3
#-*- coding:utf-8 -*-

# This script reads the fusion-app/objects.json file and does the following:
#   1. Index Pipeline Stages and Query Pipeline Stages
#       a. Delete stage 'id'
#       b. Delete stage 'secretSourceStageId'
#   2. Parser Stages
#       a. Delete stage 'id'
#   3. Blobs
#       a. Generate a random md5 hash and replace existing hash
#   4. Object Groups and Links
#       a. Each object in objectGroups has an id which is mapped to multiple 
#          objects in 'links' - Generated a new ids that replace each unique 
#          instances of the existing id

from pprint import pprint
import hashlib
import uuid
import json
import os

objects_json_file = "fusion-app/objects.json"
objects = {}

with open(objects_json_file, mode='r') as json_file:
    objects = json.load(json_file)
    indexPipelines = objects["objects"]["indexPipelines"]
    queryPipelines = objects["objects"]["queryPipelines"]
    parsers = objects["objects"]["parsers"]
    blobs = objects["objects"]["blobs"]
    links = objects["objects"]["links"]
    objectGroups = objects["objects"]["objectGroups"]

    # =============================================================
    # 1. Index Pipeline Stages and Query Pipeline Stage
    # =============================================================
    for pipeline in indexPipelines:
        for stage in pipeline["stages"]:
            if "id" in stage:
                del stage["id"]
            if "secretSourceStageId" in stage:
                del stage["secretSourceStageId"]

    for pipeline in queryPipelines:
        for stage in pipeline["stages"]:
            if "id" in stage:
                del stage["id"]
            if "secretSourceStageId" in stage:
                del stage["secretSourceStageId"]
    
    # Update objects json with modified indexPipelines and queryPipelines
    objects["objects"]["indexPipelines"] = indexPipelines
    objects["objects"]["queryPipelines"] = queryPipelines

    # =============================================================
    # 2. Parser Stages
    # =============================================================

    for parser in parsers:
        for stage in parser["parserStages"]:
            if "id" in stage:
                del stage["id"]
    
    # Update parsers in objects
    objects["objects"]["parsers"] = parsers

    # =============================================================
    # 3. Blobs
    #    - Generate new md5 hash using id for each blob object
    # =============================================================

    for blob in blobs:
        if "id" in blob:
            idHash = hashlib.md5(blob["id"].encode())
            blob["md5"] = idHash.hexdigest()

    # Update blobs in objects
    objects["objects"]["blobs"] = blobs

    # =============================================================
    # 4. Object Groups and Links
    # =============================================================

    # newObjectGroups = []

    for group in objectGroups:
        if "id" in group:
            groupID = group["id"]

            # Generate a new UUID using group name - using uuid1()
            newGroupID = str(uuid.uuid1())

            # Set the group's id to the new UUID
            group["id"] = newGroupID
            
            # Iterate through each link item and
            for link in links:
                if link["subject"] == "group:"+groupID:
                    link["subject"] = "group:"+newGroupID

            # Update links in objects
            objects["objects"]["links"] = links
    
    # Update objectGroups in objects
    objects["objects"]["objectGroups"] = objectGroups

json_file.close()

# Overwrite the objects.json file with the modified objects json
with open(objects_json_file, mode='w') as json_file:

    json.dump(objects, json_file, indent=2)

json_file.close()
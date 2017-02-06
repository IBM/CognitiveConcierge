import plistlib
import json
import sys

def generatePlist(workspaceID):
    #read cloud_config.json to parse credentials
    with open(sys.argv[1]+'/../../CognitiveConcierge-Server/cloud_config.json') as data_file:
        cloudConfig = json.load(data_file)

    #get credentials from cloud_config.json
    convCredentials = cloudConfig["vcap"]["services"]["conversation"][0]["credentials"]
    ttsCredentials = cloudConfig["vcap"]["services"]["text_to_speech"][0]["credentials"]
    sttCredentials = cloudConfig["vcap"]["services"]["speech_to_text"][0]["credentials"]
    p1 = dict(
        googlePlacesAPIKey = "",
        ConversationWorkspaceID = workspaceID,
        ConversationUsername = convCredentials["username"],
        ConversationPassword = convCredentials["password"],
        ConversationVersion = "2016-12-23",
        TextToSpeechUsername = ttsCredentials["username"],
        TextToSpeechPassword = ttsCredentials["password"],
        SpeechToTextUsername = sttCredentials["username"],
        SpeechToTextPassword = sttCredentials["password"]
    )
    plistlib.writePlist(p1, sys.argv[1]+'/../../CognitiveConcierge-iOS/CognitiveConcierge/CognitiveConcierge.plist')

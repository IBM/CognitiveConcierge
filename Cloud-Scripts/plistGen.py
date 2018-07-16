import json
import os
import sys

import plistlib


CLOUD_CONFIG_PATH = os.path.join(
    sys.argv[1], '..', '..', 'CognitiveConcierge-Server', 'cloud_config.json')

PLIST_PATH = os.path.join(
    sys.argv[1], '..', '..', 'CognitiveConcierge-iOS', 'CognitiveConcierge',
    'CognitiveConcierge.plist')


def generatePlist(workspaceID):
    # read cloud_config.json to parse credentials
    with open(CLOUD_CONFIG_PATH) as data_file:
        cloudConfig = json.load(data_file)

    # get credentials from cloud_config.json
    vcap_services = cloudConfig["vcap"]["services"]
    convCredentials = vcap_services["conversation"][0]["credentials"]
    ttsCredentials = vcap_services["text_to_speech"][0]["credentials"]
    sttCredentials = vcap_services["speech_to_text"][0]["credentials"]
    p1 = {
        'googlePlacesAPIKey': "",
        'ConversationWorkspaceID': workspaceID,
        'ConversationUsername': convCredentials["username"],
        'ConversationPassword': convCredentials["password"],
        'ConversationVersion': "2016-12-23",
        'TextToSpeechUsername': ttsCredentials["username"],
        'TextToSpeechPassword': ttsCredentials["password"],
        'SpeechToTextUsername': sttCredentials["username"],
        'SpeechToTextPassword': sttCredentials["password"],
    }

    # write the plist file
    plistlib.writePlist(p1, PLIST_PATH)

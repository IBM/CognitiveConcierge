import json
import os
import sys

import watson_developer_cloud

sys.path.append(sys.argv[1] + "/../")
import plistGen


CLOUD_CONFIG_PATH = os.path.join(
    sys.argv[1], '..', '..', 'CognitiveConcierge-Server', 'cloud_config.json')

WORKSPACE_PATH = os.path.join(
    sys.argv[1], '..', '..', 'Resources', 'conversationWorkspace.json')

# Load credentials file.
with open(CLOUD_CONFIG_PATH, 'r') as data_file:
    cloudConfig = json.load(data_file)

# Extract assistant service credentials.
vcap_services = cloudConfig['vcap']['services']
asstCredentials = vcap_services["conversation"][0]["credentials"]

# Instantiate a client instance.
assistant = watson_developer_cloud.AssistantV1(
    version='2018-07-06',
    url=asstCredentials.get(
        'url', watson_developer_cloud.AssistantV1.default_url),
    iam_api_key=asstCredentials.get('apikey'),
    username=asstCredentials.get('username'),
    password=asstCredentials.get('password'))

# Parse file for payload to create conversation workspace
with open(WORKSPACE_PATH, 'r') as json_data:
    payload = json.load(json_data)

# Create conversation workspace
data = assistant.request(
    method='POST',
    url='/v1/workspaces',
    headers={},
    params={'version': assistant.version},
    json=payload,
    accept_json=True)

plistGen.generatePlist(data["workspace_id"])

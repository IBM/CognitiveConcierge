import httplib
import base64
import json
import sys
from urlparse import urlparse
sys.path.append(sys.argv[1]+"/../")
from plistGen import generatePlist

#read cloud_config.json to parse credentials
with open(sys.argv[1]+'/../../CognitiveConcierge-Server/cloud_config.json') as data_file:
    cloudConfig = json.load(data_file)
convCredentials = cloudConfig["vcap"]["services"]["conversation"][0]["credentials"]

#encode the username and password for basic auth
base64string = base64.encodestring('%s:%s' % (convCredentials["username"], convCredentials["password"]))[:-1]

# Parse conversationWorkspace.json file for payload to create conversation workspace
with open(sys.argv[1]+'/../../Resources/conversationWorkspace.json') as json_data:
    d = json.load(json_data)
payload = json.dumps(d)

#get conversation URL, set up post request
convURL = urlparse(convCredentials["url"])
conn = httplib.HTTPSConnection(convURL.netloc)
headers = {
    'content-type': "application/json",
    'authorization': "Basic %s" % base64string,
    'cache-control': "no-cache"
    }
conn.request("POST", convURL.path+"/v1/workspaces?version=2016-09-20", payload, headers)
res = conn.getresponse()
data = json.loads(res.read())

workspaceid = data["workspace_id"]
generatePlist(workspaceid)

#!/bin/sh
set -e
function install_bluemix_cli() {
#statements
echo "Installing Bluemix cli"
curl -L "https://cli.run.pivotal.io/stable?release=linux64-binary&source=github" | tar -zx
sudo mv cf /usr/local/bin
sudo curl -o /usr/share/bash-completion/completions/cf https://raw.githubusercontent.com/cloudfoundry/cli/master/ci/installers/completion/cf
cf --version
curl -L public.dhe.ibm.com/cloud/bluemix/cli/bluemix-cli/Bluemix_CLI_0.5.4_amd64.tar.gz > Bluemix_CLI.tar.gz
tar -xvf Bluemix_CLI.tar.gz
cd Bluemix_CLI
sudo ./install_bluemix_cli
}

function bluemix_auth() {
echo "Authenticating with Bluemix"
echo "y" | bx login -a https://api.ng.bluemix.net --apikey $API_KEY
#bx login -a https://$BLUEMIX_REGION -u lbenn@us.ibm.com -p $BLUEMIX_PWD -s applications-dev -o $BLUEMIX_ORGANIZATION - 
}

function deploy_application() {
  #statements
  echo "Creating services..."
  bx service create conversation free "CognitiveConcierge-Conversation"
  bx service create speech_to_text standard "CognitiveConcierge-Speech-To-Text"
  bx service create text_to_speech standard "CognitiveConcierge-Text-To-Speech"
  bx service create natural-language-understanding free "CognitiveConcierge-NLU"
  echo "Services created."
  git clone https://github.com/IBM/CognitiveConcierge.git
  cd CognitiveConcierge
  echo "Starting Application"
  bx app push
  echo "Application Started"
}

function destroy_application() {
  #statements
  echo "Destroying application"
  echo "y" | bx app delete CognitiveConcierge
  echo "y" | bx service delete CognitiveConcierge-NLU
  echo "y" | bx service delete CognitiveConcierge-Text-To-Speech
  echo "y" | bx service delete CognitiveConcierge-Speech-To-Text
  echo "y" | bx service delete CognitiveConcierge-Conversation
}

install_bluemix_cli
bluemix_auth
deploy_application
destroy_application

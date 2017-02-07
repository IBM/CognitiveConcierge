[![Apache 2](https://img.shields.io/badge/license-Apache2-blue.svg?style=flat)](https://www.apache.org/licenses/LICENSE-2.0)
![Bluemix Deployments](https://deployment-tracker.mybluemix.net/stats/f4ae263f304ffe32cbb17f3238c3ac86/badge.svg)

[![cognitive concierge video](http://img.youtube.com/vi/kQqE0hMg0Q8/0.jpg)](http://www.youtube.com/watch?v=kQqE0hMg0Q8 "Video Title")

# CognitiveConcierge
CognitiveConcierge is an end-to-end Swift application sample with an iOS front end and a Kitura web framework back end. This application also demonstrates how to pull in a number of different Watson services to your Swift client and server side apps via the Watson Developer Cloud's iOS SDKs, including Conversation, Text to Speech, Speech to Text, and the Alchemy Language APIs.

<img src="images/CC1.png" width="250"><img src="images/CC2.png" width="250"><img src="images/CC7.png" width="250">

## IBM Cloud Tools for Swift (ICT) Instructions
### Obtain a Google Places API Key for Web
1. For this project, you'll need an API Key from Google Places, so that app can have access to review text which will be sent to the Alchemy API service for analysis.  Instructions for obtaining a key can be found [here](https://developers.google.com/places/web-service/get-api-key).
2. Once you have an API Key, go to the Google Developer's Console, and enable the Google Places API for iOS as well.  Make note of the API key for later use in your server and iOS applications.

### Deploy the Server Application to Bluemix using ICT.
1. Install [IBM Cloud Tools for Swift] (http://cloudtools.bluemix.net/) for MacOS.
2. Once you've installed the application, you can open it to get started.
3. Click the Create (+) button to set up a new project, and then select the Cognitive Concierge Application.
4. Click Save Files to Local Computer to clone the project.
5. Once the project is cloned, open up the .xcodeproj file that was created for you in ICT under Local Server Repository. Edit the Sources/restaurant-recommendations/Configuration.swift file's Constants struct with your own Google API Key for Web.

	<img src="images/xcodeproj.png" width="500">

6. Finally, you can use ICT to deploy the updated server to Bluemix.  Click Provision and Deploy Sample Server on Bluemix under Cloud Runtimes.

	<img src="images/provision.png" width="500">

7. Give your Cloud Runtime a unique name, and click Next.  This deployment to Bluemix may take a few minutes.

### Point iOS Application to Server Application
1. In ICT, ensure that the Connected to: field in the Client application is pointed to your server instance running on Bluemix.  You can also point to your localhost for local testing, but you need to be running a local instance of the server application for this to work.

### Conversation Service Created and Updated by ICT
1. Once ICT has provisioned your Cloud Runtime, you should see that you have a Conversation Service instance in your Bluemix dashboard.  This Service enables you to add a natural language interface to your applications.  While you could create a conversation tree manually, ICT has run some set up scripts (found in the `Cloud-Scripts/conversation` folder) to add a populated workspace to your conversation service.  This workspace is populated using the json found in `Resources/conversationWorkspace.json`


### Run the iOS Application
1. Install Cocoapods Dependency Manager in Terminal with the command `sudo gem install cocoapods`

2. Install Carthage Dependency Manager.  Either download and run the .pkg file for their latest release https://github.com/Carthage/Carthage/releases or simply run `brew update` followed by `brew install carthage`
3. From Terminal, change directories into the YourProjectName/CognitiveConcierge-iOS folder.
4. Run the following commands to install the necessary dependencies:
  ```
  carthage update --platform iOS

  pod install
  ```
5. Open the CognitiveConcierge.xcworkspace file in Xcode 8.2 either from ICT or from your terminal using `open CognitiveConcierge.xcworkspace`

6. For your iOS application to run, it needs access to some credentials from Bluemix.  ICT has run some set up scripts to generate and populate the `CognitiveConcierge-iOS/CognitiveConcierge/CognitiveConcierge.plist` file. You will need to open this file and add your Google API Key.

7. Press the Play button in Xcode to build and run the project in the simulator or on your iPhone!

## Privacy Notice
This Swift application includes code to track deployments to [IBM Bluemix](https://www.bluemix.net/) and other Cloud Foundry platforms. The following information is sent to a [Deployment Tracker](https://github.com/IBM-Bluemix/cf-deployment-tracker-service) service on each deployment:

* Swift project code version (if provided)
* Swift project repository URL
* Application Name (`application_name`)
* Space ID (`space_id`)
* Application Version (`application_version`)
* Application URIs (`application_uris`)
* Labels of bound services
* Number of instances for each bound service and associated plan information

This data is collected from the parameters of the `CloudFoundryDeploymentTracker`, the `VCAP_APPLICATION` and `VCAP_SERVICES` environment variables in IBM Bluemix and other Cloud Foundry platforms. This data is used by IBM to track metrics around deployments of sample applications to IBM Bluemix to measure the usefulness of our examples, so that we can continuously improve the content we offer to you. Only deployments of sample applications that include code to ping the Deployment Tracker service will be tracked.

### Disabling Deployment Tracking
Deployment tracking can be disabled by removing the following line from main.swift:
```
CloudFoundryDeploymentTracker(repositoryURL: "https://github.ibm.com/MIL/CognitiveConcierge", codeVersion: nil).track()

```

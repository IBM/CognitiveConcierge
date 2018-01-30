///**
//* Copyright IBM Corporation 2016
//*
//* Licensed under the Apache License, Version 2.0 (the "License");
//* you may not use this file except in compliance with the License.
//* You may obtain a copy of the License at
//*
//* http://www.apache.org/licenses/LICENSE-2.0
//*
//* Unless required by applicable law or agreed to in writing, software
//* distributed under the License is distributed on an "AS IS" BASIS,
//* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//* See the License for the specific language governing permissions and
//* limitations under the License.
//*/
//
import Kitura
import Foundation
import KituraNet
import LoggerAPI
import MetricsTrackerClient

struct Constants {
    static var googleAPIKey = "INSERT_GOOGLE_API_KEY_HERE"
    static var location = "36.11,-115.17" //choose your latitude and longitude for recommendations
}

do {
    MetricsTrackerClient(repository: "CognitiveConcierge", organization: "IBM").track()
    let controller = try Controller()
    Kitura.addHTTPServer(onPort: controller.port, with: controller.router)
    Kitura.run()
} catch {
    Log.error("Oops... something went wrong. Server did not start!")
}


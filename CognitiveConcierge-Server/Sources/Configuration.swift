/**
* Copyright IBM Corporation 2016
*
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
* http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*/

import Foundation
import SwiftyJSON
import LoggerAPI
import CloudFoundryEnv

struct Constants {
    static var googleAPIKey = "INSERT_GOOGLE_API_KEY_HERE"
    static var location = "36.11,-115.17"
}

struct ConfigurationError : LocalizedError {
    var errorDescription: String? { return "Could not read configuration information" }
}

func getConfiguration(configFile: String, serviceName: String) throws -> Service {
    var appEnv: AppEnv
    do {
        let path = getAbsolutePath(relativePath: "/\(configFile)", useFallback: false)
        if path != nil {
            let data = try Data(contentsOf: URL(fileURLWithPath: path!))
            let configJson = JSON(data: data)
            appEnv = try CloudFoundryEnv.getAppEnv(options: configJson)
            Log.info("Using configuration values from '\(configFile)'.")
        } else {
            Log.warning("No \(configFile) using CloudFoundry environment instead.")
            appEnv = try CloudFoundryEnv.getAppEnv()
        }

        guard let service = appEnv.getService(spec: serviceName) else {
            throw ConfigurationError()
        }

        return service

    } catch {
        Log.warning("An error occurred while trying to read configurations.")
        throw ConfigurationError()
    }
}

func getAbsolutePath(relativePath: String, useFallback: Bool) -> String? {
    let initialPath = #file
    let components = initialPath.characters.split(separator: "/").map(String.init)
    let notLastTwo = components[0..<components.count - 2]
    var filePath = "/" + notLastTwo.joined(separator: "/") + relativePath
    let fileManager = FileManager.default

    if fileManager.fileExists(atPath: filePath) {
        return filePath
    } else if useFallback {
        // Get path in alternate way, if first way fails
        let currentPath = fileManager.currentDirectoryPath
        filePath = currentPath + relativePath
        return fileManager.fileExists(atPath: filePath) ? filePath : nil
    } else {
        return nil
    }
}

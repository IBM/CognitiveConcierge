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
 **/

import UIKit

class BluemixConfiguration: NSObject {
    
    //Plist Keys
    private let kBluemixKeysPlistName = "bluemix"
    private let kIsLocalKey = "isLocal"
    private let kAppRouteLocal = "appRouteLocal"
    private let kAppRouteRemote = "appRouteRemote"
    
    var isLocal: Bool = true
    let localBaseRequestURL: String
    let remoteBaseRequestURL: String
    
    override init() {
        if let path = Bundle.main.path(forResource: kBluemixKeysPlistName, ofType: "plist"),
            let plist = NSDictionary(contentsOfFile: path),
            let isLocal              = plist[kIsLocalKey] as? Bool,
            let localBaseRequestURL  = plist[kAppRouteLocal] as? String,
            let remoteBaseRequestURL = plist[kAppRouteRemote] as? String {
            
            self.isLocal = isLocal
            self.localBaseRequestURL = localBaseRequestURL
            self.remoteBaseRequestURL = remoteBaseRequestURL
            
            super.init()
            
        } else {
            fatalError("Could not load bluemix plist into object properties")
        }
    }
    
}

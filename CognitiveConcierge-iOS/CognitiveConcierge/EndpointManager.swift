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
import Alamofire
import GooglePlaces

class EndpointManager: NSObject {
    
    static let sharedInstance = EndpointManager()
    
    // forces people to not make a new instance. must use shared instance.
    private override init () {
        super.init()
    }
    
    //configuration for URL based on bluemix.plist, populated by ICT or manually.
    let config = BluemixConfiguration()
    
    func requestRestaurantRecommendations(endpoint: String, failure: @escaping ([Restaurant]) -> Void, success: @escaping ([Any]) -> Void) {
        let url = getBaseRequestURL() + "/api/v1/restaurants?occasion=" + endpoint
        
        // Execute REST request to get all restaurant recommendations from API
        Alamofire.request(url, encoding: JSONEncoding.default).responseJSON { response in
            switch response.result {
            case .success(let theJSON):
                let jsonResponse = theJSON as! [Any]
                success(jsonResponse)

            case .failure(let err):
                print ("using mock data due to err: \(err)")
                if endpoint == "date" {
                    failure(self.useMockData(fileNameSetting: "anniversary"))
                }
                failure(self.useMockData(fileNameSetting: endpoint))
            }
        }
    }

    func useMockData(fileNameSetting: String) -> [Restaurant] {
        var restaurants = [Restaurant]()
        guard let path = Bundle.main.url(forResource: fileNameSetting, withExtension: "json") else {
            print("unable to find path")
            return restaurants
        }
        if let restaurantData = try? Data(contentsOf: path) {
            do {
                let json = try JSONSerialization.jsonObject(with: restaurantData, options: .allowFragments)
                if let dict = json as? [String: Any], let jsonRestaurants = dict["restaurants"] as? [[String: Any]] {
                    restaurants = Utils.parseRecommendationsJSON(recommendations: jsonRestaurants)
                }
            } catch let error as NSError {
                print ("json error: \(error.localizedDescription)")
            }
        }
        return restaurants
    }
    
    func getBaseRequestURL() -> String {
        return config.isLocal ? config.localBaseRequestURL : config.remoteBaseRequestURL
    }
}

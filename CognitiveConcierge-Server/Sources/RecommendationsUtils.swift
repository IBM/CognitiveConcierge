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
import KituraNet
import LoggerAPI

//read reviews from JSON function
typealias RestaurantJ = JSON
typealias RestaurantDetails = JSON

func bestMatches(_ restaurants: [Restaurant], occasion: String) -> [JSON] {
    let maxMatches = 5

    //compare restaurant review keywords with occasion keywords
    let occasionGen = OccasionGenerator()
    let occasionKeywords = occasionGen.getOccasionKeywords(occasion)
    var bestMatches=[Restaurant]()
    var matches=[JSON]()

    for restaurant in restaurants {
        let restKeywords = restaurant.getWatsonKeywords()
        for keyword in restKeywords {
            if occasionKeywords.contains(keyword) {
                restaurant.incrementMatchScore()
            }
        }
        bestMatches.append(restaurant)
        if bestMatches.count == restaurants.count {
            bestMatches.sort(by: {$0.getMatchScore() > $1.getMatchScore()})
            if bestMatches.count > maxMatches {
                bestMatches.removeSubrange(maxMatches...bestMatches.count-1)
            }
            for match in bestMatches {
                let restJSON = JSON(["googleID":match.getGoogleID(),"openNow":match.getIsOpenNow(),"openingTimeNow":match.getOpeningTimeNow(),"reviewScore":match.getMatchScore(),"name":match.getName(),"rating":match.getRating(),"expense":match.getExpense(),"address":match.getAddress(),"reviews":match.getReviews(), "positiveSentiment":match.getPositiveSentiments(), "negativeSentiment":match.getNegativeSentiments(), "website":match.getWebsite()])
                matches.append(restJSON)
            }
        }
    }
    return matches
}


/// Returns closest restaurants that match the location. Currently limited to return the nearest 20.
func getClosestRestaurants(_ occasion:String, success: ([RestaurantJ]) -> Void) {
    Log.verbose("Getting closest restaurants")

    let path = "/maps/api/place/nearbysearch/json" + "?"
        + "key=" + googleAPIKey + "&" // api key
        + "location=" + Constants.location + "&" // replace with the location we want to search in
        + "rankby=distance" + "&" // rank the results by distance to get the closest 20
        + "type=restaurant" // the type of place we want to search
        + "&keyword="+occasion // we can insert keywords to search for here
    var requestOptions: [ClientRequest.Options] = []
    requestOptions.append(.method("GET"))
    requestOptions.append(.schema("https://"))
    requestOptions.append(.hostname("maps.googleapis.com"))
    requestOptions.append(.path(path))

    var closestRestaurants: [JSON] = []

    let req = HTTP.request(requestOptions) { resp in
        if let resp = resp, resp.statusCode == HTTPStatusCode.OK {
            do {
                var body = Data()
                try resp.readAllData(into: &body)
                let response = try JSON(data: body)
                let errorMessage = response["error_message"]
                if let errorMessageStr = errorMessage.rawString(), errorMessageStr != "null" {
                    Log.error("Error in closest restaurants response: " + errorMessageStr)
                }
                closestRestaurants = response["results"].arrayValue

            } catch {
                Log.error("Error parsing JSON from closest restaurants response")
            }
        } else {
            if let resp = resp {
                //request failed
                Log.error("Error retrieving closest restaurants; status code \(resp.statusCode) returned")
            } else {
                Log.error("Error retrieving closest restaurants")
            }
        }
    }
    req.end()
    success(closestRestaurants)
}

func getRestaurantDetails(_ restaurantID: String, success: (RestaurantDetails) -> Void) {
    Log.verbose("Getting restaurant details")

    let path = "/maps/api/place/details/json" + "?"
        + "key="+googleAPIKey + "&" // api key
        + "placeid=\(restaurantID)" // the ID of the restaurant we want details for

    var restaurantDetails: JSON = JSON("")

    var requestOptions: [ClientRequest.Options] = []
    requestOptions.append(.method("GET"))
    requestOptions.append(.schema("https://"))
    requestOptions.append(.hostname("maps.googleapis.com"))
    requestOptions.append(.path(path))
    let req = HTTP.request(requestOptions) { resp in
        if let resp = resp, resp.statusCode == HTTPStatusCode.OK {
            do {
                var body = Data()
                try resp.readAllData(into: &body)
                let response = try JSON(data: body)
                let errorMessage = response["error_message"]
                if let errorMessageStr = errorMessage.rawString(), errorMessageStr != "null" {
                    Log.error("Error in restaurant details response: " + errorMessageStr)
                }

                restaurantDetails = response["result"]
            } catch {
                Log.error("Error parsing JSON from restaurant details response")
            }
        } else {
            if let resp = resp {
                //request failed
                Log.error("Error retrieving restaurant details; status code \(resp.statusCode) returned")
            } else {
                Log.error("Error retrieving restaurant details")
            }
        }
    }
    req.end()
    success(restaurantDetails)
}

public func parsePeriods(periods: [JSON]) -> [String] {
    let date = Date()
    var times = [String]()

    // Grab day
    guard let dayOfWeek = date.dayOfWeek() else {
        Log.error("unable to grab day of the week")
        return times
    }

    for period in periods {
        if period["open"]["day"].int == dayOfWeek {
            // check if there's a closing time according to API:
            if !period["close"].exists() {
                // open all day
                return ["Open 24 Hours"]
            }
            // May have more than one opening time in a day:
            if let openTime = period["open"]["time"].string {
                times.append(openTime)
            }

            if let closeTime = period["close"]["time"].string {
                times.append(closeTime)
            }
        }
    }
    return times
}

public func parseAddress() -> (String, Int) {
    let args = Array(ProcessInfo.processInfo.arguments[1..<ProcessInfo.processInfo.arguments.count])
    var port = 8090 // default port
    var ip = "0.0.0.0" // default ip
    if args.count == 2 && args[0] == "-bind" {
        let tokens = args[1].components(separatedBy: ":")
        if tokens.count == 2 {
            ip = tokens[0]
            if let portNumber = Int(tokens[1]) {
                port = portNumber
            }
        }
    }
    return (ip, port)
}

extension Date {
    func dayOfWeek() -> Int? {
        let cal: Calendar = Calendar.current
        let weekday = cal.component(.weekday, from: Date())
        return weekday
    }
}

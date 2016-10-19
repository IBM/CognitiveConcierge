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

import Kitura
import HeliumLogger
import Foundation
import KituraNet
import SwiftyJSON
import LoggerAPI
import CloudFoundryDeploymentTracker


HeliumLogger.use()
let configFile = "cloud_config.json"
let alchemyServiceName = "CognitiveConcierge-Alchemy"

let router = Router()
//router.all("/static", middleware: StaticFileServer())

router.get("/") {
    request, response, next in
    response.send("Hello, World!")
    next()
}

router.get("/places") {
    request, response, next in

    guard let occasion = request.queryParameters["occasion"] else {
        //response.status(HTTPStatusCode.badRequest)
        //Log.error("Request does not contain occasion")
        return
    }
    response.headers["Content-Type"] = "text/plain; charset=utf-8"
}

// Get restaurant reviews
router.get("/api/v1/restaurants") { request, response, next in
    guard let occasion = request.queryParameters["occasion"] else {
        //response.status(HTTPStatusCode.badRequest)
        //Log.error("Request does not contain occasion")
        return
    }
    response.headers["Content-Type"] = "text/plain; charset=utf-8"
    Log.verbose("getting restaurant reviews")
    getClosest20Restaurants(occasion) { restaurants in

        var restaurantDetails = [JSON]()
        var theRestaurants = [Restaurant]()
        for restaurant in restaurants {
            let restaurantID = restaurant["place_id"].stringValue

            getRestaurantDetails(restaurantID) { details in
                var theReviews = [String]()
                var isOpenNow: Bool
                //if no expense, set to 0
                let expense = restaurant["price_level"].int ?? 0
                let name = restaurant["name"].string ?? ""
                let isOpenNowInt = restaurant["opening_hours"]["open_now"].int ?? 0
                if isOpenNowInt == 0 {
                    isOpenNow = false
                } else {
                    isOpenNow = true
                }

                let periods = details["opening_hours"]["periods"].array ?? [""]
                let rating = restaurant["rating"].double ?? 0
                let address = details["formatted_address"].string ?? ""
                let reviews = details["reviews"].array ?? ["text"]
                let website = details["website"].string ?? ""
                for review in reviews {
                    var reviewText = review["text"].string ?? ""
                    reviewText = reviewText.replacingOccurrences(of: "\"", with: " \\\"")
                    reviewText = reviewText.replacingOccurrences(of: "\n", with: " ")
                    theReviews.append(reviewText)
                }

                let openingTimeNow = parsePeriods(periods: periods)

                let theRestaurant = Restaurant(googleID: restaurantID, isOpenNow: isOpenNow, openingTimeNow: openingTimeNow, name: name, rating: rating, expense: expense, address: address, reviews: theReviews, website: website)
                theRestaurant.populateWatsonKeywords({(result) in
                    let restKeywords = result
                    theRestaurants.append(theRestaurant)
                    }, failure: { error in
                        do {
                            try response.status(.failedDependency).send(json: JSON(error)).end()
                        } catch {
                            print( "error")
                        }
                    })
                restaurantDetails.append(details)
            }
        }
        let matches = bestMatches(theRestaurants, occasion: occasion)
        do {
            try response.status(.OK).send(JSON(matches).rawString()!).end()
        } catch {
            print("error")
        }
    }
}


let (ip, port) = parseAddress()

CloudFoundryDeploymentTracker(repositoryURL: "https://github.ibm.com/MIL/CognitiveConcierge", codeVersion: nil).track()
Kitura.addHTTPServer(onPort: port, with: router)
Kitura.run()

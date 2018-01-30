//
//  File.swift
//  restaurant-recommendations
//
//  Created by Belinda V on 3/8/17.
//
//

import Foundation
import Kitura
import CloudEnvironment
import LoggerAPI
import SwiftyJSON

private let cloudEnv = CloudEnv()
private let nluServiceName = "CognitiveConcierge-NLU"
var nluCreds = cloudEnv.getNaturalLangUnderstandingCredentials(name: nluServiceName)

public class Controller {
    public let router: Router
    private let nluServiceName = "CognitiveConcierge-NLU"
    
    public var port: Int {
        get { return cloudEnv.port }
    }
    
    public init() throws {
        router = Router()
        router.all("/api/v1/restaurants", middleware:BodyParser())
        router.get("/api/v1/restaurants", handler: getRecommendations)
    }
    
    public func getRecommendations(request: RouterRequest, response: RouterResponse, next: @escaping() -> Void) throws {
        
        guard let occasion = request.queryParameters["occasion"] else {
            response.status(.badRequest)
            Log.error("Request does not contain occasion")
            return
        }
        response.headers["Content-type"] = "text/plain; charset=utf-8"
        getClosestRestaurants(occasion) { restaurants in
            
            var restaurantDetails = [JSON]()
            var theRestaurants = [Restaurant]()
            for restaurant in restaurants {
                let restaurantID = restaurant["place_id"].stringValue
                
                getRestaurantDetails(restaurantID) { details in
                    Log.verbose("Restaurant details returned")
                    //if no expense, set to 0
                    let expense = restaurant["price_level"].int ?? 0
                    let name = restaurant["name"].string ?? ""
                    let isOpenNowInt = restaurant["opening_hours"]["open_now"].int ?? 0
                    let isOpenNow = isOpenNowInt == 0 ? false : true
                    let periods = details["opening_hours"]["periods"].array ?? [""]
                    let rating = restaurant["rating"].double ?? 0
                    let address = details["formatted_address"].string ?? ""
                    let website = details["website"].string ?? ""
                    let reviews = details["reviews"].array ?? ["text"]
                    var theReviews = [String]()
                    Log.verbose("Replacing special characters in reviews")
                    for review in reviews {
                        var reviewText = review["text"].string ?? ""
                        reviewText = reviewText.replacingOccurrences(of: "\"", with: " \\\"")
                        reviewText = reviewText.replacingOccurrences(of: "\n", with: " ")
                        theReviews.append(reviewText)
                    }
                    
                    let openingTimeNow = parsePeriods(periods: periods)
                    
                    let theRestaurant = Restaurant(googleID: restaurantID, isOpenNow: isOpenNow, openingTimeNow: openingTimeNow, name: name, rating: rating, expense: expense, address: address, reviews: theReviews, website: website)
                    theRestaurant.populateWatsonKeywords({(result) in
                        theRestaurants.append(theRestaurant)
                    }, failure: { error in
                        do {
                            try response.status(.failedDependency).send(json: error).end()
                        } catch {
                            Log.error(error.localizedDescription)
                        }
                    })
                    restaurantDetails.append(details)
                }
            }
            let matches = bestMatches(theRestaurants, occasion: occasion)
            do {
                try response.status(.OK).send(JSON(matches).rawString() ?? "").end()
            } catch {
                Log.error("Error responding with restaurant matches")
            }
        }
        print(response)
    }
}



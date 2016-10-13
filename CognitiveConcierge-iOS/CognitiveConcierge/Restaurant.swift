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

import Foundation

class Restaurant {
    
    private var openNowStatus: Bool
    private var openingTimeNow: Array<String>
    private var name: String
    private var rating: Double
    private var expense: Int
    private var address: String
    private var reviews: Array<String>
    private var matchScore: Int
    private var matchPercentage: Double
    private var keywords: Array<String>
    private var googleID: String
    private var image: String?
    private var website: String
    
    var negativeSentiments: Array<String>
    var positiveSentiments: Array<String>
    
    //MARK: Initializer
    init(openNowStatus: Bool, openingTimeNow: Array<String>, name: String, googleID: String, rating: Double, expense: Int, address: String, reviews: Array<String>, negativeSentiments: Array<String>, positiveSentiments: Array<String>, image: String?, website: String) {
        self.openNowStatus = openNowStatus
        self.openingTimeNow = openingTimeNow
        self.name = name
        self.googleID = googleID
        self.rating = rating
        self.expense = expense
        self.address = address
        self.reviews = reviews
        self.matchScore = 0
        self.matchPercentage = 0
        self.keywords = []
        self.negativeSentiments = negativeSentiments
        self.positiveSentiments = positiveSentiments
        self.image = image
        self.website = website
    }
    
    //increment the match score by 1
    func incrementMatchScore() {
        self.matchScore += 1
    }
    //Getters
    func getOpenNowStatus() -> Bool {
        return self.openNowStatus
    }
    func getOpeningTimeNow() -> Array<String> {
        return self.openingTimeNow
    }
    func getName() -> String {
        return self.name
    }
    func getGoogleID() -> String {
        return self.googleID
    }
    func getRating() -> Double {
        return self.rating
    }
    func getExpense() -> Int {
        return self.expense
    }
    func getAddress() -> String {
        return self.address
    }
    func getReviews() -> Array<String> {
        return self.reviews
    }
    func getMatchScore() -> Int {
        return self.matchScore
    }
    func getMatchPercentage() -> Double {
        return self.matchPercentage
    }
    func getWatsonKeywords() -> Array<String> {
        return self.keywords
    }
    func getNegativeSentiments() ->Array<String> {
        return self.negativeSentiments
    }
    func getPositiveSentiments() -> Array<String> {
        return self.positiveSentiments
    }
    func getImage() -> String? {
        return self.image
    }
    func getWebsite() -> String {
        return self.website
    }
    
    //Setters
    func setMatchPercentage(percentage: Double) {
        self.matchPercentage = percentage
    }
    
    
}

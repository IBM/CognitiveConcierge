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
import MapKit
import CoreLocation

class RestaurantDetailViewController: UIViewController {

    var chosenRestaurant:Restaurant!    /* Restaurant chosen by the user to see details. */
    var reviewKeywords:String!
    
    @IBOutlet weak var eventDetailHolderView: UIView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var scrollViewContentView: UIView!
    @IBOutlet weak var restaurantDetailHolderView: UIView!
    
    let kBackButtonTitle = "RESTAURANTS"
    /// restaurant detail view
    weak var restaurantDetailView: RecommendedRestaurantDetailView!
    private let buttonFrame = CGRect.init(x: 31, y: 39.5, width: 109, height: 13)

    /**
    Method called upon view did load to set up holderView, map, and adds subview
    */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpHolderViewWithRestaurant()
        setupRecommendedRestaurantDetailView()
        eventDetailHolderView.addSubview(restaurantDetailView)
        
        // set up navigation items.

        Utils.setNavigationItems(self, rightButtons: [MoreIconBarButtonItem()], leftButtons: [WhitePathIconBarButtonItem(), UIBarButtonItem(customView: backButton)])
        Utils.setupNavigationTitleLabel(self, title: "", spacing: 1.0, titleFontSize: 17, color: UIColor.whiteColor())
        
        self.navigationController?.navigationBarHidden = false
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = false
        // Set up the navigation bar so that we can color the nav bar to be dark blue, and the default symbols to be white.
        Utils.setupBackButton(backButton, title: kBackButtonTitle, textColor: UIColor.whiteColor(), frame: buttonFrame)
        
        // set up navigation items.
        Utils.setNavigationItems(self, rightButtons: [MoreIconBarButtonItem()], leftButtons: [WhitePathIconBarButtonItem(), UIBarButtonItem(customView: backButton)])
        Utils.setupNavigationTitleLabel(self, title: "", spacing: 1.0, titleFontSize: 17, color: UIColor.whiteColor())
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.navigationController?.navigationBarHidden = true
    }
    
    @IBAction func didPressBackButton(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func setupRecommendedRestaurantDetailView() {
        
        // splice the restaurant address into address, city, state.
        var locationAddress = self.chosenRestaurant.getAddress().componentsSeparatedByString(",")
        
        // load data into restaurant details view
        restaurantDetailView.setupData(self.chosenRestaurant.getOpenNowStatus(),
                                       openingTimeNow: self.chosenRestaurant.getOpeningTimeNow(),
                                       locationName:self.chosenRestaurant.getName(),
                                       locationAddress: locationAddress[0],
                                       city: "\(locationAddress[1]),\(locationAddress[2])",
                                       fullAddress: self.chosenRestaurant.getAddress(),
                                       priceLevel: Double(self.chosenRestaurant.getExpense()),
                                       rating: self.chosenRestaurant.getRating(),
                                       reviewNegativeHighlight: self.determineReviewSentiment("negative"),
                                       reviewPositiveHighlight: self.determineReviewSentiment("positive"))
        
        // Make website view clickable.
        let tap = UITapGestureRecognizer(target: self, action: #selector(visitWebsiteTapped))
        restaurantDetailView.visitWebsiteView.addGestureRecognizer(tap)
    }
    
    func setUpHolderViewWithRestaurant() {
        restaurantDetailView = RecommendedRestaurantDetailView.instanceFromNib()
    }
    
    func visitWebsiteTapped() {
        UIApplication.sharedApplication().openURL(NSURL(string: self.chosenRestaurant.getWebsite())!)
    }
    
    /**
     Method to determine positive and negative sentiments in reviews.
     - paramater type: String to specify whether to determine positive or negative sentiments.
    */
    func determineReviewSentiment(type:String) -> String{
        if self.chosenRestaurant.getReviews().count == 0 {
            return "No reviews found for me to analyze what people thought of this restaurant."
        }
        if type == "negative" {
            if self.chosenRestaurant.getNegativeSentiments().count == 0 {
                return "I found 0 hints to any negative sentiments in the reviews I have."
            } else {
                return self.chosenRestaurant.getNegativeSentiments().joinWithSeparator(", ")
            }
        } else {
            if self.chosenRestaurant.getPositiveSentiments().count == 0 {
                return "I found 0 hints to any positive sentiments in the reviews I have."
            } else {
                return self.chosenRestaurant.getPositiveSentiments().joinWithSeparator(", ")
            }
        }
    }
}

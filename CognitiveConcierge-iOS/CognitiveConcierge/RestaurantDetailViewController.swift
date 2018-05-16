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

        Utils.setNavigationItems(viewController: self, rightButtons: [MoreIconBarButtonItem()], leftButtons: [WhitePathIconBarButtonItem(), UIBarButtonItem(customView: backButton)])
        Utils.setupNavigationTitleLabel(viewController: self, title: "", spacing: 1.0, titleFontSize: 17, color: UIColor.white)
        
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
        // Set up the navigation bar so that we can color the nav bar to be dark blue, and the default symbols to be white.
        Utils.setupBackButton(button: backButton, title: kBackButtonTitle, textColor: UIColor.white, frame: buttonFrame)
        
        // set up navigation items.
        Utils.setNavigationItems(viewController: self, rightButtons: [MoreIconBarButtonItem()], leftButtons: [WhitePathIconBarButtonItem(), UIBarButtonItem(customView: backButton)])
        Utils.setupNavigationTitleLabel(viewController: self, title: "", spacing: 1.0, titleFontSize: 17, color: UIColor.white)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    @IBAction func didPressBackButton(_ sender: AnyObject) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    func setupRecommendedRestaurantDetailView() {
        
        // splice the restaurant address into address, city, state.
        var locationAddress = self.chosenRestaurant.getAddress().components(separatedBy: ",")
        
        // load data into restaurant details view
        restaurantDetailView.setupData(openNowStatus: self.chosenRestaurant.getOpenNowStatus(),
                                       openingTimeNow: self.chosenRestaurant.getOpeningTimeNow(),
                                       locationName:self.chosenRestaurant.getName(),
                                       locationAddress: locationAddress[0],
                                       city: "\(locationAddress[1]),\(locationAddress[2])",
                                       fullAddress: self.chosenRestaurant.getAddress(),
                                       priceLevel: Double(self.chosenRestaurant.getExpense()),
                                       rating: self.chosenRestaurant.getRating(),
                                       reviewNegativeHighlight: self.determineReviewSentiment(type: "negative"),
                                       reviewPositiveHighlight: self.determineReviewSentiment(type: "positive"))
        
        // Make website view clickable.
        let tap = UITapGestureRecognizer(target: self, action: #selector(visitWebsiteTapped))
        restaurantDetailView.visitWebsiteView.addGestureRecognizer(tap)
    }
    
    func setUpHolderViewWithRestaurant() {
        restaurantDetailView = RecommendedRestaurantDetailView.instanceFromNib()
    }
    
    @objc func visitWebsiteTapped() {
        UIApplication.shared.open(URL(string: self.chosenRestaurant.getWebsite())!, options: [:])
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
                return self.chosenRestaurant.getNegativeSentiments().joined(separator: ", ")
            }
        } else {
            if self.chosenRestaurant.getPositiveSentiments().count == 0 {
                return "I found 0 hints to any positive sentiments in the reviews I have."
            } else {
                return self.chosenRestaurant.getPositiveSentiments().joined(separator: ", ")
            }
        }
    }
}

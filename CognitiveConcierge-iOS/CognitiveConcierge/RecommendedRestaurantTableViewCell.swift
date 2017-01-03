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
import GooglePlaces

class RecommendedRestaurantTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var reviewsFromLabel: UILabel!
    @IBOutlet weak var expensiveLabel: UILabel!
    @IBOutlet weak var restaurantImageView: UIImageView!
    @IBOutlet weak var starStackView: UIStackView!
    @IBOutlet weak var starImageView1: UIImageView!
    @IBOutlet weak var starImageView2: UIImageView!
    @IBOutlet weak var starImageView3: UIImageView!
    @IBOutlet weak var starImageView4: UIImageView!
    @IBOutlet weak var starImageView5: UIImageView!
 
    /**
     Method that is called when it wakes from nib and sets up the view's UI
     */
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    /**
     Method that sets up the UI of the view
     */
    func setupView() {
        titleLabel.textColor = UIColor.customRestaurantViewDarkBlueColor()
        titleLabel.font = UIFont.boldSFNSDisplay(size: 16)
        
        subTitleLabel.textColor = UIColor.customRestaurantLabelColor()
        subTitleLabel.font = UIFont.regularSFNSDisplay(size: 10)
        
        reviewsFromLabel.textColor = UIColor.customRestaurantLabelColor()
        reviewsFromLabel.font = UIFont.regularSFNSDisplay(size: 10)
        reviewsFromLabel.addTextSpacing(spacing: 0.8)
       
        expensiveLabel.textColor = UIColor.customRestaurantViewDarkBlueColor()
        expensiveLabel.font = UIFont.regularSFNSDisplay(size: 16)
    }
    
    
    /**
     Method that sets up the data of the view
     
     - parameter restaurantTitle:  String?
     - parameter typeOfRestaurant: String?
     - parameter distance:         String?
     - parameter rating:           Double?
     - parameter expensiveness:    Double?
     - parameter imageURL:         String?
     */
    func setUpData(restaurantTitle : String?, openNowStatus : Bool?, matchScorePercentage : Double, rating : Double?, expensiveness : Int?, googleID : String?, image: String?){
        
        titleLabel.text = restaurantTitle ?? ""
        
        if let openNow = openNowStatus {
            subTitleLabel.font = UIFont.regularSFNSDisplay(size: 10)
            if openNow {
                subTitleLabel.text = "OPEN"
                subTitleLabel.textColor = UIColor.customOpenGreenColor()
            } else {
                subTitleLabel.text = "CLOSED"
                subTitleLabel.textColor = UIColor.customClosedRedColor()
            }
            subTitleLabel.addTextSpacing(spacing: 0.7)
        }
        
        if let r = rating {
            Utils.setUpStarStackView(numberOfStars: r, starStackView: starStackView)
        }
        
        var expensiveString = ""
        expensiveString = Utils.generateExpensiveString(number: expensiveness!)
        
        expensiveLabel.text = expensiveString
        expensiveLabel.addTextSpacing(spacing: 1.3)

        if let id = googleID {
            // Only load data for place if data is not mocked.
            if id != "-" {
                loadFirstPhotoForPlace(placeID: id)
            }
        } else {
            print ("no googleID given")
        }
        
        if let imageName = image {
            restaurantImageView.image = UIImage(named: imageName)
        } else {
            //print ("not using mock data")
        }

    }
    
    func loadFirstPhotoForPlace(placeID: String) {
        GMSPlacesClient.shared().lookUpPhotos(forPlaceID: placeID) { (photos, error) -> Void in
            if let error = error {
                print("Error: \(error)")
            } else {
                if let firstPhoto = photos?.results.first {
                    self.loadImageForMetadata(photoMetadata: firstPhoto)
                }
            }
        }
    }
    
    func loadImageForMetadata(photoMetadata: GMSPlacePhotoMetadata) {
        GMSPlacesClient.shared()
            .loadPlacePhoto(photoMetadata, constrainedTo: restaurantImageView.bounds.size,
                            scale: self.restaurantImageView.window!.screen.scale) { (photo, error) -> Void in
                                if let error = error {
                                    print("Error: \(error)")
                                } else {
                                    self.restaurantImageView.image = photo;
                                }
        }
    }
}

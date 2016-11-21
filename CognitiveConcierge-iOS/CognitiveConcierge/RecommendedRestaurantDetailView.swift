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

class RecommendedRestaurantDetailView: UIView {
    
    @IBOutlet weak var locationNameLabel: UILabel!
    @IBOutlet weak var locationHeaderLabel: UILabel!
    @IBOutlet var hoursTodayLabel: UILabel!
    @IBOutlet var hoursLabel: UILabel!
    @IBOutlet var openLabel: UILabel!
    
    @IBOutlet weak var priceRangeLabel: UILabel!
    @IBOutlet weak var reviewPositiveHighlightLabel: UILabel!
    @IBOutlet weak var reviewPositiveHighlightHeaderLabel: UILabel!
    @IBOutlet var thumbsUpImageView: UIImageView!
    @IBOutlet var reviewNegativeHighlightHeaderLabel: UILabel!
    @IBOutlet var reviewNegativeHighlightLabel: UILabel!
    @IBOutlet var reviewsFromGoogleLabel: UILabel!
    @IBOutlet var addressLabel: UILabel!
    @IBOutlet var visitWebsiteView: UIView!
    @IBOutlet var visitWebsiteLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    /// geocoder to discover coordinates
    private let geocoder = CLGeocoder()
    
    @IBOutlet weak var starStackView: UIStackView!
    @IBOutlet weak var starImageView1: UIImageView!
    @IBOutlet weak var starImageView2: UIImageView!
    @IBOutlet weak var starImageView3: UIImageView!
    @IBOutlet weak var starImageView4: UIImageView!
    @IBOutlet weak var starImageView5: UIImageView!
    
    
    /**
    Method that returns an instance from nib of the RecommendedRestaurantDetailView
    
    - returns: RecommendedRestaurantDetailView
    */
    class func instanceFromNib() -> RecommendedRestaurantDetailView {
        return UINib(nibName: "RecommendedRestaurantDetailView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! RecommendedRestaurantDetailView
    }
    
    /**
    Method is called when we wake from nib and sets up the view's UI
    */
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    /**
    Method that sets up the view's UI
    */
    func setupView() {
        
        locationNameLabel.textColor = UIColor.customRestaurantViewDarkBlueColor()
        locationNameLabel.font = UIFont.boldSFNSDisplay(size: 25)
        
        locationHeaderLabel.textColor = UIColor.customRestaurantLabelColor()
        locationHeaderLabel.font = UIFont.regularSFNSDisplay(size: 10)
        locationHeaderLabel.text = "LOCATION"
        locationHeaderLabel.addTextSpacing(spacing: 0.7)
        
        hoursTodayLabel.textColor = UIColor.customRestaurantLabelColor()
        hoursTodayLabel.font = UIFont.regularSFNSDisplay(size: 10)
        
        hoursLabel.textColor = UIColor.customRestaurantLabelColor()
        hoursLabel.font = UIFont.regularSFNSDisplay(size: 10)
        
        openLabel.font = UIFont.regularSFNSDisplay(size: 10)
        
        priceRangeLabel.textColor = UIColor.customDarkBlueColor()
        priceRangeLabel.font = UIFont.boldSFNSDisplay(size: 16)
        
        reviewsFromGoogleLabel.textColor = UIColor.customRestaurantLabelColor()
        reviewsFromGoogleLabel.text = "Reviews from Google"
        reviewsFromGoogleLabel.addTextSpacing(spacing: 0.7)
        
        addressLabel.textColor = UIColor.customDarkBlueColor()
        addressLabel.font = UIFont.regularSFNSDisplay(size: 16)
        
        visitWebsiteLabel.textColor = UIColor.customDarkBlueColor()
        visitWebsiteLabel.font = UIFont.regularSFNSDisplay(size: 16)
        visitWebsiteLabel.text = "Visit Website"
        visitWebsiteLabel.addTextSpacing(spacing: 1.1)
                
        reviewPositiveHighlightHeaderLabel.textColor = UIColor.customDarkBlueColor()
        reviewPositiveHighlightHeaderLabel.font = UIFont.regularSFNSDisplay(size: 10)
        reviewPositiveHighlightLabel.text = "POSITIVE SENTIMENTS"
        reviewPositiveHighlightHeaderLabel.addTextSpacing(spacing: 0.7)
        
        reviewPositiveHighlightLabel.textColor = UIColor.customDarkBlueColor()
        reviewPositiveHighlightLabel.font = UIFont.regularSFNSDisplay(size: 13)
        reviewPositiveHighlightLabel.addTextSpacing(spacing: 0.9)
        
        reviewNegativeHighlightHeaderLabel.textColor = UIColor.customRestaurantLabelColor()
        reviewNegativeHighlightHeaderLabel.font = UIFont.regularSFNSDisplay(size: 10)
        reviewNegativeHighlightHeaderLabel.text = "NEGATIVE SENTIMENTS"
        reviewNegativeHighlightHeaderLabel.addTextSpacing(spacing: 0.7)
        
        reviewNegativeHighlightLabel.textColor = UIColor.customRestaurantLabelColor()
        reviewNegativeHighlightLabel.font = UIFont.regularSFNSDisplay(size: 13)
        reviewNegativeHighlightLabel.addTextSpacing(spacing: 0.9)
        
    }
    
    /**
    Method to set up the data for the view
    
    - parameter isPreferred:      Bool?
    - parameter typeOfRestaurant: String?
    - parameter locationName:     String?
    - parameter locationAddress:  String?
    - parameter city:             String?
    - parameter priceLevel:       Double?
    - parameter rating:           Double?
    - parameter reviewHighlight:  String?
    */
    func setupData(openNowStatus : Bool?, openingTimeNow: Array<String>?, locationName : String?, locationAddress : String?, city : String?, fullAddress: String?, priceLevel : Double?, rating : Double?, reviewNegativeHighlight: String?, reviewPositiveHighlight: String?) {
        
        if let openNow = openNowStatus {
            //let open = checkTime(openNow)
            if openNow {
                openLabel.text = "OPEN"
                openLabel.textColor = UIColor.customOpenGreenColor()
            } else {
                openLabel.text = "CLOSED"
                openLabel.textColor = UIColor.customClosedRedColor()
            }
            openLabel.addTextSpacing(spacing: 0.7)
        }
        
        let openingTime = openingTimeNow ?? [""]
        hoursLabel.text = Utils.convertMilitaryTime(timeArray: openingTime)
        hoursLabel.addTextSpacing(spacing: 0.7)
        
        locationNameLabel.text = locationName ?? ""
        locationNameLabel.addTextSpacing(spacing: 0.7)
        
        let locAddress = locationAddress ?? ""
        let locCity = city ?? ""
        
        addressLabel.text = "\(locAddress)\(locCity)" 
        addressLabel.addTextSpacing(spacing: 1.1)
        
        setupMap()
        
        let p_Level = priceLevel ?? 0
        priceRangeLabel.text = Utils.generateExpensiveString(number: Int(p_Level))
        priceRangeLabel.addTextSpacing(spacing: 1.1)
        
        let r = rating ?? 0.0
        Utils.setUpStarStackView(numberOfStars: r, starStackView: starStackView)
        
        /// Set the positive highlights reviews.
        let reviewerPositiveHighlightString = reviewPositiveHighlight ?? ""
        
        reviewPositiveHighlightLabel.text = reviewerPositiveHighlightString
        reviewPositiveHighlightLabel.addTextSpacing(spacing: 1.1)
        
        /// Set the positive highlights reviews.
        let reviewerNegativeHighlightString = reviewNegativeHighlight ?? ""
        
        reviewNegativeHighlightLabel.text = reviewerNegativeHighlightString
        reviewNegativeHighlightLabel.addTextSpacing(spacing: 1.1)

    }
    
    /**
     Method to setup the map view based on coordinates of address given by restaurant.
     */
    func setupMap(){
        
        let latDelta : CLLocationDegrees = 0.005
        let longDelta : CLLocationDegrees = 0.005
        
        geocoder.geocodeAddressString(addressLabel.text!) { (placemarks, error) -> Void in
            if let placemark = placemarks?[0] {
                let lat = placemark.location!.coordinate.latitude
                let long = placemark.location!.coordinate.longitude
                let coordinates = CLLocationCoordinate2D(latitude: lat, longitude: long)
                
                var region = MKCoordinateRegion()
                var span = MKCoordinateSpan()
                
                span.latitudeDelta = latDelta
                span.longitudeDelta = longDelta
                
                region.span = span
                region.center = coordinates
                
                self.mapView.setRegion(region, animated: true)
                
                let pin = MKPointAnnotation()
                pin.coordinate = coordinates
                self.mapView.addAnnotation(pin)
            }
        }
    }
    
    
}

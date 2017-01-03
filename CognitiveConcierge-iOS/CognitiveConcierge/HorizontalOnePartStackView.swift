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

/// Horizontal one part stack view
class HorizontalOnePartStackView: UIView {
    /// location label
    @IBOutlet weak var locationLabel: UILabel!
    
    /// first header label
    @IBOutlet weak var firstHeaderLabel: UILabel!
    
    /// horizontal separator view
    @IBOutlet weak var horizontalSeparatorView: UIView!
    
    
    /**
    Method is called when we wake from nib and it sets up the view's UI
    */
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    
    /**
    Method that returns an instance of HorizontalOnePartStackView from nib
    
    - returns: HorizontalOnePartStackView
    */
    class func instanceFromNib() -> HorizontalOnePartStackView {
        return UINib(nibName: "HorizontalOnePartStackView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! HorizontalOnePartStackView
    }
    
    
    /**
    Method to setup the view's UI
    */
    func setupView() {
        horizontalSeparatorView.backgroundColor = UIColor.customPaleGrayColor()
        
        firstHeaderLabel.textColor = UIColor.customRestaurantLabelColor()
        firstHeaderLabel.font = UIFont.regularSFNSDisplay(size: 11)
        firstHeaderLabel.text = "WATSON RECOMMENDATIONS BASED ON:"
        firstHeaderLabel.addTextSpacing(spacing: 0.7)
        
        locationLabel.textColor = UIColor.customDarkBlueColor()
        locationLabel.font = UIFont.regularSFNSDisplay(size: 11)
        locationLabel.addTextSpacing(spacing: 0.7)
    }
    
    
    /**
    Method to setup the data in the view
    
    - parameter replacementRestaurantName:        restaurant name
    - parameter replacementRestaurantCityCountry: city or country of restaurant
    */
    func setUpData(occasion : String?, location : String?, time: String?){
        
        var locationLabelString = ""
        if let theoccasion = occasion, let thelocation = location, let theTime = time {
            locationLabelString = "Your \(theoccasion) in \(thelocation) for \(theTime)"
        }
        
        locationLabel.text = locationLabelString
        locationLabel.addTextSpacing(spacing: 0.7)
    }

}

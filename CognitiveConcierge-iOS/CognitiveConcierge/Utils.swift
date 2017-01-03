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
import Foundation

class Utils {
    static let kNavigationBarTitle: String = "CONCIERGE CHAT"

    class func setNavigationItems(viewController: UIViewController, rightButtons: [UIBarButtonItem], leftButtons: [UIBarButtonItem]) {
        viewController.navigationController!.navigationItem.hidesBackButton = true
        viewController.navigationController!.navigationBar.topItem!.rightBarButtonItems = rightButtons
        viewController.navigationController!.navigationBar.topItem!.leftBarButtonItems = leftButtons
    }

    class func setupDarkNavBar (viewController: UIViewController, title: String) {
        let navigationBarAppearance = UINavigationBar.appearance()
        navigationBarAppearance.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        /// Configure title.
        
        if let navController = viewController.navigationController {
            /// Make the background transluscent and content a navy blue.
            navController.navigationBar.barStyle = UIBarStyle.blackTranslucent
            navController.navigationBar.barTintColor = UIColor.customNavBarNavyBlueColor()
        }
        
        setupNavigationTitleLabel(viewController: viewController, title: title, spacing: 1.0, titleFontSize: 17, color: UIColor.white)
    }

    /** 
     Set up a white navigation bar. If used, will need to reset background and shadow image in viewWillDisappear to nil.
        Otherwise will have a white navigation bar when changing to different views.
     - paramater viewController: UIViewController to change the navigation bar of.
     - paramater title: String to set the title of the view.
     */
    class func setupLightNavBar (viewController: UIViewController, title: String) {
        /// Configure title.
        
        if let navController = viewController.navigationController {
            /// Make the background transluscent and content white.
            navController.navigationBar.barStyle = UIBarStyle.default
            navController.navigationBar.barTintColor = UIColor.white
            navController.navigationBar.setBackgroundImage(UIImage(), for: .default)
            navController.navigationBar.shadowImage = UIImage()
        }
        setupNavigationTitleLabel(viewController: viewController, title: title, spacing: 2.9, titleFontSize: 11, color: UIColor.black)
    }

    /** Define title's font name, spacing and color. */
    class func setupNavigationTitleLabel(viewController: UIViewController, title: String, spacing: CGFloat, titleFontSize: CGFloat, color: UIColor) {

        let titleLabel = UILabel()
        let attributes: [String: Any] = [NSFontAttributeName: UIFont(name: "SFNS Display", size: titleFontSize)!, NSForegroundColorAttributeName: color, NSKernAttributeName : spacing]
        titleLabel.attributedText = NSAttributedString(string: title, attributes: attributes)

        titleLabel.sizeToFit()
        
        viewController.navigationController!.navigationBar.topItem!.titleView = titleLabel

    }

    class func setupBackButton (button: UIButton, title: String, textColor: UIColor, frame: CGRect = CGRect(x: 25.5, y: 33, width: 41, height: 13), spacing: CGFloat = CGFloat(2.9)) {
        button.setTitleColor(textColor, for: .normal)
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = UIFont.regularSFNSDisplay(size: 11)
        button.titleLabel?.text = title
        button.titleLabel?.addTextSpacing(spacing: spacing)
        button.frame = frame
    }

    class func getCurrentViewController() -> UIViewController? {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let currentViewController = appDelegate.window?.rootViewController?.presentedViewController
        
        return currentViewController
    }

    class func addBorderToEdge (textView: UITextView, edge: UIRectEdge, thickness: CGFloat, color: UIColor) {
        let border = CALayer()
        
        switch edge {
        case UIRectEdge.left:
            border.frame = CGRect(x: 0, y: 0, width: thickness, height: textView.frame.size.height)
            break
        case UIRectEdge.right:
            border.frame = CGRect(x: CGFloat(textView.widthAnchor.hashValue), y: 0, width: thickness, height: textView.frame.size.height)
            break
        default:
            break
        }
        border.backgroundColor = color.cgColor
        textView.layer.addSublayer(border)
        textView.layer.masksToBounds = true
    }

    class func parseRecommendationsJSON (recommendations: [[String: Any]]) -> [Restaurant] {
        var recommendedRestaurants = [Restaurant]()
        for rec in recommendations {
            let openNowStatus = rec["openNow"] as? Bool ?? false
            let openingTimeNow = rec["openingTimeNow"] as? Array<String> ?? [""]
            let name = rec["name"] as? String ?? ""
            let googleID = rec["googleID"] as? String ?? ""
            let rating = rec["rating"] as? Double ?? 0
            let expense = rec["expense"] as? Int ?? 0
            let address = rec["address"] as? String ?? ""
            let reviews = rec["reviews"] as? Array<String> ?? [""]
            let negativeSentiments = rec["negativeSentiment"] as? Array<String> ?? [""]
            let positiveSentiments = rec["positiveSentiment"] as? Array<String> ?? [""]
            let website = rec["website"] as? String ?? ""
            let image = rec["image"] as? String ?? nil
            let restaurant = Restaurant(openNowStatus: openNowStatus, openingTimeNow: openingTimeNow, name: name, googleID: googleID, rating: rating, expense: expense, address: address, reviews: reviews, negativeSentiments: negativeSentiments, positiveSentiments: positiveSentiments, image: image, website: website)
            recommendedRestaurants.append(restaurant)
        }
        return recommendedRestaurants
    }

    class func convertMilitaryTime(timeArray: [String]) -> String {
        var openingTime = ""
        var count = 0
        let dateFormatter = DateFormatter()
        for time in timeArray {
            if time == "OPEN 24 HOURS" {
                return time
            }
            dateFormatter.dateFormat = "HHmm"
            if let militaryTime = dateFormatter.date(from: time) {
                dateFormatter.dateFormat = "h:mm a"
                let twelveHourTime = dateFormatter.string(from: militaryTime)
                print ("24hr time: \(time), 12hr time: \(twelveHourTime)")
                // If odd element, add dash and append the closing time.
                if count % 2 != 0 {
                    openingTime += " - \(twelveHourTime)"
                } else {
                    // If more than two elements, add a comma to seperate the different open/close times:
                    if count >= 2 {
                        openingTime += ", "
                    }
                    openingTime += twelveHourTime
                }
                count += 1
            } else {
                print ("error converting 24 hours to 12 hour time")
            }
        }
        return openingTime
    }

    class func checkTime(openHours: Array<String>) -> Bool {
        //let date  = NSDate()
        //let calendar = NSCalendar.currentCalendar()
        //let components = calendar.components([.Hour, .Minute], fromDate: date)
        //let hour = components.hour
        //let minutes = components.minute
        
        let formatter = DateFormatter()
        formatter.dateFormat = "hhmm"
        return false
    }
    
    /**
     Method takes in a Int parameter and converts this to a string that represents how expense something is, ie. "€€€"
     - parameter number: Int
     - returns: String
     */
    class func generateExpensiveString(number : Int) -> String {
        let moneySign = "$"
        var string = ""
        var i = 0
        if (number == 0) {
            return "--"
        }
        while( i < number) {
            string = string + moneySign
            i+=1
        }
        return string
    }
    
    /**
     Method sets up a startStackView with the number of stars defined by the numberOfStars parameter
     
     - parameter numberOfStars: Double
     - parameter starStackView: UIStackView
     */
    class func setUpStarStackView(numberOfStars : Double, starStackView : UIStackView){
        let floorStars = floor(numberOfStars)
        
        let remainder = numberOfStars - floorStars
        
        for (index, element) in starStackView.subviews.enumerated() {
            
            if(index < Int(floorStars)){
                (element as! UIImageView).image = UIImage(named: "Star")
            }
            else if(remainder > 0 && index == Int(floorStars)){
                (element as! UIImageView).image = UIImage(named: "Star_half")
            }
            else{
                (element as! UIImageView).image = UIImage(named: "Star_empty")
            }
        }
    }
}

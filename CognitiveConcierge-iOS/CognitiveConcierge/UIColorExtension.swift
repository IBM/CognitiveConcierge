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

extension UIColor {
    
    class func customGrayColor() -> UIColor {return UIColor.init(hex: "8D8D8D")}
    
    class func customBlueGrayColor() -> UIColor {return UIColor.init(hex: "F3F3F3")}
    
    class func customAzureColor() -> UIColor {return UIColor.init(hex: "00ADEF")}
    
    class func customPaleGrayColor() -> UIColor {return UIColor.init(hex: "EBEFF4")}
    
    class func customDarkBlueColor() -> UIColor {return UIColor.init(hex: "283444")}
    
    class func customSendButtonColor() -> UIColor {return UIColor.init(hex: "738C9C")}
    
    class func customQuestionBackgroundColor() -> UIColor {return UIColor.init(hex: "EEF1F5")}
        
    class func customQuestionTextColor() -> UIColor {return UIColor.init(hex: "B0BCCA")}
    
    class func customRestaurantViewDarkBlueColor() -> UIColor {return UIColor.init(hex: "1D3E59")}
    
    class func customRestaurantLabelColor() -> UIColor {return UIColor.init(hex: "98A4B2")}
    
    class func customOpenGreenColor() -> UIColor {return UIColor.init(hex: "8CC832")}
    
    class func customClosedRedColor() -> UIColor {return UIColor.init(hex: "D1051E")}
    
    class func customWatsonOverlayColor() -> UIColor {return UIColor.init(hex: "154B66")}
    
    class func customGetMoreIconButtonColor() -> UIColor {return UIColor.init(hex: "2E98D4")}
    
    class func customNavBarNavyBlueColor() -> UIColor {return UIColor.init(hex: "062742")}

    /**
     Method called upon init that accepts a HEX string and creates a UIColor.
     
     - parameter hex:   String
     - parameter alpha: CGFloat
     
     - returns: UIColor
     */
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        var red: CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue: CGFloat = 0.0
        
        var hexString = ""
        
        if hex.hasPrefix("#") {
            let nsHex = hex as NSString
            hexString = nsHex.substring(from: 1)
            
        } else {
            hexString = hex
        }
        
        let scanner = Scanner(string: hexString)
        var hexValue: CUnsignedLongLong = 0
        if scanner.scanHexInt64(&hexValue) {
            switch (hexString.characters.count) {
            case 3:
                red = CGFloat((hexValue & 0xF00) >> 8)       / 15.0
                green = CGFloat((hexValue & 0x0F0) >> 4)       / 15.0
                blue = CGFloat(hexValue & 0x00F)              / 15.0
            case 6:
                red = CGFloat((hexValue & 0xFF0000) >> 16)   / 255.0
                green = CGFloat((hexValue & 0x00FF00) >> 8)    / 255.0
                blue = CGFloat(hexValue & 0x0000FF)           / 255.0
            default:
                print("Invalid HEX string, number of characters after '#' should be either 3, 6")
            }
        } else {
            //MQALogger.log("Scan hex error")
        }
        self.init(red:red, green:green, blue:blue, alpha:alpha)
    }
    
}

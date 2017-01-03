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
import UIKit

public class WatsonOverlay: UIView {
    
    @IBOutlet weak var watsonGif: UIWebView!
    // MARK - Properties
    

    @IBOutlet weak var label: UILabel!
    
    // Label to broadcast to user page is still loading.
    var vc: UIViewController!
    
    /** Method that is called when it wakes from nib and sets up the view's UI. */
    override public func awakeFromNib() {
        super.awakeFromNib()
        setupWatsonOverlay()
        setupGif()
        setupLabel()
    }
    
    /**
     Method that returns an instance of WatsonOverlay from nib
     
     - returns: WatsonOverlay
     */
    class func instanceFromNib(view: UIView) -> WatsonOverlay {
        return UINib(nibName: "WatsonOverlay", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! WatsonOverlay
    }
    
    
    private func setupWatsonOverlay() {
        self.backgroundColor = UIColor.white
        
    }
    
    private func setupLabel() {
        label.font = UIFont(name: ".HelveticaNeueDeskInterface-Bold", size: 12)
        label.font = label.font.withSize(15)
        label.textColor = UIColor.customWatsonOverlayColor()
        
        label.text = "I'M GATHERING YOUR \n RECOMMENDATIONS"
        label.textAlignment = NSTextAlignment.center
        label.addTextSpacing(spacing: 4.1)
    }
    
    private func setupGif() {
        if let asset = NSDataAsset(name: "Watson-blue") {
            let imageData = asset.data
            watsonGif.load(imageData, mimeType: "image/gif", textEncodingName:"utf-8", baseURL: URL(string: "http://localhost/")!)
            watsonGif.scalesPageToFit = true
            watsonGif.isUserInteractionEnabled = false
        }
    }
    
    /** Append loading screen to current view.
     - paramater view: UIView to add the overlay subview to.
     */
    public func showWatsonOverlay(view: UIView) {
        self.frame = view.frame
        view.addSubview(self)
    }
    
    public func hideWatsonOverlay() {
        //watsonGif.hidden = true
        label.isHidden = true
        self.removeFromSuperview()
    }
}

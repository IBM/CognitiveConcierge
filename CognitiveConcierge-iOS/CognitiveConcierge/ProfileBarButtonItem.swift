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

class ProfileBarButtonItem: UIBarButtonItem {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init() {
        super.init()
        
        setupProfileButton()
    }
    
    //    func goToProfile() {
    //        if let currentVC = getCurrentViewController() {
    //            currentVC.presentViewController(ConfigurationViewController(), animated: true, completion: nil)
    //        }
    //    }
    
    private func getProfileButton() -> UIButton {
        let profileButton = UIButton()
        profileButton.setImage(UIImage(named: "avatar"), for: .normal)
        //        profileButton.addTarget(self, action: #selector(ProfileBarButtonItem.goToProfile), forControlEvents: .TouchUpInside)
        profileButton.frame = CGRect(x: 14.5, y: 27, width: 30, height: 30)
        
        return profileButton
    }
    
    private func setupProfileButton() {
        self.customView = getProfileButton()
    }
}

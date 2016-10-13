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

class PathIconBarButtonItem: UIBarButtonItem {
    
    let morePathButton = UIButton()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init() {
        super.init()
        
        setupPathIconButton()
    }
    
    func goToPath() {
        if let currentVC = Utils.getCurrentViewController() {
            currentVC.navigationController?.popViewControllerAnimated(true)
        }
    }
    
    private func getPathIconButton() -> UIButton {
        morePathButton.setImage(UIImage(named: "path"), forState: .Normal)
        morePathButton.addTarget(self, action: #selector(PathIconBarButtonItem.goToPath), forControlEvents: .TouchUpInside)
        morePathButton.addTarget(self, action: nil, forControlEvents: .TouchUpInside)
        morePathButton.frame = CGRectMake(11.8, 33.5, 6, 12.2)

        // Set opacity
        morePathButton.alpha = 0.45
        return morePathButton
    }
    
    private func setupPathIconButton() {
        self.customView = getPathIconButton()
    }
    
}

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

class WhitePathIconBarButtonItem: UIBarButtonItem {
    
    let moreWhitePathButton = UIButton()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init() {
        super.init()
        
        setupPathIconButton()
    }

    func goToPath() {
        if let currentVC = Utils.getCurrentViewController() {
            _ = currentVC.navigationController?.popViewController(animated: true)
        }
    }
    
    private func getWhitePathIconButton() -> UIButton {
        moreWhitePathButton.setImage(UIImage(named: "path_white"), for: .normal)
        moreWhitePathButton.addTarget(self, action: #selector(WhitePathIconBarButtonItem.goToPath), for: .touchUpInside)
        moreWhitePathButton.frame = CGRect(x: 11.8, y: 33.5, width: 6, height: 12.2)
        
        // Set opacity
        moreWhitePathButton.alpha = 0.45
        return moreWhitePathButton
    }
    
    private func setupPathIconButton() {
        self.customView = getWhitePathIconButton()
    }
    
}

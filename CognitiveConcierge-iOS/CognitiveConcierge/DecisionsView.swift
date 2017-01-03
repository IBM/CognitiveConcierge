//
//  DecisionsView.swift
//  CognitiveConcierge
//

import UIKit

class DecisionsView: UIView {
    
    @IBOutlet var keepChattingButton: UIButton!
    @IBOutlet var seeRestaurantsButton: UIButton!
    @IBOutlet var questionLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    @IBAction func keepChattingButtonPressed(_ sender: AnyObject) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "keepChattingButtonPressed"), object: nil)
    }
    
    @IBAction func seeRestaurantsButtonPressed(_ sender: AnyObject) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "seeRestaurantsButtonPressed"), object: nil)
    }
    
    /**
     Method that returns an instance of HorizontalOnePartStackView from nib
     
     - returns: HorizontalOnePartStackView
     */
    class func instanceFromNib() -> DecisionsView {
        return UINib(nibName: "DecisionsView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! DecisionsView
    }

    func setupView() {
        questionLabel.addTextSpacing(spacing: 0.7)
//        questionLabel.fon
    }
}

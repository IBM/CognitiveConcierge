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
    
    @IBAction func keepChattingButtonPressed(sender: AnyObject) {
        NSNotificationCenter.defaultCenter().postNotificationName("keepChattingButtonPressed", object: nil)
    }
    
    @IBAction func seeRestaurantsButtonPressed(sender: AnyObject) {
        NSNotificationCenter.defaultCenter().postNotificationName("seeRestaurantsButtonPressed", object: nil)
    }
    
    /**
     Method that returns an instance of HorizontalOnePartStackView from nib
     
     - returns: HorizontalOnePartStackView
     */
    class func instanceFromNib() -> DecisionsView {
        return UINib(nibName: "DecisionsView", bundle: nil).instantiateWithOwner(nil, options: nil)[0] as! DecisionsView
    }

    func setupView() {
        questionLabel.addTextSpacing(0.7)
//        questionLabel.fon
    }
}

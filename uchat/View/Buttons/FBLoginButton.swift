//
//  FBLoginButton.swift
//  On the Map
//
//  Created by Wojtek Materka on 31/01/2016.
//  Copyright © 2016 Wojtek Materka. All rights reserved.
//

import UIKit

class FBLoginButton: UIButton, BorderedButtonProtocol {
    // MARK: Properties
    
    /* Constants for styling and configuration */
    var darkerFace = OTMColors.FBloginButtonDark
    var lighterFace = OTMColors.FBloginButtonLight
    var titleColor = OTMColors.FBButtonTitle
    let titleLabelFontSize : CGFloat = 18.0
    let borderedButtonHeight : CGFloat = 54.0
    let borderedButtonCornerRadius : CGFloat = 4.0
    let phoneBorderedButtonExtraPadding : CGFloat = 14.0
    
    var backingColor : UIColor? = nil
    var highlightedBackingColor : UIColor? = nil
    
    // MARK: Initialization
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.themeBorderedButton()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.themeBorderedButton()
    }
    
    override func sizeThatFits(size: CGSize) -> CGSize {
        let extraButtonPadding : CGFloat = phoneBorderedButtonExtraPadding
        var sizeThatFits = CGSizeZero
        sizeThatFits.width = super.sizeThatFits(size).width + extraButtonPadding
        sizeThatFits.height = borderedButtonHeight
        return sizeThatFits
        
    }
    
    // MARK: Tracking
    
    override func beginTrackingWithTouch(touch: UITouch, withEvent: UIEvent?) -> Bool {
        self.backgroundColor = self.highlightedBackingColor
        return true
    }
    
    override func endTrackingWithTouch(touch: UITouch?, withEvent event: UIEvent?) {
        self.backgroundColor = self.backingColor
    }
    
    override func cancelTrackingWithEvent(event: UIEvent?) {
        self.backgroundColor = self.backingColor
    }
}

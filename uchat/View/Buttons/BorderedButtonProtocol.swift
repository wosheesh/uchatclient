//
//  BorderedButtonProtocol.swift
//  On the Map
//
//  Created by Wojtek Materka on 31/01/2016.
//  Copyright © 2016 Wojtek Materka. All rights reserved.
//

import UIKit

protocol BorderedButtonProtocol : class {
    
    // MARK: Properties
    
    /* Constants for styling and configuration */
    var darkerFace : UIColor {get}
    var lighterFace : UIColor {get}
    var titleColor : UIColor {get}
    var titleLabelFontSize : CGFloat {get}
    var borderedButtonHeight : CGFloat {get}
    var borderedButtonCornerRadius : CGFloat {get}
    var phoneBorderedButtonExtraPadding : CGFloat {get}
    
    var backingColor : UIColor? {get set}
    var highlightedBackingColor : UIColor? {get set}
    
    func sizeThatFits(size: CGSize) -> CGSize
    
    
    
}

extension BorderedButtonProtocol where Self : UIButton {
    
    func themeBorderedButton() -> Void {
        self.layer.masksToBounds = true
        self.layer.cornerRadius = borderedButtonCornerRadius
        self.highlightedBackingColor = darkerFace
        self.backingColor = lighterFace
        self.backgroundColor = lighterFace
        self.setTitleColor(titleColor, forState: .Normal)
        self.titleLabel?.font = UIFont(name: "Roboto-Medium", size: titleLabelFontSize)
    }
    
    private func setBackingColor(backingColor : UIColor) -> Void {
        if (self.backingColor != nil) {
            self.backingColor = backingColor;
            self.backgroundColor = backingColor;
        }
    }
    
    private func setHighlightedBackingColor(highlightedBackingColor: UIColor) -> Void {
        self.highlightedBackingColor = highlightedBackingColor
        self.backingColor = highlightedBackingColor
    }
    

}
//
//  LoginTextField.swift
//  On the Map
//
//  Created by Wojtek Materka on 31/01/2016.
//  Copyright © 2016 Wojtek Materka. All rights reserved.
//

import UIKit

class LoginTextField : UITextField {
    
    let textFieldFontSize : CGFloat = 20.0
    let loginTextFieldCornerRadius : CGFloat = 0
    let phoneTextFieldExtraPadding : CGFloat = 34.0
    let loginTextFieldWidthBounds : CGFloat = 18
    let loginTextFieldHeightBounds : CGFloat = 14

    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.themeLoginTextField()
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.themeLoginTextField()
    }
    
    func themeLoginTextField() {
        self.backgroundColor = OTMColors.loginTextFieldBg
        self.font = UIFont(name: "Roboto-Regular", size: textFieldFontSize)
        self.textColor = OTMColors.loginTextFieldTextColor
        self.layer.cornerRadius = loginTextFieldCornerRadius
        self.borderStyle = .None

    }
    
    /* Increasing the padding for text */
    override func textRectForBounds(bounds: CGRect) -> CGRect {
        return CGRectMake(
            bounds.origin.x + loginTextFieldWidthBounds / 2,
            bounds.origin.y + loginTextFieldHeightBounds / 2,
            bounds.size.width - loginTextFieldWidthBounds,
            bounds.size.height - loginTextFieldHeightBounds
        )
    }
    
    override func editingRectForBounds(bounds: CGRect) -> CGRect {
        return self.textRectForBounds(bounds)
    }
    

}

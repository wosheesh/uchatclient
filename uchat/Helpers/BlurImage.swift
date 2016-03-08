//
//  BlurImage.swift
//  uchat
//
//  Created by Wojtek Materka on 08/03/2016.
//  Copyright © 2016 Wojtek Materka. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    
    func makeBlurImage(withStyle style: UIBlurEffectStyle) {
        let blurEffect = UIBlurEffect(style: style)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.bounds
        
        blurEffectView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight] // for different device orientations
        self.addSubview(blurEffectView)
    }
    
}

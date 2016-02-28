//
//  ChatTextView.swift
//  uchat
//
//  Created by Wojtek Materka on 28/02/2016.
//  Copyright © 2016 Wojtek Materka. All rights reserved.
//

import UIKit
import Foundation

class ChatTextView: UITextView {
    

    // TODO: change the intrinsic size depending on parent view
    override func intrinsicContentSize() -> CGSize {
        // Hardcoded for now.
        return CGSize(width: 0.0, height: ChatViewController.chatTextViewMinHeight)
    }
    
    
    /// Returns the best size for a textview depending on amount of content.
    /// Adapted from the SlackTextViewController: https://github.com/slackhq/SlackTextViewController
    func appropriateHeight() -> CGFloat {
        var height: CGFloat = 0.0
        let minHeight: CGFloat = self.minChatTextViewHeight()
        let numberOfLines = self.numberOfLines()
        
        if numberOfLines == 1 {
            height = minHeight
        } else {
            height = chatTextViewHeightForLines(numberOfLines)
        }
        
        return height
    }
    
    func minChatTextViewHeight() -> CGFloat {
        return self.intrinsicContentSize().height
    }
    
    func numberOfLines() -> Int {
        let paddingHeight = self.contentSize.height - self.textContainerInset.top - self.textContainerInset.bottom
        
        var lines = Int(round(paddingHeight / self.font!.lineHeight))
        
        if lines == 0 {
            lines = 1
        }
        
        return lines
    }
    
    func chatTextViewHeightForLines(numberOfLines: Int) -> CGFloat {
        var height: CGFloat = self.intrinsicContentSize().height
        height -= self.font!.lineHeight
        height += CGFloat(roundf(Float(self.font!.lineHeight) * Float(numberOfLines)))
        return height
    }
    
}

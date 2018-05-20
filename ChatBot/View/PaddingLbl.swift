//
//  PaddingLbl.swift
//  ChatBot
//
//  Created by Shivam Dev on 19/05/18.
//  Copyright © 2018 Shivam Dev. All rights reserved.
//

import UIKit

class PaddingLbl: UILabel {

     var topInset: CGFloat = 5.0
     var bottomInset: CGFloat = 5.0
     var leftInset: CGFloat = 7.0
     var rightInset: CGFloat = 7.0
    
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets.init(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: UIEdgeInsetsInsetRect(rect, insets))
    }
    
    override var intrinsicContentSize: CGSize {
        var intrinsicSuperViewContentSize = super.intrinsicContentSize
        intrinsicSuperViewContentSize.height += topInset + bottomInset
        intrinsicSuperViewContentSize.width += leftInset + rightInset
        return intrinsicSuperViewContentSize
    }

}

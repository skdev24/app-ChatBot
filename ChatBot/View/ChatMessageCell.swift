//
//  ChatMessageCell.swift
//  ChatBot
//
//  Created by Shivam Dev on 19/05/18.
//  Copyright © 2018 Shivam Dev. All rights reserved.
//

import UIKit

class ChatMessageCell: UITableViewCell {

    
    @IBOutlet weak var rightLbl: UILabel!
    @IBOutlet weak var leftLbl: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        rightLbl.layer.borderWidth = 1.0
        rightLbl.layer.borderColor = #colorLiteral(red: 0.3858584166, green: 0.5081222653, blue: 0.973092854, alpha: 1)
        
        
        leftLbl.layer.borderWidth = 1.0
        leftLbl.layer.borderColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        
        
        rightLbl.isHidden = true
        leftLbl.isHidden = true
        
    }
    
    func updateRight(rightLblMessage: String) {
        rightLbl.isHidden = false
        rightLbl.text = rightLblMessage
    }
    func updateLeft(leftLblMessage: String) {
        leftLbl.isHidden = false
        leftLbl.text = leftLblMessage
    }


}

//
//  ViewController.swift
//  ChatBot
//
//  Created by Shivam Dev on 18/05/18.
//  Copyright © 2018 Shivam Dev. All rights reserved.
//

import UIKit
import CoreData



class ChatBotVC: UIViewController {

    
    @IBOutlet weak var startConversationBtn: UIButton!
    
    var checkMessage = messageVC()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startConversationBtn.layer.borderWidth = 1.0
        startConversationBtn.layer.borderColor = #colorLiteral(red: 0.1921568627, green: 0.5294117647, blue: 1, alpha: 1)
        
    }
    
    
}























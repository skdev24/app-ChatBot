//
//  Message.swift
//  ChatBot
//
//  Created by Shivam Dev on 19/05/18.
//  Copyright © 2018 Shivam Dev. All rights reserved.
//

import Foundation


enum Side: String {
    case left = "left"
    case right = "right"
}

class Message {
    var message: String
    var position: Int
    var side: String
    
    init(message: String, position: Int, side: Side) {
        self.message = message
        self.position = position
        self.side = side.rawValue
    }
    
}

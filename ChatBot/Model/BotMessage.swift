//
//  BotMessage.swift
//  ChatBot
//
//  Created by Shivam Dev on 19/05/18.
//  Copyright © 2018 Shivam Dev. All rights reserved.
//

import Foundation



class BotMessage: Decodable {
    var message: BotMessagevalue!
}

class BotMessagevalue: Decodable {
    var message: String!
}

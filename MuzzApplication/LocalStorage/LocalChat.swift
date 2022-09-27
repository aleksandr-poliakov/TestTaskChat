//
//  LocalChat.swift
//  MuzzApplication
//
//  Created by Aleksandr on 27.09.2022.
//

import Foundation

struct LocalChat {
    let date: Date
    var messages: [LocalMessage]
    
    init(date: Date, messages: [LocalMessage]) {
        self.date = date
        self.messages = messages
    }
}

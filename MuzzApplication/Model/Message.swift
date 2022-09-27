//
//  Message.swift
//  MuzzApplication
//
//  Created by Aleksandr on 27.09.2022.
//

import Foundation

import CoreData

@objc(Message)
class Message: NSManagedObject {
    @NSManaged var title: String
    @NSManaged var date: Date
    @NSManaged var upcoming: Bool
    @NSManaged var chat: Chat
}

extension Message {
    var local: LocalMessage {
        return LocalMessage(title: title, date: date, upcoming: upcoming)
    }
}

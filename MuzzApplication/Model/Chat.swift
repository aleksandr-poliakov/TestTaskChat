//
//  Chat.swift
//  MuzzApplication
//
//  Created by Aleksandr on 27.09.2022.
//

import Foundation

import CoreData

@objc(Chat)
class Chat: NSManagedObject {
    @NSManaged var date: Date
    @NSManaged var messages: Set<Message>
}

extension Chat {
    func consumeLocalData() -> LocalChat {
        guard let messages = (Array(messages) as? [Message])?.sorted(by: { $0.date.compare($1.date) == .orderedDescending }).map({ message in message.local }) else { return LocalChat(date: Date(), messages: []) }
        
        return LocalChat(date: date, messages: messages)
    }
}

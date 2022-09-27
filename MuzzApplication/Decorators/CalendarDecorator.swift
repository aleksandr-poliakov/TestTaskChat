//
//  CalendarDecorator.swift
//  MuzzApplication
//
//  Created by Aleksandr on 27.09.2022.
//

import Foundation
import CoreData

protocol CalendarDecoratorProtocol {
    func produce(chat: Chat, context: NSManagedObjectContext) -> Chat
}

final class CalendarDecorator: CalendarDecoratorProtocol {
    
    static let shared = CalendarDecorator()
    
    private init() {}
    
    func produce(chat: Chat, context: NSManagedObjectContext) -> Chat {
        let isDateInToday = Calendar.current.isDateInToday(chat.date)
        if isDateInToday {
            return chat
        } else {
            return Chat(context: context)
        }
    }
}

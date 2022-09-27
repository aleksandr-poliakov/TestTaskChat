//
//  LocalChatStorage.swift
//  MuzzApplication
//
//  Created by Aleksandr on 27.09.2022.
//

import Foundation
import CoreData

final class LocalChatStorage: ChatStore {
    
    enum Error: Swift.Error {
        case couldNotSave
    }
    
    private let container: NSPersistentContainer
    private let decorator: CalendarDecoratorProtocol
    
    init(decorator: CalendarDecoratorProtocol) {
        self.decorator = decorator
        container = NSPersistentContainer(name: "Chat")
        container.loadPersistentStores { (description, error) in
            if let error = error {
                fatalError("Error: \(error.localizedDescription)")
            }
        }
    }
    
    func insert(chat: Chat?, text: String, upcoming: Bool) {
        var entity: Chat?
        if let chat = chat { entity = decorator.produce(chat: chat, context: container.viewContext) } else { entity = Chat(context: container.viewContext) }
        entity?.date = Date()
        let message = Message(context: container.viewContext)
        message.upcoming = upcoming
        message.date = Date()
        message.title = text
        entity?.messages.insert(message)
        
        do {
            try container.viewContext.save()
        } catch {
            print("Error: \(Error.couldNotSave)")
        }
    }
    
    func retrieve() -> (local: [LocalChat], chat: [Chat]) {
        let request = NSFetchRequest<Chat>(entityName: "Chat")
        let sort = NSSortDescriptor(key: #keyPath(Chat.date), ascending: true)
        request.sortDescriptors = [sort]

        do {
            return (local: try container.viewContext.fetch(request).map { $0.consumeLocalData() }, chat: try container.viewContext.fetch(request))
        } catch {
            print("Error getting data. \(error.localizedDescription)")
        }
        
        return (local: [], chat: [])
    }
}

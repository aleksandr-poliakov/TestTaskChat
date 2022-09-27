//
//  ChatViewModel.swift
//  MuzzApplication
//
//  Created by Aleksandr on 26.09.2022.
//

import Foundation


final class ChatViewModel {
    
    typealias Observer<T> = (T) -> Void
    private var upcoming: Bool = true
    private var data: ChatStore.Data
    private let store: ChatStore
    
    var messageAppended: Observer<IndexPath>?
    var dataRetrieved: Observer<()>?
    
    init(store: ChatStore) {
        self.store = store
        data = store.retrieve()
    }
    
    func fetchData() {
        dataRetrieved?(())
    }
    
    var numberOrSection: Int {
        data.local.count
    }
    
    func numberOfRows(section: Int) -> Int {
        data.local[section].messages.count
    }
    
    func chat(section: Int) -> LocalChat {
        data.local[section]
    }
    
    func message(indexPath: IndexPath) -> LocalMessage {
        data.local[indexPath.section].messages[indexPath.row]
    }
    
    func sendMessage(text: String) {
        upcoming.toggle()
        store.insert(chat: data.chat.first == nil ? nil : data.chat.first, text: text, upcoming: upcoming)
        let message = LocalMessage(title: text, date: Date(), upcoming: upcoming)
        if data.local.isEmpty {
            data = store.retrieve()
            dataRetrieved?(())
        } else {
            appendMessage(message: message)
        }
    }
    
    private func appendMessage(message: LocalMessage) {
        data.local[0].messages.insert(message, at: 0)
        let indexPath = IndexPath(row: 0, section: 0)
        messageAppended?(indexPath)
    }
}

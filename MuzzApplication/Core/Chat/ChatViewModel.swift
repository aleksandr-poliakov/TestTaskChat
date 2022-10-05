//
//  ChatViewModel.swift
//  MuzzApplication
//
//  Created by Aleksandr on 26.09.2022.
//

import Foundation

protocol ChatViewModelType {
    typealias Observer<T> = (T) -> Void
    
    var transform: Observer<[LocalChat]>? { get set }
    var countItems: Int { get set }
    func allSection(_ section: Int) -> LocalChat
    func sendMessage(text: String)
    func viewWillAppear()
}


final class ChatViewModel: ChatViewModelType {
    
    typealias Observer<T> = (T) -> Void
    private var upcoming: Bool = true
    private var data: ChatStore.Data
    private let store: ChatStore
    var countItems: Int = 0
    
    var transform: Observer<[LocalChat]>?
    
    init(store: ChatStore) {
        self.store = store
        data = store.retrieve()
    }
    
    func viewWillAppear() {
        transform?(data.local)
        countItems = data.local.count
    }
    
    func allSection(_ section: Int) -> LocalChat {
        return data.local[section]
    }
    
    func sendMessage(text: String) {
        upcoming.toggle()
        store.insert(chat: data.chat.first == nil ? nil : data.chat.first, text: text, upcoming: upcoming)
        let message = LocalMessage(title: text, date: Date(), upcoming: upcoming)
        if data.local.isEmpty {
            data = store.retrieve()
            transform?(data.local)
        } else {
            appendMessage(message: message)
        }
    }
    
    private func appendMessage(message: LocalMessage) {
        data.local[0].messages.insert(message, at: 0)
        transform?(data.local)
    }
}

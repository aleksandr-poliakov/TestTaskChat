//
//  ChatSotre.swift
//  MuzzApplication
//
//  Created by Aleksandr on 27.09.2022.
//

import Foundation

/// A `ChatStore` takes responsibility to local storage with core data persistance and flow in the application.
protocol ChatStore {
    typealias Data = (local: [LocalChat], chat: [Chat])
    
    func insert(chat: Chat?, text: String, upcoming: Bool)
    func retrieve() -> Data
}

//
//  ChatComposer.swift
//  MuzzApplication
//
//  Created by Aleksandr on 27.09.2022.
//

import UIKit

final class ChatComposer {
    private init() {}

    static func composeWith(manager: ChatStore) -> ChatViewController {
        let viewModel = ChatViewModel(store: manager)
        let viewController =  ChatViewController(viewModel: viewModel)
        return viewController
    }
}

//
//  ApplicationCoordinator.swift
//  MuzzApplication
//
//  Created by Aleksandr on 26.09.2022.
//

import UIKit

final class ApplicationCoordinator: Coordinator {
    
    private let window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        let localStore = LocalChatStorage(decorator: CalendarDecorator.shared)
        let chatViewController = ChatComposer.composeWith(manager: localStore)
        window.rootViewController = UINavigationController(rootViewController: chatViewController)
        window.makeKeyAndVisible()
    }
}

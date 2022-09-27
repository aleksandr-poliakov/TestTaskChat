//
//  Coordinator.swift
//  MuzzApplication
//
//  Created by Aleksandr on 26.09.2022.
//

import Foundation

/// A `Coordinator` takes responsibility about coordinating view controllers and driving the flow in the application.
protocol Coordinator: AnyObject {
    func start()
}

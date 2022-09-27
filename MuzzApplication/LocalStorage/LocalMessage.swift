//
//  LocalMessage.swift
//  MuzzApplication
//
//  Created by Aleksandr on 27.09.2022.
//

import Foundation

struct LocalMessage: Equatable {
    let title: String
    let date: Date
    let upcoming: Bool
    
    init(title: String, date: Date, upcoming: Bool) {
        self.title = title
        self.date = date
        self.upcoming = upcoming
    }
}

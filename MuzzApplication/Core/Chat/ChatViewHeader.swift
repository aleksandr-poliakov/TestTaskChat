//
//  ChatViewHeader.swift
//  MuzzApplication
//
//  Created by Aleksandr on 27.09.2022.
//

import UIKit

class ChatViewHeader: UIView {

    private let titleLabel = UILabel()

    init() {
        super.init(frame: .zero)
        transform = CGAffineTransform(scaleX: 1, y: -1)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureView(_ chat: LocalChat) {
        if #available(iOS 15.0, *) {
            titleLabel.text = chat.date.formatted(.dateTime.day().month().year().hour().minute())
        } else {
            titleLabel.text = chat.date.description
        }
    }
    
    private func setupUI() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textAlignment = .center
        addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 6),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -6),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 6),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -6)
        ])
    }
}

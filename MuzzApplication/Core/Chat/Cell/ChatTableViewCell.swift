//
//  ChatTableViewCell.swift
//  MuzzApplication
//
//  Created by Aleksandr on 27.09.2022.
//

import UIKit

final class ChatTableViewCell: UITableViewCell {

    private let messageLabel = UILabel()
    private let bubbleBackgroundView = UIView()
    private var leadingConstraint: NSLayoutConstraint = NSLayoutConstraint()
    private var trailingConstraint: NSLayoutConstraint = NSLayoutConstraint()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        transform = CGAffineTransform(scaleX: 1, y: -1)
        selectionStyle = .none
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(model: LocalMessage) {
        messageLabel.text = model.title
        if model.upcoming {
            leadingConstraint.isActive = true
            trailingConstraint.isActive = false
            bubbleBackgroundView.backgroundColor = .red
        } else {
            leadingConstraint.isActive = false
            trailingConstraint.isActive = true
            bubbleBackgroundView.backgroundColor = .blue
        }
    }
    
    private func setupUI() {
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.textColor = .white
        bubbleBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        bubbleBackgroundView.layer.cornerRadius = 8
        messageLabel.numberOfLines = 0
        
        [bubbleBackgroundView, messageLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
 
        NSLayoutConstraint.activate([
            messageLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
            messageLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24),
            messageLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 250),
            
            bubbleBackgroundView.topAnchor.constraint(equalTo: messageLabel.topAnchor, constant: -16),
            bubbleBackgroundView.leadingAnchor.constraint(equalTo: messageLabel.leadingAnchor, constant: -16),
            bubbleBackgroundView.bottomAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 16),
            bubbleBackgroundView.trailingAnchor.constraint(equalTo: messageLabel.trailingAnchor, constant: 16)
        ])
        
        leadingConstraint = messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 28)
        leadingConstraint.isActive = false
        trailingConstraint = messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -28)
        trailingConstraint.isActive = true
    }
}

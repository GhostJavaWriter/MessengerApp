//
//  ConversationTableViewCell.swift
//  MessengerApp
//
//  Created by Bair Nadtsalov on 28.02.2021.
//

import UIKit

protocol ConversationCellConfiguration {
    
    var name : String? {get set}
    var message : String? {get set}
    var date : Date? {get set}
    var online : Bool {get set}
    var hasUnreadMessages : Bool {get set}
}

class ConversationTableViewCell: UITableViewCell, ConversationCellConfiguration {
    
    private var shouldSetupConstraints = true
    
    override func updateConstraints() {
        print("update constraints")
        if shouldSetupConstraints {
            configureView()
            shouldSetupConstraints = false
        }
        
        super.updateConstraints()
    }
    
    private var nameLabel = UILabel()
    private var messageLabel = UILabel()
    private var lastMessageTimeLabel = UILabel()
    
    private func configureView() {
        
        contentView.addSubview(nameLabel)
        contentView.addSubview(messageLabel)
        contentView.addSubview(lastMessageTimeLabel)
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.setContentHuggingPriority(UILayoutPriority.defaultLow, for: .horizontal)
        
        lastMessageTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        lastMessageTimeLabel.setContentHuggingPriority(UILayoutPriority.defaultHigh, for: .horizontal)
        lastMessageTimeLabel.setContentCompressionResistancePriority(UILayoutPriority.defaultHigh, for: .horizontal)
        lastMessageTimeLabel.font = .systemFont(ofSize: 12)
        
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([

            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 30),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30),

            lastMessageTimeLabel.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: 10),
            lastMessageTimeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -30),
            lastMessageTimeLabel.lastBaselineAnchor.constraint(equalTo: nameLabel.lastBaselineAnchor, constant: 0),
            lastMessageTimeLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 30),
            
            messageLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5),
            messageLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            messageLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -30)

        ])
    }
    
    var name: String?
    var message: String?
    var date: Date?
    var online: Bool = false
    var hasUnreadMessages: Bool = false
    
    func configure(with model: ConversationModel) {
        
        name = model.name
        message = model.message
        date = model.date
        online = model.online
        hasUnreadMessages = model.hasUnreadMessages
        
        nameLabel.text = name
        nameLabel.font = .systemFont(ofSize: 20)
        
        messageLabel.numberOfLines = 2
        messageLabel.lineBreakMode = .byTruncatingTail
        
        if let lastMessage = message {
            messageLabel.text = lastMessage
        } else {
            messageLabel.text = "No messages yet"
            messageLabel.font = UIFont(name: "Arial", size: 14)
            hasUnreadMessages = false
        }
        
        lastMessageTimeLabel.text = date?.description
        
        if online {
            self.backgroundColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
        } else {
            self.backgroundColor = .white
        }
        
        if hasUnreadMessages {
            messageLabel.font = .boldSystemFont(ofSize: 14)
        } else {
            messageLabel.font = .systemFont(ofSize: 14)
        }
    }
}

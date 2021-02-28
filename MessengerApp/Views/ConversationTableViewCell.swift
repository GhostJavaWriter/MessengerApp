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
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private var nameLabel = UILabel()
    private var messageLabel = UILabel()
    private var lastMessageTimeLabel = UILabel()
    
    private func configureView() {
        contentView.addSubview(nameLabel)
        contentView.addSubview(messageLabel)
        contentView.addSubview(lastMessageTimeLabel)
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        lastMessageTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            
            messageLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            messageLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor),
            
            lastMessageTimeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            lastMessageTimeLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            
            //TODO: add contentHuggingPriority
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
        hasUnreadMessages = model.online
        
        nameLabel.text = name
        
        if let lastMessage = message {
            messageLabel.text = lastMessage
        } else {
            messageLabel.text = "No messages yet"
            messageLabel.font = UIFont(name: "Arial", size: 10)
        }
        
        lastMessageTimeLabel.text = date?.description
        
        if online {
            self.backgroundColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
        } else {
            self.backgroundColor = .white
        }
        
        if hasUnreadMessages {
            messageLabel.font = .boldSystemFont(ofSize: 10)
        } else {
            messageLabel.font = .systemFont(ofSize: 10)
        }
    }
}

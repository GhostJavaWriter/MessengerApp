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
    
    private var shouldSetupConstraints = true
    
    private var nameLabel = UILabel()
    private var messageLabel = UILabel()
    private var lastMessageTimeLabel = UILabel()
    
    private func configureView() {
        
        contentView.addSubview(nameLabel)
        contentView.addSubview(messageLabel)
        contentView.addSubview(lastMessageTimeLabel)
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.setContentHuggingPriority(UILayoutPriority.defaultLow, for: .horizontal)
        nameLabel.setContentCompressionResistancePriority(UILayoutPriority.defaultLow, for: .horizontal)
        nameLabel.font = .systemFont(ofSize: 20)
        
        lastMessageTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        lastMessageTimeLabel.setContentHuggingPriority(UILayoutPriority.defaultHigh, for: .horizontal)
        lastMessageTimeLabel.setContentCompressionResistancePriority(UILayoutPriority.defaultHigh, for: .horizontal)
        lastMessageTimeLabel.font = .systemFont(ofSize: 14)
        
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.numberOfLines = 2
        messageLabel.lineBreakMode = .byTruncatingTail
    
    }
    
    private func getFormatedTime(from date: Date) -> String {
        
        let dateFormatter = DateFormatter()
        
        if checkDate(date) {
            dateFormatter.dateFormat = "HH:mm"
        } else {
            dateFormatter.dateFormat = "dd MMM"
        }
        
        let currentTime = dateFormatter.string(from: date)
        
        return currentTime
    }
    
    private func checkDate(_ lastDate: Date) -> Bool {
        let calendar = Calendar.current
        
        let startOfLastDate =  calendar.startOfDay(for: lastDate)
        let startOfToday = calendar.startOfDay(for: Date())
        
        if let numberOfDays = calendar.dateComponents([.day], from: startOfLastDate, to: startOfToday).day {
            return numberOfDays < 1
        } else {
            return false
        }
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
        
        nameLabel.text = name ?? "Unknown"
        
        if let date = date {
            lastMessageTimeLabel.text = getFormatedTime(from: date)
        }
        
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
        
        if let lastMessage = message {
            messageLabel.text = lastMessage
        } else {
            messageLabel.text = "No messages yet"
            messageLabel.font = UIFont(name: "AppleSDGothicNeo-Thin", size: 14)
        }
    }
    
    override func updateConstraints() {
        
        if shouldSetupConstraints {
            
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
            
            shouldSetupConstraints = false
        }
        
        super.updateConstraints()
    }
}

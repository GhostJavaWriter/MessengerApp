//
//  ConversationsListTableViewCell.swift
//  MessengerApp
//
//  Created by Bair Nadtsalov on 28.02.2021.
//

import UIKit

class ConversationsListTableViewCell: UITableViewCell {
    
    private var nameLabel = AppLabel()
    private var messageLabel = AppLabel()
    private var lastMessageTimeLabel = AppLabel()
    private var avatarImage = UIView()
    
    private func configureView() {
        
        contentView.addSubview(nameLabel)
        contentView.addSubview(messageLabel)
        contentView.addSubview(lastMessageTimeLabel)
        contentView.addSubview(avatarImage)
        
        //FIXME: change fixed values to drowing circle with UIBizierPath and add views to UIStackView
        avatarImage.layer.cornerRadius = 30
        avatarImage.translatesAutoresizingMaskIntoConstraints = false
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.setContentHuggingPriority(UILayoutPriority.defaultLow, for: .horizontal)
        nameLabel.setContentCompressionResistancePriority(UILayoutPriority.defaultLow, for: .horizontal)
        nameLabel.font = .systemFont(ofSize: 20)
        
        lastMessageTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        lastMessageTimeLabel.setContentHuggingPriority(UILayoutPriority.defaultHigh, for: .horizontal)
        lastMessageTimeLabel.setContentCompressionResistancePriority(UILayoutPriority.defaultHigh, for: .horizontal)
        lastMessageTimeLabel.font = .systemFont(ofSize: 14)
        
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.numberOfLines = 1
        messageLabel.lineBreakMode = .byTruncatingTail
        messageLabel.font = .systemFont(ofSize: 14)
        
        NSLayoutConstraint.activate([
            
            avatarImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            avatarImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30),
            avatarImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            avatarImage.widthAnchor.constraint(equalToConstant: 60),
            
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            nameLabel.leadingAnchor.constraint(equalTo: avatarImage.trailingAnchor, constant: 10),

            lastMessageTimeLabel.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: 10),
            lastMessageTimeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -30),
            lastMessageTimeLabel.lastBaselineAnchor.constraint(equalTo: nameLabel.lastBaselineAnchor, constant: 0),
            lastMessageTimeLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            
            messageLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5),
            messageLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            messageLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -30),
            messageLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
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
            //Тут не знаю, насколько правильно обрабатывать даты из будущего, но добавил abs
            return abs(numberOfDays) < 1
        } else {
            return false
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func configure(name: String?, message: String?, date: Date?, online: Bool, hasUnreadMessages: Bool) {
        
        if let name = name {
            nameLabel.text = name
            nameLabel.font = .systemFont(ofSize: 20)
        } else {
            nameLabel.text = "Unknown"
            nameLabel.font = UIFont(name: "AppleSDGothicNeo-Thin", size: 20)
        }
        
        if let date = date {
            lastMessageTimeLabel.text = getFormatedTime(from: date)
        }
        
        if online {
            avatarImage.backgroundColor = #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)
        } else {
            avatarImage.backgroundColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
        }
        
        if let lastMessage = message {
            
            if hasUnreadMessages {
                messageLabel.font = .boldSystemFont(ofSize: 14)
            }
            
            messageLabel.text = lastMessage
            
        } else {
            messageLabel.text = "No messages yet"
            messageLabel.font = UIFont(name: "AppleSDGothicNeo-Thin", size: 14)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        nameLabel.text = nil
        messageLabel.text = nil
        messageLabel.font = .systemFont(ofSize: 14)
        lastMessageTimeLabel.text = nil
    }
}

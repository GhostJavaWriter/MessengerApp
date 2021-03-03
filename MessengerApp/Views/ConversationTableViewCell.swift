//
//  ConversationTableViewCell.swift
//  MessengerApp
//
//  Created by Bair Nadtsalov on 28.02.2021.
//

import UIKit

class ConversationTableViewCell: UITableViewCell {
    
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
    
    func configure(with model: ConversationModel) {
        
        nameLabel.text = model.name ?? "Unknown"
        
        if let date = model.date {
            lastMessageTimeLabel.text = getFormatedTime(from: date)
        }
        
        if model.online {
            self.backgroundColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
        } else {
            self.backgroundColor = .white
        }
        
        if model.hasUnreadMessages {
            messageLabel.font = .boldSystemFont(ofSize: 14)
        } else {
            messageLabel.font = .systemFont(ofSize: 14)
        }
        
        if let lastMessage = model.message {
            messageLabel.text = lastMessage
        } else {
            messageLabel.text = "No messages yet"
            messageLabel.font = UIFont(name: "AppleSDGothicNeo-Thin", size: 14)
        }
        
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        nameLabel.text = nil
        messageLabel.text = nil
        lastMessageTimeLabel.text = nil
    }
}

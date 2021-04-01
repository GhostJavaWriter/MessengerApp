//
//  ChannelTableViewCell.swift
//  MessengerApp
//
//  Created by Bair Nadtsalov on 28.02.2021.
//

import UIKit

class ChannelTableViewCell: UITableViewCell {
    
    private var nameLabel = AppLabel()
    private var lastMessageLabel = AppLabel()
    private var lastActivityLabel = AppLabel()
    private var avatarImage = UIView()
    
    private func configureView() {
        
        contentView.addSubview(nameLabel)
        contentView.addSubview(lastMessageLabel)
        contentView.addSubview(lastActivityLabel)
        contentView.addSubview(avatarImage)
        
        // FIXME: change fixed values to drowing circle with UIBizierPath and add views to UIStackView
        avatarImage.layer.cornerRadius = 30
        avatarImage.translatesAutoresizingMaskIntoConstraints = false
        avatarImage.backgroundColor = .yellow
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.setContentHuggingPriority(UILayoutPriority.defaultLow, for: .horizontal)
        nameLabel.setContentCompressionResistancePriority(UILayoutPriority.defaultLow, for: .horizontal)
        nameLabel.font = .systemFont(ofSize: 20)
        
        lastActivityLabel.translatesAutoresizingMaskIntoConstraints = false
        lastActivityLabel.setContentHuggingPriority(UILayoutPriority.defaultHigh, for: .horizontal)
        lastActivityLabel.setContentCompressionResistancePriority(UILayoutPriority.defaultHigh, for: .horizontal)
        lastActivityLabel.font = .systemFont(ofSize: 14)
        
        lastMessageLabel.translatesAutoresizingMaskIntoConstraints = false
        lastMessageLabel.numberOfLines = 1
        lastMessageLabel.lineBreakMode = .byTruncatingTail
        lastMessageLabel.font = .systemFont(ofSize: 14)
        
        NSLayoutConstraint.activate([
            
            avatarImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            avatarImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30),
            avatarImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            avatarImage.widthAnchor.constraint(equalToConstant: 60),
            
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            nameLabel.leadingAnchor.constraint(equalTo: avatarImage.trailingAnchor, constant: 10),

            lastActivityLabel.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: 10),
            lastActivityLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -30),
            lastActivityLabel.lastBaselineAnchor.constraint(equalTo: nameLabel.lastBaselineAnchor, constant: 0),
            lastActivityLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            
            lastMessageLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5),
            lastMessageLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            lastMessageLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -30),
            lastMessageLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
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
        
        let startOfLastDate = calendar.startOfDay(for: lastDate)
        let startOfToday = calendar.startOfDay(for: Date())
        
        if let numberOfDays = calendar.dateComponents([.day], from: startOfLastDate, to: startOfToday).day {
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
    
    func configure(name: String?, lastMessage: String?, lastActivity: Date?, identifier: String?) {
        
        nameLabel.text = name
        nameLabel.font = .systemFont(ofSize: 20)
        
        if let date = lastActivity {
            lastActivityLabel.text = getFormatedTime(from: date)
        }
        
        if let message = lastMessage {
            lastMessageLabel.text = message
        } else {
            lastMessageLabel.text = "No messages yet"
            lastMessageLabel.font = UIFont(name: "AppleSDGothicNeo-Thin", size: 14)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        nameLabel.text = nil
        lastMessageLabel.text = nil
        lastMessageLabel.font = .systemFont(ofSize: 14)
        lastActivityLabel.text = nil
    }
}

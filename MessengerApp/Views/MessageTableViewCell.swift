//
//  MessageTableViewCell.swift
//  MessengerApp
//
//  Created by Bair Nadtsalov on 02.03.2021.
//

import UIKit

class MessageTableViewCell: UITableViewCell {
    
    func configure(isInboxMessage side: Bool, text: String?) {
        messageLabel.text = text
        isInboxMessage = side
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private var messageLabel = UILabel()
    
    private var isInboxMessage = false
    
    private func configureView() {
        
        contentView.addSubview(messageLabel)
        
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.numberOfLines = 0
        messageLabel.lineBreakMode = .byWordWrapping
        
        messageLabel.layer.borderWidth = 1
        messageLabel.layer.borderColor = UIColor.darkGray.cgColor
    }
    
    override func updateConstraints() {
        
        let messageInset = contentView.frame.width/4
        
        messageLabel.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        messageLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        
        if isInboxMessage {
            messageLabel.textAlignment = .left
            messageLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
            messageLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -messageInset).isActive = true
        } else {
            messageLabel.textAlignment = .right
            messageLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: messageInset).isActive = true
            messageLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        }
        
        super.updateConstraints()
    }

}

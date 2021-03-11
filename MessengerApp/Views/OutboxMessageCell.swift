//
//  OutboxMessageCell.swift
//  MessengerApp
//
//  Created by Bair Nadtsalov on 04.03.2021.
//

import UIKit

class OutboxMessageCell: UITableViewCell {
    
    private var messageBgView = AppOutboxMessageView()
    private var messageLabel = AppLabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        messageBgView.addSubview(messageLabel)
        contentView.addSubview(messageBgView)
        
        let edgeInset : CGFloat = 30
        let labelInset : CGFloat = 5
        let messageInset = contentView.frame.width/4
        
        messageBgView.translatesAutoresizingMaskIntoConstraints = false
        messageBgView.layer.cornerRadius = 10
        
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.numberOfLines = 0
        messageLabel.lineBreakMode = .byWordWrapping
        messageLabel.textAlignment = .left
        
        NSLayoutConstraint.activate([
            messageBgView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: labelInset),
            messageBgView.leadingAnchor.constraint(greaterThanOrEqualTo: contentView.leadingAnchor, constant: messageInset),
            messageBgView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -edgeInset),
            messageBgView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -labelInset),
            
            messageLabel.topAnchor.constraint(equalTo: messageBgView.topAnchor, constant: labelInset),
            messageLabel.bottomAnchor.constraint(equalTo: messageBgView.bottomAnchor, constant: -labelInset),
            messageLabel.leadingAnchor.constraint(equalTo: messageBgView.leadingAnchor, constant: labelInset),
            messageLabel.trailingAnchor.constraint(equalTo: messageBgView.trailingAnchor, constant: -labelInset)
        ])
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func configure(text: String?) {
        messageLabel.text = text
    }
}


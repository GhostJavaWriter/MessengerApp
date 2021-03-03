//
//  MessageTableViewCell.swift
//  MessengerApp
//
//  Created by Bair Nadtsalov on 02.03.2021.
//

import UIKit

class MessageTableViewCell: UITableViewCell {
    
    private var messageLabel = UILabel()
    private var isInbox = false
    
    private var inboxLayoutConstraints = [NSLayoutConstraint]()
    private var outboxLayoutConstraints = [NSLayoutConstraint]()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(messageLabel)
        
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.numberOfLines = 0
        messageLabel.lineBreakMode = .byWordWrapping
        
        messageLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        messageLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10).isActive = true
        
        let messageInset = contentView.frame.width/4
        let edgeInset : CGFloat = 30
        
        let inboxLeadingAnchor = messageLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: edgeInset)
        let inboxTrailingAnchor = messageLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -messageInset)
        
        inboxLayoutConstraints.append(inboxLeadingAnchor)
        inboxLayoutConstraints.append(inboxTrailingAnchor)
        
        NSLayoutConstraint.activate(inboxLayoutConstraints)
        
        let outboxLeadingAnchor = messageLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: messageInset)
        let outboxTrailingAnchor = messageLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -edgeInset)
        
        outboxLayoutConstraints.append(outboxLeadingAnchor)
        outboxLayoutConstraints.append(outboxTrailingAnchor)
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func configure(text: String?, isInbox: Bool) {
        messageLabel.text = text
        self.isInbox = isInbox
    }
    
    override func updateConstraints() {
    
        if isInbox {
            messageLabel.textAlignment = .left
            
            NSLayoutConstraint.deactivate(outboxLayoutConstraints)
            NSLayoutConstraint.activate(inboxLayoutConstraints)
            
        } else {
            messageLabel.textAlignment = .right
            
            NSLayoutConstraint.deactivate(inboxLayoutConstraints)
            NSLayoutConstraint.activate(outboxLayoutConstraints)
        }
        super.updateConstraints()
    }
}

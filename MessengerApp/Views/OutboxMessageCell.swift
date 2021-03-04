//
//  OutboxMessageCell.swift
//  MessengerApp
//
//  Created by Bair Nadtsalov on 04.03.2021.
//

import UIKit

class OutboxMessageCell: UITableViewCell {
    
    private var messageLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(messageLabel)
        
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.numberOfLines = 0
        messageLabel.lineBreakMode = .byWordWrapping
        messageLabel.textAlignment = .right
        
        let edgeInset : CGFloat = 30
        let messageInset = contentView.frame.width/4
        
        messageLabel.topAnchor.constraint(equalTo: contentView.topAnchor,
                                          constant: 10).isActive = true
        messageLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,
                                             constant: -10).isActive = true
        messageLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                              constant: messageInset).isActive = true
        messageLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                               constant: -edgeInset).isActive = true
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func configure(text: String?) {
        messageLabel.text = text
    }
}


//
//  MessageTableViewCell.swift
//  MessengerApp
//
//  Created by Bair Nadtsalov on 02.03.2021.
//

import UIKit

class MessageTableViewCell: UITableViewCell {
    
    var messageLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func configureView() {
        
        contentView.addSubview(messageLabel)
        
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.numberOfLines = 0
        messageLabel.lineBreakMode = .byWordWrapping
        
        messageLabel.layer.borderWidth = 1
        messageLabel.layer.borderColor = UIColor.darkGray.cgColor
    }
    
    override func updateConstraints() {
        
        NSLayoutConstraint.activate([

            messageLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            messageLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            messageLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)

        ])
        
        super.updateConstraints()
    }

}

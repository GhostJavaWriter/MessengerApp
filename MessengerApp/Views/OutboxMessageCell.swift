//
//  InboxMessageCell.swift
//  MessengerApp
//
//  Created by Bair Nadtsalov on 02.03.2021.
//

import UIKit

class OutboxMessageCell: UITableViewCell {
    
// MARK: - UI
    
    private var messageBgView: AppInboxMessageView = {
        let view = AppInboxMessageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
        return view
    }()
    
    private var messageLabel: AppLabel = {
        let label = AppLabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .left
        return label
    }()
    
// MARK: - Private
    
    private func configureViews() {
        
        messageBgView.addSubview(messageLabel)
        contentView.addSubview(messageBgView)
        
        let edgeInset: CGFloat = 30
        let labelInset: CGFloat = 5
        let messageInset = contentView.frame.width / 4
        
        NSLayoutConstraint.activate([
            messageBgView.topAnchor.constraint(equalTo: contentView.topAnchor,
                                               constant: labelInset),
            messageBgView.leadingAnchor.constraint(greaterThanOrEqualTo: contentView.leadingAnchor,
                                                   constant: messageInset),
            messageBgView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                                    constant: -edgeInset),
            messageBgView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,
                                                  constant: -labelInset),
            
            messageLabel.topAnchor.constraint(equalTo: messageBgView.topAnchor,
                                              constant: labelInset),
            messageLabel.bottomAnchor.constraint(equalTo: messageBgView.bottomAnchor,
                                                 constant: -labelInset),
            messageLabel.leadingAnchor.constraint(equalTo: messageBgView.leadingAnchor,
                                                  constant: labelInset),
            messageLabel.trailingAnchor.constraint(equalTo: messageBgView.trailingAnchor,
                                                   constant: -labelInset)
        ])
    }

// MARK: - LifeCycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
// MARK: - Setting
    
    func configure(content: String, created: Date, senderId: String) {
        
        messageLabel.text = content
    }
}

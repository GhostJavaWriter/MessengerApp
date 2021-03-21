//
//  ConversationViewController.swift
//  MessengerApp
//
//  Created by Bair Nadtsalov on 02.03.2021.
//

import UIKit

class ConversationViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var companionName : String?
    
    //MARK: - Private
    
    private let inboxCellIdentifier = String(describing: InboxMessageCell.self)
    private let outboxCellIdentifier = String(describing: OutboxMessageCell.self)
    
    private lazy var tableView : UITableView = {
        
        let tableView = UITableView(frame: CGRect.zero, style: .plain)
        
        tableView.register(InboxMessageCell.self, forCellReuseIdentifier: inboxCellIdentifier)
        tableView.register(OutboxMessageCell.self, forCellReuseIdentifier: outboxCellIdentifier)
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 80
        
        return tableView
    }()
    
    private let messages = [MessageModel(text: "Hi there!", isInbox: true),
                            MessageModel(text: "Hi!", isInbox: false),
                            MessageModel(text: "How are you?", isInbox: true),
                            MessageModel(text: "I'm fine, what about you?", isInbox: false),
                            MessageModel(text: "I'm ok", isInbox: true),
                            MessageModel(text: "Have you seen the sunrise this morning?", isInbox: false),
                            MessageModel(text: "Nope", isInbox: true),
                            MessageModel(text: "Nope jjjj aaa jfdf adfsfsfsf sfdsfsdf fdsfds fd fdfdf f dsfdsfs fsdf fsdff fdsfkjlj jlkjl ljlkj kkljlk jlklkj jlkklj jlkjklll ll", isInbox: false),
                            MessageModel(text: "Nope2 fs inbox inbox Nope2 fs inbox inbox Nope2 fs inbox inbox Nope2 fs inbox inbox Nope2 fs inbox inbox Nope2 fs inbox inbox Nope2 fs inbox inbox Nope2 fs inbox inbox Nope2 fs inbox inbox Nope2 fs inbox inbox", isInbox: true),
                            MessageModel(text: "Nope3", isInbox: false),
                            MessageModel(text: "Nope5", isInbox: false),
                            MessageModel(text: "Nope6 fs inbox inbox Nope2 fs inbox inbox Nope2 fs inbox inbox Nope2 fs inbox inbox Nope2 fs inbox inbox Nope2 fs inbox inbox Nope2 fs inbox inbox Nope2 fs inbox inbox Nope2 fs inbox inbox", isInbox: true),
                            MessageModel(text: "Nope7", isInbox: false),
                            MessageModel(text: "Nope8", isInbox: true),
                            MessageModel(text: "Nope6 fs inbox inbox Nope2 fs inbox inbox Nope2 fs inbox inbox Nope2 fs inbox inbox Nope2 fs inbox inbox Nope2 fs joker", isInbox: false),
                           
    ]
    
    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        
        view.backgroundColor = .white
        
        if let name = companionName {
            title = name
        } else {
            title = "Unknown"
        }
        
        view.addSubview(tableView)
        tableView.frame = view.safeAreaLayoutGuide.layoutFrame
    }
    
    //MARK: - UITableViewDelegate, UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let messageModel = messages[indexPath.row]
        
        if messageModel.isInbox {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: inboxCellIdentifier, for: indexPath) as? InboxMessageCell else { return UITableViewCell() }
            cell.selectionStyle = .none
            cell.configure(text: messageModel.text)
            
            return cell
        }
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: outboxCellIdentifier, for: indexPath) as? OutboxMessageCell else { return UITableViewCell() }
        cell.selectionStyle = .none
        cell.configure(text: messageModel.text)
        
        return cell
    }
}

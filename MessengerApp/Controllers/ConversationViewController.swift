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
    
    private let cellIdentifier = String(describing: MessageTableViewCell.self)
    
    private lazy var tableView : UITableView = {
        
        let tableView = UITableView(frame: CGRect.zero, style: .plain)
        tableView.register(MessageTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        return tableView
    }()
    
    private func configureTableView() {
        
        view.addSubview(tableView)
        tableView.pinToSafeAreaEdges()
        
        tableView.separatorStyle = .none
    }
    
    private let messages = [MessageModel(text: "Hi there!", isInbox: true),
                            MessageModel(text: "Hi!", isInbox: false),
                            MessageModel(text: "How are you?", isInbox: true),
                            MessageModel(text: "I'm fine, what about you?", isInbox: false),
                            MessageModel(text: "I'm ok", isInbox: true),
                            MessageModel(text: "Have you seen the sunrise this morning?", isInbox: false),
                            MessageModel(text: "Nope", isInbox: true),
                            MessageModel(text: "Nope jjjj aaa jfdf adfsfsfsf sfdsfsdf fdsfds fd fdfdf f dsfdsfs fsdf fsdff fdsfkjlj jlkjl ljlkj kkljlk jlklkj jlkklj jlkjklll ll", isInbox: false),
                            MessageModel(text: "Nope2 fs inbox inbox Nope2 fs inbox inbox Nope2 fs inbox inbox Nope2 fs inbox inbox Nope2 fs inbox inbox Nope2 fs inbox inbox Nope2 fs inbox inbox Nope2 fs inbox inbox Nope2 fs inbox inbox Nope2 fs inbox inbox Nope2 fs inbox inbox Nope2 fs inbox inbox Nope2 fs inbox inbox Nope2 fs inbox inbox Nope2 fs inbox inbox Nope2 fs inbox inbox Nope2 fs inbox inbox Nope2 fs inbox inbox Nope2 fs inbox inbox Nope2 fs inbox inbox", isInbox: true),
                            MessageModel(text: "Nope3", isInbox: false),
                            MessageModel(text: nil, isInbox: true),
                            MessageModel(text: "Nope5", isInbox: false),
                            MessageModel(text: "Nope6", isInbox: true),
                            MessageModel(text: "Nope7", isInbox: false),
                            MessageModel(text: "Nope8", isInbox: true),
                            MessageModel(text: "Nope9", isInbox: false),
                            MessageModel(text: "Nope10", isInbox: false),
                            MessageModel(text: "Nope11", isInbox: false),
    ]
    
    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        
        view.backgroundColor = .white
        
        if let name = companionName {
            title = name
        } else {
            title = "Unknown"
        }
        
        configureTableView()
    }
    
    //MARK: - UITableViewDelegate, UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? MessageTableViewCell else { return UITableViewCell()}
        
        let messageModel = messages[indexPath.row]
        
        cell.configure(text: messageModel.text, isInbox: messageModel.isInbox)
        cell.setNeedsUpdateConstraints()
        return cell
    }
}

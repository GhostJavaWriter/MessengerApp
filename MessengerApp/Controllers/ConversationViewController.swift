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
        
        //tableView.separatorStyle = .none
        
        
    }
    
    private let messages = [MessageModel(text: "Hi there!", isInbox: false),
                            MessageModel(text: "Hi!", isInbox: true),
                            MessageModel(text: "How are you?", isInbox: false),
                            MessageModel(text: "I'm fine, what about you?", isInbox: true),
                            MessageModel(text: "I'm ok", isInbox: false),
                            MessageModel(text: "Have you seen the sunrise this morning?", isInbox: true),
                            MessageModel(text: "Nope", isInbox: false),
    ]
    
    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        
        view.backgroundColor = .white
        
        title = companionName
        
        configureTableView()
    }
    
    //MARK: - UITableViewDelegate, UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? MessageTableViewCell else { return UITableViewCell()}
        
        cell.setNeedsUpdateConstraints()
        //let someText = "some text sdfsfsdfsdfsdfs sdfsdf sd fsdf s fsdf sdfsfsfsdfs sd fsd fsd "
        
        let messageModel = messages[indexPath.row]
        
        cell.configure(isInboxMessage: messageModel.isInbox, text: messageModel.text)
        
        return cell
    }
    
    
}

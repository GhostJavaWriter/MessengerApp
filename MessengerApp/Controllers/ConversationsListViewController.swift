//
//  ConversationsListViewController.swift
//  MessengerApp
//
//  Created by Bair Nadtsalov on 28.02.2021.
//

import UIKit

struct Section {
    var title : String
    var group : [ConversationModel]
}

class ConversationsListViewController : UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    //MARK: - Private
    private let cellIdentifier = String(describing: ConversationTableViewCell.self)
    
    private lazy var tableView : UITableView = {
        
        let tableView = UITableView(frame: CGRect.zero, style: .plain)
        tableView.register(ConversationTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        return tableView
    }()
    
    //TODO: fix models state
    private var conversationsList = [Section(title: "Online",
                                             group: [ConversationModel(name: "Ronald Robertson", message: "An suas viderer pro. Vis cu magna altera, ex his vivendo atomorum.", date: nil, online: true, hasUnreadMessages: false),
                                                     ConversationModel(name: "Johnny Watson", message: "Reprehenderit mollit excepteur labore", date: nil, online: true, hasUnreadMessages: false),
                                                     ConversationModel(name: "Ronald Robertson", message: "An suas viderer pro. Vis cu magna altera, ex his vivendo atomorum.", date: nil, online: true, hasUnreadMessages: false),
                                                     ConversationModel(name: "Johnny Watson", message: "Reprehenderit mollit excepteur labore", date: nil, online: true, hasUnreadMessages: false),
                                                     ConversationModel(name: "Johnny", message: "Reprehenderit mollit excepteur labore", date: nil, online: true, hasUnreadMessages: false),
                                                     ConversationModel(name: "Watson", message: "Reprehenderit mollit excepteur labore", date: nil, online: true, hasUnreadMessages: false),
                                                     ConversationModel(name: "J. Watson", message: "Reprehenderit mollit excepteur labore", date: nil, online: true, hasUnreadMessages: false),
                                                     ConversationModel(name: "Johnny W.", message: "Reprehenderit mollit excepteur labore", date: nil, online: true, hasUnreadMessages: false),
                                                     ConversationModel(name: "Hudson", message: "Reprehenderit mollit excepteur labore", date: nil, online: true, hasUnreadMessages: true),
                                                     ConversationModel(name: "Bair Nadtsalov", message: "Reprehenderit mollit excepteur labore", date: nil, online: true, hasUnreadMessages: true),
                                                     ConversationModel(name: "Jennifer", message: "Reprehenderit mollit excepteur labore", date: nil, online: true, hasUnreadMessages: true)]),
                                     Section(title: "History",
                                             group: [ConversationModel(name: "John Watson", message: "Reprehenderit mollit excepteur labore", date: nil, online: false, hasUnreadMessages: false),
                                                     ConversationModel(name: "John W.", message: "Reprehenderit mollit excepteur labore", date: nil, online: false, hasUnreadMessages: false),
                                                     ConversationModel(name: "John", message: "Reprehenderit mollit excepteur labore", date: nil, online: false, hasUnreadMessages: false),
                                                     ConversationModel(name: "JohWatson", message: "Reprehenderit mollit excepteur labore", date: nil, online: false, hasUnreadMessages: true),
                                                     ConversationModel(name: "Watson K.", message: "Reprehenderit mollit excepteur labore", date: nil, online: false, hasUnreadMessages: true),
                                                     ConversationModel(name: "H. Watson", message: "Reprehenderit mollit excepteur labore", date: nil, online: false, hasUnreadMessages: true),
                                                     ConversationModel(name: "W. Watson", message: "Reprehenderit mollit excepteur labore", date: nil, online: false, hasUnreadMessages: true),
                                                     ConversationModel(name: "O. Watson", message: "Reprehenderit mollit excepteur labore", date: nil, online: false, hasUnreadMessages: true),
                                                     ConversationModel(name: "B. Watson", message: "Reprehenderit mollit excepteur labore", date: nil, online: false, hasUnreadMessages: true),
                                                     ConversationModel(name: "P. Watson", message: "Reprehenderit mollit excepteur labore", date: nil, online: false, hasUnreadMessages: true)])
    ]
    
    //MARK: - UI
    
    private func configureTableView() {
        
        view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
    }
    
    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        
        title = "Tinkoff Chat"
        view.backgroundColor = .white
        
        configureTableView()

    }
    
    //MARK: - UITableViewDataSource, UITableViewDelegate
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return conversationsList.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return conversationsList[section].title
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return conversationsList[section].group.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ConversationTableViewCell else { return UITableViewCell() }
        
        let section = conversationsList[indexPath.section]
        let conversation = section.group[indexPath.row]
        
        cell.configure(with: conversation)
        
        return cell
    }
}

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
    private let cellIdentifier = String(describing: ConversationsListTableViewCell.self)
    
    private lazy var tableView : UITableView = {
        
        let tableView = UITableView(frame: CGRect.zero, style: .plain)
        tableView.register(ConversationsListTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        
        return tableView
    }()
    
    private var conversationsList = [Section(title: "Online",
                                             group: [ConversationModel(name: nil, message: "name nil, have date, online = true, hasUnreadMessages = true", date: Date(), online: true, hasUnreadMessages: true),
                                                     ConversationModel(name: "Johnny Watson", message: nil, date: nil, online: true, hasUnreadMessages: true),
                                                     ConversationModel(name: "Ronald Robertson", message: "have name, have date, online = true, hasUnreadMessages = false", date: Date(), online: true, hasUnreadMessages: false),
                                                     ConversationModel(name: "Johnny Watsonnnnnnnnnnnnnnnsfadasfsasdf", message: "Reprehenderit mollit excepteur labore", date: Date(), online: true, hasUnreadMessages: true),
                                                     ConversationModel(name: "Johnny", message: nil, date: Date(), online: true, hasUnreadMessages: false),
                                                     ConversationModel(name: nil, message: nil, date: Date(), online: true, hasUnreadMessages: false),
                                                     ConversationModel(name: "J. Watson", message: "Reprehenderit mollit excepteur labore", date: Date(), online: true, hasUnreadMessages: false),
                                                     ConversationModel(name: "Johnny W.", message: "Reprehenderit mollit excepteur labore", date: Date(), online: true, hasUnreadMessages: false),
                                                     ConversationModel(name: "Hudson", message: "Reprehenderit mollit excepteur labore", date: Date(), online: true, hasUnreadMessages: true),
                                                     ConversationModel(name: "Bair Nadtsalov", message: "Reprehenderit mollit excepteur labore", date: Date(), online: true, hasUnreadMessages: true),
                                                     ConversationModel(name: "Jennifer", message: "Reprehenderit mollit excepteur labore", date: Date(), online: true, hasUnreadMessages: true)]),
                                     Section(title: "History",
                                             group: [ConversationModel(name: "John Watson", message: nil, date: nil, online: false, hasUnreadMessages: false),
                                                     ConversationModel(name: "John W.", message: "Reprehenderit mollit excepteur labore", date: nil, online: false, hasUnreadMessages: false),
                                                     ConversationModel(name: nil, message: "Reprehenderit mollit excepteur labore", date: nil, online: false, hasUnreadMessages: false),
                                                     ConversationModel(name: "JohWatson", message: "Reprehenderit mollit excepteur labore", date: nil, online: false, hasUnreadMessages: true),
                                                     ConversationModel(name: "Watson K.", message: "Reprehenderit mollit excepteur labore", date: nil, online: false, hasUnreadMessages: true),
                                                     ConversationModel(name: "H. Watson", message: "Reprehenderit mollit excepteur labore", date: nil, online: false, hasUnreadMessages: true),
                                                     ConversationModel(name: "W. Watson", message: "Reprehenderit mollit excepteur labore", date: nil, online: false, hasUnreadMessages: true),
                                                     ConversationModel(name: "O. Watson", message: "Reprehenderit mollit excepteur labore", date: nil, online: false, hasUnreadMessages: true),
                                                     ConversationModel(name: "B. Watson", message: "Reprehenderit mollit excepteur labore", date: nil, online: false, hasUnreadMessages: true),
                                                     ConversationModel(name: "P. Watson", message: "Reprehenderit mollit excepteur labore", date: Date(), online: false, hasUnreadMessages: true)])
    ]
    
    @objc
    private func openProfileView() {
        
        if let profileController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProfileViewController") as? ProfileViewController {
            
            profileController.modalTransitionStyle = .coverVertical
            present(profileController, animated: true, completion: nil)
        }
    }
    
    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        
        title = "Tinkoff Chat"
        view.backgroundColor = .white
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Profile", style: .plain, target: self, action: #selector(openProfileView))
        
        let someDate = Date()

        //For check date format of timeLabel change value here
        let modifiedDate = Calendar.current.date(byAdding: .hour, value: -73, to: someDate) // <---

        conversationsList[0].group.append(ConversationModel(name: "Eddard Stark", message: "I'm honest but stupid man", date: modifiedDate, online: true, hasUnreadMessages: false))
        
        view.addSubview(tableView)
        
        tableView.pinToSafeAreaEdges()

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
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ConversationsListTableViewCell else { return UITableViewCell() }
        
        let section = conversationsList[indexPath.section]
        let conversation = section.group[indexPath.row]
        
        cell.configure(with: conversation)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let conversationViewController = ConversationViewController()
        
        let section = conversationsList[indexPath.section]
        let conversation = section.group[indexPath.row]
        conversationViewController.companionName = conversation.name
        
        navigationController?.pushViewController(conversationViewController, animated: true)
    }
}

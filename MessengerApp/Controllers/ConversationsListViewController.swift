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
                                                     ConversationModel(name: nil, message: "Reprehenderit mollit excepteur labore", date: Date(), online: true, hasUnreadMessages: false),
                                                     ConversationModel(name: "Johnny W.", message: "Reprehenderit mollit excepteur labore", date: Date(), online: true, hasUnreadMessages: false),
                                                     ConversationModel(name: "Hudson", message: "Reprehenderit mollit excepteur labore labore fjjfj aaa jfjf jjj lll ljjj ljjlj ljlj jljlj jljlj jlj ljlj jljljljljljlj ljljljlj jljljl ljljlj ljjlj ljljlj ljljljljljl end of message", date: Date(), online: true, hasUnreadMessages: false),
                                                     ConversationModel(name: "Bair Nadtsalov", message: "Reprehenderit mollit excepteur labore", date: Date(), online: true, hasUnreadMessages: true),
                                                     ConversationModel(name: "Jennifer", message: "Reprehenderit mollit excepteur labore fjjfj aaa jfjf jjj lll ljjj ljjlj ljlj jljlj jljlj jlj ljlj jljljljljljlj ljljljlj jljljl ljljlj ljjlj ljljlj ljljljljljl end of message", date: Date(), online: true, hasUnreadMessages: true)]),
                                     Section(title: "History",
                                             group: [ConversationModel(name: "John Watson", message: "some message", date: Date(timeIntervalSinceNow: -6000.0), online: false, hasUnreadMessages: false),
                                                     ConversationModel(name: "John W.", message: "That message have no date and I have read, it's possible?", date: nil, online: false, hasUnreadMessages: false),
                                                     ConversationModel(name: nil, message: "Reprehenderit mollit excepteur labore", date: Date(), online: false, hasUnreadMessages: false),
                                                     ConversationModel(name: "JohWatson", message: "Reprehenderit mollit excepteur labore", date: Date(timeIntervalSinceNow: -86000.0), online: false, hasUnreadMessages: true),
                                                     ConversationModel(name: "Watson K.", message: "Reprehenderit mollit excepteur labore", date: Date(timeIntervalSinceNow: -172000.0), online: false, hasUnreadMessages: true),
                                                     ConversationModel(name: "John Connor", message: "I'm from the future. Reprehenderit mollit excepteur labore fjjfj aaa jfjf jjj lll ljjj ljjlj ljlj jljlj jljlj jlj ljlj jljljljljljlj ljljljlj jljljl ljljlj ljjlj ljljlj ljljljljljl end of message", date: Date(timeIntervalSinceNow: 300000.0), online: false, hasUnreadMessages: false),
                                                     ConversationModel(name: "W. Watson", message: "Reprehenderit mollit excepteur labore fjjfj aaa jfjf jjj lll ljjj ljjlj ljlj jljlj jljlj jlj ljlj jljljljljljlj ljljljlj jljljl ljljlj ljjlj ljljlj ljljljljljl end of message", date: Date(timeIntervalSinceNow: -300000.0), online: false, hasUnreadMessages: true),
                                                     ConversationModel(name: nil, message: "Reprehenderit mollit excepteur labore", date: Date(timeIntervalSinceNow: -300000.0), online: false, hasUnreadMessages: true),
                                                     ConversationModel(name: "B. Watson", message: "That message have no date and I didn't read", date: nil, online: false, hasUnreadMessages: true),
                                                     ConversationModel(name: "P. Watson", message: "Reprehenderit mollit excepteur labore", date: Date(timeIntervalSinceNow: -300000.0), online: false, hasUnreadMessages: false)])
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
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let conversationViewController = ConversationViewController()
        
        let section = conversationsList[indexPath.section]
        let conversation = section.group[indexPath.row]
        conversationViewController.companionName = conversation.name
        
        navigationController?.pushViewController(conversationViewController, animated: true)
    }
}

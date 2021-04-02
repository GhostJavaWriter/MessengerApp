//
//  ChannelsViewController.swift
//  MessengerApp
//
//  Created by Bair Nadtsalov on 28.02.2021.
//

import UIKit
import Firebase

class ChannelsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, ThemesPickerDelegate {
    
    var themeManager: ThemeManager?
    var themesController: ThemesViewController?
    var coreDataStack: CoreDataStack?
    
// MARK: - Private
    
    private let defaults = UserDefaults.standard
    private var messegesIdentifier: String?
    private let cellIdentifier = String(describing: ChannelTableViewCell.self)
    private lazy var dataBase = Firestore.firestore()
    private lazy var reference = dataBase.collection("channels")
    private var data: [Channel: [Message]] = [:]
    private var channels = [Channel]()
    
    private lazy var tableView: UITableView = {
        
        let tableView = UITableView(frame: CGRect.zero, style: .plain)
        tableView.register(ChannelTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 100
        
        return tableView
    }()

    private func fetchData() {
        
        reference.addSnapshotListener { [weak self] (snap, _) in
            
            guard let documents = snap?.documents else {
                print("No documents")
                return
            }
            
            self?.channels = documents.map { (queryDocumentSnapshot) -> Channel in
                let data = queryDocumentSnapshot.data()
                
                let id = queryDocumentSnapshot.documentID
                let name = data["name"] as? String ?? "default"
                let lastMsg = data["lastMessage"] as? String
                let lastActivityTimestamp = data["lastActivity"] as? Timestamp
                let lastActivity = lastActivityTimestamp?.dateValue()
                let newChannel = Channel(identifier: id, name: name, lastMessage: lastMsg, lastActivity: lastActivity)
                
                return newChannel
            }
            
            if let channels = self?.channels {
                self?.channels = channels.sorted { (current, next) -> Bool in
                    if let current = current.lastActivity {
                        if let next = next.lastActivity {
                            return current > next
                        }
                        return true
                    } else if next.lastActivity != nil {
                        return false
                    }
                    return false
                }
            }
            self?.collectAllData()
            
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
    
    private func collectAllData() {
        
        for channel in channels {
            let id = channel.identifier
            let messageCollection = reference.document(id).collection("messages")
            
            messageCollection.getDocuments(completion: { [weak self] (snap, _) in
                
                guard let docs = snap?.documents else {
                    print("no docs", #function)
                    return
                }
                
                self?.data[channel] = docs.map({ (snap) -> Message in
                    
                    let data = snap.data()
                    let content = data["content"] as? String ?? "error"
                    let timeStamp = data["created"] as? Timestamp ?? Timestamp()
                    let senderId = data["senderId"] as? String ?? "senderId"
                    let senderName = data["senderName"] as? String ?? "senderName"
                    let created = timeStamp.dateValue()
                    let message = Message(content: content, created: created, senderId: senderId, senderName: senderName)
                    
                    return message
                })
            })
        }
    }
    
    private func loadID() {
        if let id = defaults.string(forKey: "identifier") {
            messegesIdentifier = id
        } else {
            let id = UUID().uuidString
            defaults.set(id, forKey: "identifier")
            messegesIdentifier = id
        }
    }
    
    @objc
    private func openProfileViewController() {
        
        if let profileController = UIStoryboard(name: "ProfileViewController",
                                                bundle: nil).instantiateViewController(withIdentifier: "ProfileViewController") as? ProfileViewController {
            present(profileController, animated: true, completion: nil)
        }
    }
    
    @objc
    private func addChannel() {
        let ac = UIAlertController(title: "Add channel", message: "Type channel name", preferredStyle: .alert)
        ac.addTextField()
        
        let createAction = UIAlertAction(title: "Create", style: .default) { [weak self, weak ac] _ in
            guard let channelName = ac?.textFields?[0].text else { return }
            if !channelName.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty {
                self?.submit(channelName)
                if let lastItem = self?.channels.count {
                    let indexPath = IndexPath(item: lastItem - 1, section: 0)
                    self?.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
                }
            } else {
                print("textField is empty")
            }
        }
        ac.addAction(createAction)
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(ac, animated: true, completion: nil)
    }
    
    private func submit(_ answer: String) {
        reference.addDocument(data: ["name": answer])
    }
    
    @objc
    private func openThemesViewController() {
        
        if let themesController = UIStoryboard(name: "ThemesViewController",
                                               bundle: nil).instantiateViewController(withIdentifier: "ThemesViewController") as? ThemesViewController {
            
            themesController.themesPickerDelegate = self
            themesController.currentTheme = themeManager?.currentTheme

            navigationController?.pushViewController(themesController, animated: true)
        }
    }
    
// MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Channels"
        
        let profileBtn = UIBarButtonItem(title: "Profile", style: .plain, target: self, action: #selector(openProfileViewController))
        let addChannelBtn = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addChannel))
        
        navigationItem.setRightBarButtonItems([addChannelBtn, profileBtn], animated: true)
        
        let settingsImage = UIImage(named: "settingsWheel")
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: settingsImage, style: .plain, target: self, action: #selector(openThemesViewController))
        
        loadID()
        
        view.addSubview(tableView)
        tableView.frame = view.safeAreaLayoutGuide.layoutFrame
        
        fetchData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        coreDataStack?.performSave { [weak self] (context) in
            for item in data {
                
                let name = item.key.name
                let id = item.key.identifier
                let lastMsg = item.key.lastMessage
                let lastActivity = item.key.lastActivity
                
                let channel = ChannelDb(name: name, identifier: id, lastMessage: lastMsg, lastActivity: lastActivity, in: context)
                
                let messages = item.value
                
                for message in messages {
                    let content = message.content
                    let created = message.created
                    let senderId = message.senderId
                    let senderName = message.senderName
                    
                    let messageDb = MessageDb(content: content, created: created, senderId: senderId, senderName: senderName, in: context)
                    channel.addToMessages(messageDb)
                }
            }
            self?.coreDataStack?.didUpdateDataBase = { stack in
                stack.printDatabaseStatistics()
            }
        }
    }
    
// MARK: - UITableViewDataSource, UITableViewDelegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return channels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ChannelTableViewCell else { return UITableViewCell() }
        
        let currentChannel = channels[indexPath.row]
        let name = currentChannel.name
        let identifier = currentChannel.identifier
        let lastActivity = currentChannel.lastActivity
        let lastMessage = currentChannel.lastMessage
        cell.configure(name: name,
                       lastMessage: lastMessage,
                       lastActivity: lastActivity,
                       identifier: identifier)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let currentChannel = channels[indexPath.row]
        let conversationViewController = ChatViewController()
        conversationViewController.messagesCollection = reference.document(currentChannel.identifier).collection("messages")
        conversationViewController.channelName = currentChannel.name
        conversationViewController.messageID = messegesIdentifier
        
        navigationController?.pushViewController(conversationViewController, animated: true)
    }
    
// MARK: - ThemesPickerDelegate
    func apply(theme: ThemeOptions) {
        themeManager?.apply(theme: theme)
    }
}

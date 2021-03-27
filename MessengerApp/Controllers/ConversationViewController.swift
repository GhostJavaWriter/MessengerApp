//
//  ChatViewController.swift
//  MessengerApp
//
//  Created by Bair Nadtsalov on 02.03.2021.
//

import UIKit
import Firebase

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var channelName: String?
    var messagesRef: DocumentReference?
    
// MARK: - Private
    
    private let inboxCellIdentifier = String(describing: InboxMessageCell.self)
    private let outboxCellIdentifier = String(describing: OutboxMessageCell.self)
    
    private lazy var tableView: UITableView = {
        
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
    
    private var messages = [Message]()
    
    private func retrieveMessages() {
        let reference = messagesRef?.collection("messages")
        
        reference?.addSnapshotListener { [weak self] (snap, _) in
            
            if let documents = snap?.documentChanges {
                
                for doc in documents {
                    
                    if let content = doc.document.data()["content"] as? String,
                       let timeStamp = doc.document.data()["created"] as? Timestamp,
                       let senderId = doc.document.data()["senderId"] as? String,
                       let senderName = doc.document.data()["senderName"] as? String {
                        
                        let created = timeStamp.dateValue()
                        let message = Message(content: content, created: created, senderId: senderId, senderName: senderName)
                        self?.messages.append(message)
                    } else {
                        NSLog("Message parsing error")
                    }
                }
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            } else {
                NSLog("Database have not any docs")
            }
        }
    }
    
// MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        if let name = channelName {
            title = name
        } else {
            title = "Unknown"
        }
        
        view.addSubview(tableView)
        tableView.frame = view.safeAreaLayoutGuide.layoutFrame
        
        retrieveMessages()
        
    }
    
// MARK: - UITableViewDelegate, UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let messageModel = messages[indexPath.row]
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: inboxCellIdentifier,
                                                       for: indexPath) as? InboxMessageCell else {
            return UITableViewCell()
        }
        
        cell.configure(content: messageModel.content,
                       created: messageModel.created,
                       senderId: messageModel.senderId,
                       senderName: messageModel.senderName)
        
        cell.selectionStyle = .none

        return cell
    }
}

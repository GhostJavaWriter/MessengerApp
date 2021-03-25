//
//  ChatViewController.swift
//  MessengerApp
//
//  Created by Bair Nadtsalov on 02.03.2021.
//

import UIKit
import Firebase

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate {
    
    var channelName: String?
    var messagesCollection: CollectionReference?
    
// MARK: - UI
    
    private lazy var tableView: UITableView = {
        
        let tableView = UITableView(frame: CGRect.zero, style: .plain)
        
        tableView.register(InboxMessageCell.self, forCellReuseIdentifier: inboxCellIdentifier)
        tableView.register(OutboxMessageCell.self, forCellReuseIdentifier: outboxCellIdentifier)
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 80
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()
    
    private lazy var senderBgView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        view.backgroundColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 0.8)
        
        return view
    }()
    
    private lazy var outputMessageView: UITextView = {
        let view = UITextView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 0.8)
        view.delegate = self
        view.layer.cornerRadius = 14
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.white.cgColor
        return view
    }()
    
    private lazy var sendButton: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("send", for: .normal)
        btn.addTarget(self, action: #selector(sendBtnTapped), for: .touchUpInside)
        // btn.isEnabled = false
        return btn
    }()
    
// MARK: - Private
    
    private let inboxCellIdentifier = String(describing: InboxMessageCell.self)
    private let outboxCellIdentifier = String(describing: OutboxMessageCell.self)
    
    private var messages = [Message]()
    
    private func fetchData() {
        guard let ref = messagesCollection else {
            print("no collection")
            return
        }
        
        ref.addSnapshotListener { [weak self] (snap, _) in
            
            guard let documents = snap?.documents else {
                print("no messages")
                return
            }
            
            self?.messages = documents.map { (queryDocumentSnapshot) -> Message in
                let data = queryDocumentSnapshot.data()
                
                let content = data["content"] as? String
                let timeStamp = data["created"] as? Timestamp
                let senderId = data["senderId"] as? String
                let senderName = data["senderName"] as? String
                let created = timeStamp?.dateValue()
                
                return Message(content: content ?? "error",
                               created: created ?? Date(),
                               senderId: senderId ?? "invalid object",
                               senderName: senderName ?? "invalid object")
            }
            if let messages = self?.messages {
                self?.messages = messages.sorted { (current, next) -> Bool in
                    return current.created < next.created
                }
            }
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
    
    @objc
    private func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }

    @objc
    private func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    @objc
    private func sendBtnTapped() {
        
        if let content = outputMessageView.text {
            let created = Date()
            let senderId = ":11"
            let senderName = "Bair"
            
            // let newMessage = Message(content: content, created: created, senderId: senderId, senderName: senderName)
            
            messagesCollection?.addDocument(data: ["content": content, "created": created, "senderId": senderId, "senderName": senderName])
            outputMessageView.text = ""
            outputMessageView.resignFirstResponder()
        }
    }
    
    private func configureView() {
        view.addSubview(tableView)
        view.addSubview(senderBgView)
        senderBgView.addSubview(outputMessageView)
        senderBgView.addSubview(sendButton)
        
        tableView.frame = view.safeAreaLayoutGuide.layoutFrame
        
        senderBgView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        senderBgView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        senderBgView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        senderBgView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        outputMessageView.topAnchor.constraint(equalTo: senderBgView.topAnchor, constant: 10).isActive = true
        outputMessageView.leadingAnchor.constraint(equalTo: senderBgView.leadingAnchor, constant: 30).isActive = true
        outputMessageView.bottomAnchor.constraint(equalTo: senderBgView.bottomAnchor, constant: -20).isActive = true
        
        sendButton.topAnchor.constraint(equalTo: senderBgView.topAnchor, constant: 10).isActive = true
        sendButton.leadingAnchor.constraint(equalTo: outputMessageView.trailingAnchor, constant: 5).isActive = true
        sendButton.trailingAnchor.constraint(equalTo: senderBgView.trailingAnchor, constant: -30).isActive = true
        sendButton.bottomAnchor.constraint(equalTo: senderBgView.bottomAnchor, constant: -20).isActive = true
    }
    
// MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let name = channelName {
            title = name
        } else {
            title = "Unknown"
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        configureView()
        
        fetchData()
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
    
// MARK: - UITextViewDelegate
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        return true
    }
}

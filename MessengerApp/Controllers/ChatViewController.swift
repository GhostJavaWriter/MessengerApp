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
    var messageID: String?
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
    
    private lazy var msgInputConteinerView: AppView = {
        let view = AppView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var senderTextView: UITextView = {
        let view = UITextView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = msgInputConteinerView.backgroundColor
        view.delegate = self
        view.sizeToFit()
        view.isScrollEnabled = false
        view.layer.cornerRadius = 14
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.lightGray.cgColor
        return view
    }()
    
    private lazy var sendButton: AppButton = {
        let btn = AppButton(type: .system)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("send", for: .normal)
        btn.titleLabel?.font = .boldSystemFont(ofSize: 20)
        btn.addTarget(self, action: #selector(sendBtnTapped), for: .touchUpInside)
        btn.isEnabled = false
        return btn
    }()
    
    private var bottomConstraint: NSLayoutConstraint?
    
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
                
                if let currentRow = self?.messages.count {
                    if currentRow > 0 {
                        let indexPath = IndexPath(row: currentRow - 1, section: 0)
                        self?.tableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
                    }
                }
            }
        }
    }
    
    @objc
    private func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            
            bottomConstraint?.constant = 40 - keyboardSize.height
            
            UIView.animate(withDuration: 0, delay: 0, options: .curveEaseOut) { [weak self] in
                self?.view.layoutIfNeeded()
            } completion: { [weak self] (_) in
//                if let lastItem = self?.messages.count {
//                    let indexPath = IndexPath(item: lastItem - 1, section: 0)
//                    self?.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
//                }
                self?.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height + 100, right: 0)
            }
        }
    }

    @objc
    private func keyboardWillHide(notification: NSNotification) {
        
        UIView.animate(withDuration: 0, delay: 0, options: .curveEaseOut) { [weak self] in
            self?.view.layoutIfNeeded()
        } completion: { [weak self] (_) in
            self?.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0)
        }
    }
    
    @objc
    private func sendBtnTapped() {
        
        if let content = senderTextView.text,
           let senderID = self.messageID {
            let created = Date()
            let senderId = senderID
            let senderName = "Bair"
            
            messagesCollection?.addDocument(data: ["content": content, "created": created, "senderId": senderId, "senderName": senderName])
            
            bottomConstraint?.constant = 0
            senderTextView.endEditing(true)
            
            senderTextView.text = nil
            senderTextView.resignFirstResponder()
        }
    }
    
    private func configureView() {
        view.addSubview(tableView)
        view.addSubview(msgInputConteinerView)
        msgInputConteinerView.addSubview(senderTextView)
        msgInputConteinerView.addSubview(sendButton)
        
        tableView.frame = view.safeAreaLayoutGuide.layoutFrame
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0)
        
        msgInputConteinerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        msgInputConteinerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        
        bottomConstraint = msgInputConteinerView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        bottomConstraint?.isActive = true
        
        senderTextView.heightAnchor.constraint(greaterThanOrEqualTo: sendButton.heightAnchor).isActive = true
        senderTextView.topAnchor.constraint(equalTo: msgInputConteinerView.topAnchor, constant: 10).isActive = true
        senderTextView.leadingAnchor.constraint(equalTo: msgInputConteinerView.leadingAnchor, constant: 30).isActive = true
        senderTextView.bottomAnchor.constraint(equalTo: msgInputConteinerView.bottomAnchor, constant: -50).isActive = true
        
        sendButton.leadingAnchor.constraint(equalTo: senderTextView.trailingAnchor, constant: 5).isActive = true
        
        let cons = sendButton.trailingAnchor.constraint(equalTo: msgInputConteinerView.trailingAnchor, constant: -30)
        cons.priority = .defaultHigh
        cons.isActive = true
        sendButton.bottomAnchor.constraint(equalTo: msgInputConteinerView.bottomAnchor, constant: -50).isActive = true
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
        
        if messageModel.senderId == messageID {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: outboxCellIdentifier,
                                                           for: indexPath) as? OutboxMessageCell else {
                
                return UITableViewCell()
            }
            cell.configure(content: messageModel.content,
                           created: messageModel.created,
                           senderId: messageModel.senderId)
            cell.selectionStyle = .none
            return cell
        }
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        bottomConstraint?.constant = 0
        senderTextView.endEditing(true)
    }
    
// MARK: - UITextViewDelegate
    
    func textViewDidChange(_ textView: UITextView) {
        
        let text = textView.text.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        
        if text.isEmpty {
            sendButton.isEnabled = false
        } else {
            sendButton.isEnabled = true
        }
    }
}

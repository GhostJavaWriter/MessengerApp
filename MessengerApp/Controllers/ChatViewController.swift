//
//  ChatViewController.swift
//  MessengerApp
//
//  Created by Bair Nadtsalov on 02.03.2021.
//

import UIKit
import Firebase
import CoreData

class ChatViewController: UIViewController, UITableViewDelegate, UITextViewDelegate, NSFetchedResultsControllerDelegate {
    
    var channel: ChannelDb?
    var messageID: String?
    var messagesCollection: CollectionReference?
    var coreDataStack: CoreDataStack?
    
    // MARK: - UI
    
    private lazy var tableView: UITableView = {
        
        let tableView = UITableView(frame: CGRect.zero, style: .plain)
        
        tableView.register(InboxMessageCell.self, forCellReuseIdentifier: inboxCellIdentifier)
        tableView.register(OutboxMessageCell.self, forCellReuseIdentifier: outboxCellIdentifier)
        
        tableView.dataSource = self.tableViewDataSource
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
    
    private lazy var fetchRequest: NSFetchRequest<MessageDb> = {
        let request: NSFetchRequest<MessageDb> = MessageDb.fetchRequest()
        guard let channel = channel else {
            fatalError("\(#function)")
        }
        request.predicate = NSPredicate(format: "channel == %@", channel)
        return request
    }()
    
    private lazy var tableViewDataSource: UITableViewDataSource = {
        
        guard let context = coreDataStack?.mainContext else {
            fatalError("context error \(#function)")
        }
        
        let request: NSFetchRequest<MessageDb> = fetchRequest
        
        let sortDescriptor = NSSortDescriptor(key: "created", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: request,
                                                                  managedObjectContext: context,
                                                                  sectionNameKeyPath: nil,
                                                                  cacheName: "cachedMessages")
        
        self.fetchedResultsController = fetchedResultsController
        fetchedResultsController.delegate = self
        
        let id = messageID ?? ""
        
        return ChatTableViewDataSource(fetchedResultsController: fetchedResultsController, messageID: id)
    }()
    
    private let inboxCellIdentifier = String(describing: InboxMessageCell.self)
    private let outboxCellIdentifier = String(describing: OutboxMessageCell.self)
    private var fetchedResultsController: NSFetchedResultsController<MessageDb>?
    
    private func listenData() {
        
        guard let ref = messagesCollection else {
            print("no collection")
            return
        }
        
        ref.addSnapshotListener { [weak self] (snap, _) in
            
            guard let self = self else { return }
            
            guard let documents = snap?.documents else {
                print("no messages")
                return
            }
            
            self.coreDataStack?.performSave { (context) in
                do {
                    let objects = try context.fetch(self.fetchRequest)
                    
                    let request: NSFetchRequest<ChannelDb> = ChannelDb.fetchRequest()
                    if let name = self.channel?.name {
                        request.predicate = NSPredicate(format: "name == %@", name)
                    }
                    let channel = try context.fetch(request).first
                    
                    for item in documents {
                        let data = item.data()
                        
                        for object in objects {
                            
                            let content = data["content"] as? String ?? "-"
                            let timeStamp = data["created"] as? Timestamp ?? Timestamp()
                            let senderId = data["senderId"] as? String ?? "-"
                            let senderName = data["senderName"] as? String ?? "-"
                            let created = timeStamp.dateValue()
                            
                            if !((senderId == object.senderId)
                                    && (created == object.created)) {
                                
                                if let newObject = NSEntityDescription.insertNewObject(forEntityName: "MessageDb", into: context) as? MessageDb {
                                    do {
                                        try context.obtainPermanentIDs(for: [newObject])
                                    } catch {
                                        print("cannot obtain permanent id to object")
                                    }
                                    
                                    newObject.content = content
                                    newObject.created = created
                                    newObject.senderId = senderId
                                    newObject.senderName = senderName
                                    channel?.addToMessages(newObject)
                                }
                            } else {
                                print("message already exist")
                            }
                        }
                    }
                } catch {
                    print("fetch messages fail \(#function)")
                }
            }
        }
    }
    
    private func getData() {
        
        guard let ref = messagesCollection else {
            print("no collection")
            return
        }
        
        ref.getDocuments { [weak self] (snap, _) in
            
            guard let self = self else { return }
            
            guard let documents = snap?.documents else {
                print("no messages")
                return
            }
            
            self.coreDataStack?.performSave { (context) in
                
                do {
                    let request: NSFetchRequest<ChannelDb> = ChannelDb.fetchRequest()
                    if let name = self.channel?.name {
                        request.predicate = NSPredicate(format: "name == %@", name)
                    }
                    let object = try context.fetch(request).first
                    
                    for item in documents {
                        let data = item.data()
                        
                        let content = data["content"] as? String ?? "-"
                        let timeStamp = data["created"] as? Timestamp ?? Timestamp()
                        let senderId = data["senderId"] as? String ?? "-"
                        let senderName = data["senderName"] as? String ?? "-"
                        let created = timeStamp.dateValue()
                        
                        if let newObject = NSEntityDescription.insertNewObject(forEntityName: "MessageDb", into: context) as? MessageDb {
                            do {
                                try context.obtainPermanentIDs(for: [newObject])
                            } catch {
                                print("cannot obtain permanent id to object")
                            }
                            
                            newObject.content = content
                            newObject.created = created
                            newObject.senderId = senderId
                            newObject.senderName = senderName
                            
                            object?.addToMessages(newObject)
                        } else {
                            print("creating object fail \(#function)")
                        }
                    }
                } catch {
                    print("fetch fail \(#function)")
                }
            }
        }
    }
            
//            DispatchQueue.main.async {
//
//                if let currentRow = self?.messages.count {
//                    if currentRow > 0 {
//                        let indexPath = IndexPath(row: currentRow - 1, section: 0)
//                        self?.tableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
//                    }
//                }
//            }

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
            
            messagesCollection?.addDocument(data: ["content": content,
                                                   "created": created,
                                                   "senderId": senderId,
                                                   "senderName": senderName])
            
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
        
        if let name = channel?.name {
            title = name
        } else {
            title = "Unknown"
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        configureView()
        
        if let count = try? coreDataStack?.mainContext.count(for: fetchRequest) {
            if count < 1 {
                getData()
                listenData()
            } else {
                listenData()
            }
        }
    }
    
    // MARK: - UITableViewDelegate
    
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
    
    // MARK: - NSFetchedResultsControllerDelegate
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        
        switch type {
        case .insert:
            guard let newIndexPath = newIndexPath else { return }
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        case .move:
            guard let indexPath = indexPath,
                  let newIndexPath = newIndexPath else { return }
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        case .update:
            guard let indexPath = indexPath else { return }
            tableView.reloadRows(at: [indexPath], with: .automatic)
        case .delete:
            guard let indexPath = indexPath else { return }
            tableView.deleteRows(at: [indexPath], with: .automatic)
        default:
            return
        }
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.endUpdates()
    }
}

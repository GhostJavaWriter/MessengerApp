//
//  ChannelsViewController.swift
//  MessengerApp
//
//  Created by Bair Nadtsalov on 28.02.2021.
//

import UIKit
import Firebase
import CoreData

class ChannelsViewController: UIViewController, UITableViewDelegate, ThemesPickerDelegate, NSFetchedResultsControllerDelegate {
    
    var themeManager: ThemeManager?
    var themesController: ThemesViewController?
    var coreDataStack: CoreDataStack?
    
// MARK: - Private
    
    private let defaults = UserDefaults.standard
    private let cellIdentifier = String(describing: ChannelTableViewCell.self)
    
    private var messegesIdentifier: String?
    private var fetchedResultsController: NSFetchedResultsController<ChannelDb>?
    private var channelsIDs: [String: NSManagedObjectID] = [:]
    
    private lazy var dataBase = Firestore.firestore()
    private lazy var reference = dataBase.collection("channels")
    
    private lazy var fetchRequest: NSFetchRequest<ChannelDb> = {
        let request: NSFetchRequest<ChannelDb> = ChannelDb.fetchRequest()
        
        return request
    }()
    
    private lazy var tableView: UITableView = {
        
        let tableView = UITableView(frame: CGRect.zero, style: .plain)
        tableView.register(ChannelTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        
        tableView.dataSource = self.tableViewDataSource
        tableView.delegate = self
        tableView.rowHeight = 100
        
        return tableView
    }()
    
    private lazy var tableViewDataSource: UITableViewDataSource = {
        guard let context = coreDataStack?.mainContext else { fatalError("No context \(#function)")}
        
        let request: NSFetchRequest<ChannelDb> = ChannelDb.fetchRequest()
        
        let sortDescriptor = NSSortDescriptor(key: "lastActivity", ascending: false)
        request.sortDescriptors = [sortDescriptor]
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: request,
                                                                  managedObjectContext: context,
                                                                  sectionNameKeyPath: nil,
                                                                  cacheName: "cachedChannels")
        
        self.fetchedResultsController = fetchedResultsController
        fetchedResultsController.delegate = self
        
        return ChannelsTableViewDataSource(fetchedResultsController: fetchedResultsController)
    }()

    private func fetchMessages(from channel: ChannelDb, collection: CollectionReference, context: NSManagedObjectContext) {
        
        collection.getDocuments { snap, _ in
            
            guard let docs = snap?.documents else {
                print("no docs", #function)
                return
            }
            
            for doc in docs {
                let content = doc["content"] as? String ?? "error"
                let timeStamp = doc["created"] as? Timestamp ?? Timestamp()
                let senderId = doc["senderId"] as? String ?? "senderId"
                let senderName = doc["senderName"] as? String ?? "senderName"
                let created = timeStamp.dateValue()
                
                if let message = NSEntityDescription.insertNewObject(forEntityName: "MessageDb",
                                                                     into: context) as? MessageDb {
                    do {
                        try context.obtainPermanentIDs(for: [message])
                    } catch {
                        NSLog("obtain permanent IDs fail")
                    }
                    
                    message.content = content
                    message.senderId = senderId
                    message.created = created
                    message.senderName = senderName
                    message.channel = channel
                }
            }
        }
    }
    
    private func listenData() {
        
        reference.addSnapshotListener { [weak self] (snap, _) in
            
            guard let self = self else { return }
            guard let documents = snap?.documents else {
                print("No documents")
                return
            }
            
            self.coreDataStack?.performSave { (context) in
                
                do {
                    let objects = try context.fetch(self.fetchRequest)
                    
                    for item in documents {
                        let data = item.data()
                        
                        for object in objects {
                            
                            let id = item.documentID
                            let name = data["name"] as? String ?? "default"
                            let lastMsg = data["lastMessage"] as? String
                            let lastActivityTimestamp = data["lastActivity"] as? Timestamp
                            let lastActivity = lastActivityTimestamp?.dateValue()
                            
                            if !(id == object.identifier) {
                                if let newObject = NSEntityDescription.insertNewObject(forEntityName: "ChannelDb", into: context) as? ChannelDb {
                                    do {
                                        try context.obtainPermanentIDs(for: [newObject])
                                    } catch {
                                        print("cannot obtain permanent id to object")
                                    }
                                    
                                    newObject.name = name
                                    newObject.identifier = id
                                    newObject.lastMessage = lastMsg
                                    newObject.lastActivity = lastActivity
                                }
                            } else {
                                object.lastActivity = lastActivity
                                object.lastMessage = lastMsg
                                object.name = name
                            }
                        }
                    }
                } catch {
                    print("fetch fail")
                }
            }
        }
    }
    
    private func getData() {

        reference.getDocuments { [weak self] (snap, _) in

            guard let self = self else { return }
            guard let documents = snap?.documents else {
                print("No documents")
                return
            }

            self.coreDataStack?.performSave { (context) in

                for item in documents {
                    let data = item.data()

                    let id = item.documentID
                    let name = data["name"] as? String ?? "default"
                    let lastMsg = data["lastMessage"] as? String
                    let lastActivityTimestamp = data["lastActivity"] as? Timestamp
                    let lastActivity = lastActivityTimestamp?.dateValue()
                    
                    if let newObject = NSEntityDescription.insertNewObject(forEntityName: "ChannelDb", into: context) as? ChannelDb {
                        do {
                            try context.obtainPermanentIDs(for: [newObject])
                        } catch {
                            print("cannot obtain permanent id to object")
                        }
                        
                        newObject.name = name
                        newObject.identifier = id
                        newObject.lastMessage = lastMsg
                        newObject.lastActivity = lastActivity
                    }
                }
            }
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
                if let lastItem = self?.fetchedResultsController?.fetchedObjects?.count {
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
        
        tableView.deselectRow(at: indexPath, animated: true)

        if let currentChannel = self.fetchedResultsController?.object(at: indexPath) {
            let conversationViewController = ChatViewController()
            conversationViewController.messagesCollection = reference.document(currentChannel.identifier ?? "dd").collection("messages")
            conversationViewController.channel = currentChannel
            conversationViewController.messageID = messegesIdentifier
            conversationViewController.coreDataStack = coreDataStack

            navigationController?.pushViewController(conversationViewController, animated: true)
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
    
    // MARK: - ThemesPickerDelegate
    func apply(theme: ThemeOptions) {
        themeManager?.apply(theme: theme)
    }
}

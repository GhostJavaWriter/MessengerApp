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
    
// MARK: - Private
    
    private let cellIdentifier = String(describing: ChannelTableViewCell.self)
    private lazy var dataBase = Firestore.firestore()
    private lazy var reference = dataBase.collection("channels")
    
    private lazy var tableView: UITableView = {
        
        let tableView = UITableView(frame: CGRect.zero, style: .plain)
        tableView.register(ChannelTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 100
        
        return tableView
    }()
    private var channels = [Channel]()

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
                
                return Channel(identifier: id, name: name, lastMessage: lastMsg, lastActivity: lastActivity)
            }
            // страшная логика сортировки О_О
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
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
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
            if !channelName.isEmpty {
                self?.submit(channelName)
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
        
        view.addSubview(tableView)
        tableView.frame = view.safeAreaLayoutGuide.layoutFrame
        
        fetchData()
        
    }
    
// MARK: - UITableViewDataSource, UITableViewDelegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return channels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ChannelTableViewCell else { return UITableViewCell() }
        
        let currentChannel = channels[indexPath.row]
        let name = currentChannel.name
        let lastMessage = currentChannel.lastMessage
        let lastActivity = currentChannel.lastActivity
        let identifier = currentChannel.identifier
        
        cell.configure(name: name, lastMessage: lastMessage, lastActivity: lastActivity, identifier: identifier)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let currentChannel = channels[indexPath.row]
        let conversationViewController = ChatViewController()
        conversationViewController.messagesCollection = reference.document(currentChannel.identifier).collection("messages")
        conversationViewController.channelName = currentChannel.name
        
        navigationController?.pushViewController(conversationViewController, animated: true)
    }
    
// MARK: - ThemesPickerDelegate
    func apply(theme: ThemeOptions) {
        themeManager?.apply(theme: theme)
    }
}

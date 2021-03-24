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

    private func retrieveData() {
        
        reference.addSnapshotListener { [weak self] (snap, _) in
            
            if let documents = snap?.documentChanges {
                
                for doc in documents {
                    
                    if let name = doc.document.data()["name"] as? String {
                        
                        let identifier = doc.document.documentID
                        let lastMessage = doc.document.data()["lastMessage"] as? String
                        let lastActivityTimestamp = doc.document.data()["lastActivity"] as? Timestamp
                        let lastActivity = lastActivityTimestamp?.dateValue()
                        let channel = Channel(identifier: identifier,
                                              name: name,
                                              lastMessage: lastMessage,
                                              lastActivity: lastActivity)
                        self?.channels.append(channel)
                    } else {
                        NSLog("Cannot cast channel name to String")
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
        
        retrieveData()
        
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

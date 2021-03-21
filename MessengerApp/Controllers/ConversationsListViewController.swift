//
//  ConversationsListViewController.swift
//  MessengerApp
//
//  Created by Bair Nadtsalov on 28.02.2021.
//

import UIKit

struct TableViewItems {
    var title : String
    var group : [ConversationModel]
}

class ConversationsListViewController : UIViewController, UITableViewDataSource, UITableViewDelegate, ThemesPickerDelegate {
    
    var themeManager : ThemeManager?
    var themesController : ThemesViewController?
    
    //MARK: - Private
    
    private let cellIdentifier = String(describing: ConversationsListTableViewCell.self)
    
    private lazy var tableView : UITableView = {
        
        let tableView = UITableView(frame: CGRect.zero, style: .plain)
        tableView.register(ConversationsListTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 100
        
        return tableView
    }()
    private var conversationsList = [TableViewItems]()

    @objc
    private func openProfileViewController() {
        
        if let profileController = UIStoryboard(name: "ProfileViewController", bundle: nil).instantiateViewController(withIdentifier: "ProfileViewController") as? ProfileViewController {
            
            present(profileController, animated: true, completion: nil)
        }
    }
    
    @objc
    private func openThemesViewController() {
        
        if let themesController = UIStoryboard(name: "ThemesViewController", bundle: nil).instantiateViewController(withIdentifier: "ThemesViewController") as? ThemesViewController {
            
            themesController.themesPickerDelegate = self
            themesController.currentTheme = themeManager?.currentTheme

            navigationController?.pushViewController(themesController, animated: true)
        }
    }
    
    private func randomString(length: Int) -> String {
      let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
      return String((0..<length).map{ _ in letters.randomElement()! })
    }
    
    private func fillData() {
        //EXAMPLE INPUT DATA: here we will "load" item from somewhere
        
        conversationsList.append(TableViewItems(title: "Online", group: [ConversationModel]()))
        conversationsList.append(TableViewItems(title: "History", group: [ConversationModel]()))
        
        var inputConversations = [ConversationModel]()
        
        for _ in 1...20 {
            
            let randomLength = Int.random(in: 3...100)
            let randomInterval = -Int.random(in: 1000...300000)
            
            let name = "\(randomString(length: randomLength)) \(randomString(length: randomLength))"
            let message = "\(randomString(length: randomLength))"
            let date = Date(timeIntervalSinceNow: Double(randomInterval))
            let online = Bool.random()
            let hasUnreadMessages = Bool.random()
            
            inputConversations.append(ConversationModel(name: name,
                                                        message: message,
                                                        date: date,
                                                        online: online,
                                                        hasUnreadMessages: hasUnreadMessages))
        }
        
        //here we are sorting an input conversations to different sections in conversations list
        //later we can add rules what we need
        for item in inputConversations {
            if item.online {
                conversationsList[0].group.append(item)
            } else if item.message != nil {
                conversationsList[1].group.append(item)
            } else {
                NSLog("\(item) : invalid object. because it's has no message and isn't online")
            }
        }
    }
    
    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Tinkoff Chat"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Profile", style: .plain, target: self, action: #selector(openProfileViewController))
        let settingsImage = UIImage(named: "settingsWheel")
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: settingsImage, style: .plain, target: self, action: #selector(openThemesViewController))
        
        view.addSubview(tableView)
        tableView.frame = view.safeAreaLayoutGuide.layoutFrame
        
        fillData()
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
        let chat = section.group[indexPath.row]
        
        cell.configure(name: chat.name,
                       message: chat.message,
                       date: chat.date,
                       online: chat.online,
                       hasUnreadMessages: chat.hasUnreadMessages)
        
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
    
    //MARK: - ThemesPickerDelegate
    func apply(theme: ThemeOptions) {
        themeManager?.apply(theme: theme)
        
    }
}

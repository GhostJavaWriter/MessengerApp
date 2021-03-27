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
    
    private let cellIdentifier = String(describing: ConversationsListTableViewCell.self)
    
    private lazy var tableView: UITableView = {
        
        let tableView = UITableView(frame: CGRect.zero, style: .plain)
        tableView.register(ConversationsListTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 100
        
        return tableView
    }()
    private var channels = [Channel]()

    @objc
    private func openProfileViewController() {
        
        if let profileController = UIStoryboard(name: "ProfileViewController",
                                                bundle: nil).instantiateViewController(withIdentifier: "ProfileViewController") as? ProfileViewController {
            
            present(profileController, animated: true, completion: nil)
        }
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
    
    private func randomString(length: Int) -> String {
      let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
      return String((0..<length).map { _ in letters.randomElement()! })
    }
    
// MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Tinkoff Chat"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Profile", style: .plain, target: self, action: #selector(openProfileViewController))
        let settingsImage = UIImage(named: "settingsWheel")
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: settingsImage, style: .plain, target: self, action: #selector(openThemesViewController))
        
        view.addSubview(tableView)
        tableView.frame = view.safeAreaLayoutGuide.layoutFrame
        
        let channels = Firestore.firestore().collection("channels")
        channels.getDocuments { (snap, _) in
            
            for d in snap!.documents {
                print((d.data()["name"] as? String) ?? "default")
            }
        }
    }
    
// MARK: - UITableViewDataSource, UITableViewDelegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return channels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ConversationsListTableViewCell else { return UITableViewCell() }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let conversationViewController = ConversationViewController()
        
        navigationController?.pushViewController(conversationViewController, animated: true)
    }
    
// MARK: - ThemesPickerDelegate
    func apply(theme: ThemeOptions) {
        
        themeManager?.apply(theme: theme)
        
    }
}

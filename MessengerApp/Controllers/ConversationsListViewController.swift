//
//  ConversationsListViewController.swift
//  MessengerApp
//
//  Created by Bair Nadtsalov on 28.02.2021.
//

import UIKit

class ConversationsListViewController : UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    //MARK: - Private
    private let cellIdentifier = String(describing: ConversationTableViewCell.self)
    
    private lazy var tableView : UITableView = {
        
        let tableView = UITableView(frame: CGRect.zero, style: .plain)
        tableView.register(ConversationTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        return tableView
    }()
    
    private var conversations : [ConversationModel]?
    
    //MARK: - UI
    
    private func configureTableView() {
        
        view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
    }
    
    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        
        title = "Tinkoff Chat"
        view.backgroundColor = .white
        
        configureTableView()

    }
    
    //MARK: - UITableViewDataSource, UITableViewDelegate
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ConversationTableViewCell else { return UITableViewCell() }
        
        let conversation = ConversationModel(name: "Ronald Robertson", message: "An suas viderer pro. Vis cu magna altera, ex his vivendo atomorum.", date: nil, online: true, hasUnreadMessages: true)
        
        cell.configure(with: conversation)
        
        return cell
    }
}

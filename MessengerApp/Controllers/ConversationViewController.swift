//
//  ConversationViewController.swift
//  MessengerApp
//
//  Created by Bair Nadtsalov on 02.03.2021.
//

import UIKit

class ConversationViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var companionName : String?
    
    //MARK: - Private
    
    private let cellIdentifier = String(describing: MessageTableViewCell.self)
    
    private lazy var tableView : UITableView = {
        
        let tableView = UITableView(frame: CGRect.zero, style: .plain)
        tableView.register(MessageTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        return tableView
    }()
    
    private func configureTableView() {
        
        view.addSubview(tableView)
        tableView.pinToSafeAreaEdges()
        
        //tableView.separatorStyle = .none
        
        
    }
    
    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        
        view.backgroundColor = .white
        
        title = companionName
    
        configureTableView()
    }
    
    //MARK: - UITableViewDelegate, UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? MessageTableViewCell else { return UITableViewCell()}
        
        cell.messageLabel.text = "some text"
        cell.needsUpdateConstraints()
        
        return cell
    }
    
    
}

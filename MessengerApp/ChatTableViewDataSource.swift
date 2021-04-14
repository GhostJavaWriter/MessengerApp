//
//  ChatTableViewDataSource.swift
//  MessengerApp
//
//  Created by Bair Nadtsalov on 08.04.2021.
//

import UIKit
import CoreData

class ChatTableViewDataSource: NSObject, UITableViewDataSource {
    
    let fetchedResultsController: NSFetchedResultsController<MessageDb>
    let messageID: String
    
    private let inboxCellIdentifier = String(describing: InboxMessageCell.self)
    private let outboxCellIdentifier = String(describing: OutboxMessageCell.self)
    
    init(fetchedResultsController: NSFetchedResultsController<MessageDb>, messageID: String) {
        self.fetchedResultsController = fetchedResultsController
        self.messageID = messageID
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("performFetch fail \(#function)")
        }
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = self.fetchedResultsController.sections else {
            fatalError("No sections in fetchedResultsController")
        }
        let sectionInfo = sections[section]
        return sectionInfo.numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let messageModel = fetchedResultsController.object(at: indexPath)
        
        if messageModel.senderId == messageID {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: outboxCellIdentifier,
                                                           for: indexPath) as? OutboxMessageCell,
                  let content = messageModel.content,
                  let created = messageModel.created,
                  let senderId = messageModel.senderId else {
                
                return UITableViewCell()
            }
            cell.configure(content: content,
                           created: created,
                           senderId: senderId)
            cell.selectionStyle = .none
            return cell
        }
        guard let cell = tableView.dequeueReusableCell(withIdentifier: inboxCellIdentifier,
                                                       for: indexPath) as? InboxMessageCell,
              let content = messageModel.content,
              let created = messageModel.created,
              let senderId = messageModel.senderId,
              let senderName = messageModel.senderName else {
            
            return UITableViewCell()
        }
        cell.configure(content: content,
                       created: created,
                       senderId: senderId,
                       senderName: senderName)
        cell.selectionStyle = .none
        return cell
    }
}

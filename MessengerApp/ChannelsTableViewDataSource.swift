//
//  ChannelsTableViewDataSource.swift
//  MessengerApp
//
//  Created by Bair Nadtsalov on 04.04.2021.
//

import UIKit
import CoreData

class ChannelsTableViewDataSource: NSObject, UITableViewDataSource {
    
    let fetchedResultsController: NSFetchedResultsController<ChannelDb>
    
    private let cellIdentifier = String(describing: ChannelTableViewCell.self)
    
    init(fetchedResultsController: NSFetchedResultsController<ChannelDb>) {
        self.fetchedResultsController = fetchedResultsController
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("performFetch fail \(#function)")
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = self.fetchedResultsController.sections else {
            fatalError("No sections in fetchedResultsController")
        }
        let sectionInfo = sections[section]
        return sectionInfo.numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ChannelTableViewCell else { return UITableViewCell() }
        
        let currentChannel = self.fetchedResultsController.object(at: indexPath)
        let name = currentChannel.name
        let identifier = currentChannel.identifier
        let lastActivity = currentChannel.lastActivity
        let lastMessage = currentChannel.lastMessage
        cell.configure(name: name,
                       lastMessage: lastMessage,
                       lastActivity: lastActivity,
                       identifier: identifier)
        return cell
    }
}

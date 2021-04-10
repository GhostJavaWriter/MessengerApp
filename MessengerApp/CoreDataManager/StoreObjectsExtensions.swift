//
//  StoreObjectsExtensions.swift
//  MessengerApp
//
//  Created by Bair Nadtsalov on 28.03.2021.
//

import Foundation
import CoreData

extension ChannelDb {
    convenience init(name: String,
                     identifier: String,
                     lastMessage: String?,
                     lastActivity: Date?,
                     in context: NSManagedObjectContext) {
        self.init(context: context)
        self.name = name
        self.identifier = identifier
        self.lastMessage = lastMessage
        self.lastActivity = lastActivity
    }
    var about: String {
        let description = "\(String(describing: name)) messages: \(String(describing: messages?.count))\n"
        let messages = self.messages?.allObjects
            .compactMap { $0 as? MessageDb }
            .map { "\t\t\t\($0.about)" }
            .joined(separator: "\n") ?? ""
        return description + messages
    }
}

extension MessageDb {
    convenience init(content: String,
                     created: Date,
                     senderId: String,
                     senderName: String,
                     messageId: Int64,
                     in context: NSManagedObjectContext) {
        self.init(context: context)
        self.content = content
        self.created = created
        self.senderId = senderId
        self.senderName = senderName
        self.messageId = messageId
    }
    
    var about: String {
        return "message: \(String(describing: content))"
    }
}

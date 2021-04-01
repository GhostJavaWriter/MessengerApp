//
//  MessageDb+CoreDataProperties.swift
//  
//
//  Created by Bair Nadtsalov on 01.04.2021.
//
//

import Foundation
import CoreData

extension MessageDb {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MessageDb> {
        return NSFetchRequest<MessageDb>(entityName: "MessageDb")
    }

    @NSManaged public var content: String?
    @NSManaged public var created: Date?
    @NSManaged public var senderId: String?
    @NSManaged public var senderName: String?
    @NSManaged public var channel: ChannelDb?

}

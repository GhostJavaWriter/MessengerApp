//
//  ConversationProtocol.swift
//  MessengerApp
//
//  Created by Bair Nadtsalov on 02.03.2021.
//

import Foundation

protocol ConversationCellConfiguration {
    
    var name : String? {get set}
    var message : String? {get set}
    var date : Date? {get set}
    var online : Bool {get set}
    var hasUnreadMessages : Bool {get set}
}

//
//  DataManagerGCD.swift
//  MessengerApp
//
//  Created by Bair Nadtsalov on 14.03.2021.
//

import Foundation
import UIKit

class DataManagerGCD {
    
    private let queue = DispatchQueue.global(qos: .utility)
    
    func loadData(fileName: String, completion: @escaping (Result<Data, Error>) -> Void) {
        queue.async {
            readFromFile(fileName: fileName) { result in
                DispatchQueue.main.async {
                    completion(result)
                }
            }
        }
    }
    func saveData(name: String, completion: @escaping (Result<String, Error>) -> Void) {
        queue.async {
            saveToFile(nameField: name) { result in
                DispatchQueue.main.async {
                    completion(result)
                }
            }
        }
    }
}

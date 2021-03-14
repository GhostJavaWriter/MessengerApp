//
//  DataManager.swift
//  MessengerApp
//
//  Created by Bair Nadtsalov on 14.03.2021.
//

import Foundation
import UIKit

public enum DataOperationError: Error {
    case badOperationFinnished
    case readingError
    case badRotation
    case writingError
}

public func saveToFile(nameField: String, completion: @escaping (Result<String, Error>) -> Void) {
    let jsonString = "{\"nameField\": \"\(nameField)\"}"
    
    if let path = getDocumentsDirectory() {
        let pathWithFilename = path.appendingPathComponent("userData.json")
        do {
            try jsonString.write(to: pathWithFilename,
                                 atomically: true,
                                 encoding: .utf8)
            sleep(1)
            completion(.success(jsonString))
        } catch {
            print("save data to file error", error)
            completion(.failure(DataOperationError.writingError))
        }
    }
}

public func readFromFile(fileName: String, completion: @escaping (Result<Data, Error>) -> Void) {
    do {
        
        if let path = getDocumentsDirectory() {
            let pathWithFileName = path.appendingPathComponent(fileName)
            let jsonData = try Data(contentsOf: pathWithFileName)
            sleep(1)
            completion(.success(jsonData))
        }
        
    } catch {
        print(error)
        completion(.failure(DataOperationError.readingError))
    }
}

public func parse(jsonData: Data) -> String? {
    do {
        let decodedData = try JSONDecoder().decode(UserDataModel.self,
                                                   from: jsonData)
        return decodedData.nameField
    } catch {
        print("decode error")
        return nil
    }
}

public func getDocumentsDirectory() -> URL? {
    
    let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
    return path
}

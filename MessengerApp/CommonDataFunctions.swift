//
//  DataManager.swift
//  MessengerApp
//
//  Created by Bair Nadtsalov on 14.03.2021.
//

import Foundation
import UIKit
import Firebase

public enum DataOperationError: Error {
    case readingError
    case writingError
    case imageToDataError
    case gettingPathError
    case dataCreateError
}

public func syncSaveImg(fileName: String, image: UIImage, completion: @escaping (Result<UIImage, Error>) -> Void) {
    if let path = getDocumentsDirectory() {
        let pathWithFilename = path.appendingPathComponent(fileName)
        
        if let imageData = image.jpegData(compressionQuality: 1.0) {
            sleep(3)
            do {
                try imageData.write(to: pathWithFilename)
                completion(.success(image))
            } catch {
                completion(.failure(DataOperationError.writingError))
            }
        } else {
            completion(.failure(DataOperationError.imageToDataError))
        }
    } else {
        completion(.failure(DataOperationError.gettingPathError))
    }
}
public func syncSaveData(toFile: String, name: String, workInfo: String, location: String, completion: @escaping (Result<Data, Error>) -> Void) {
    
    let jsonString = """
{
\"name\": \"\(name)",
\"workInfo\": \"\(workInfo)",
\"location\": \"\(location)"
}
"""
    if let path = getDocumentsDirectory() {
        let pathWithFilename = path.appendingPathComponent(toFile)
        do {
            if let data = jsonString.data(using: .utf8) {
                sleep(3)
                try data.write(to: pathWithFilename)
                completion(.success(data))
            } else {
                completion(.failure(DataOperationError.dataCreateError))
            }
        } catch {
            completion(.failure(DataOperationError.writingError))
        }
    }
}

public func syncLoadImg(imageString: String, completion: @escaping (Result<UIImage, Error>) -> Void) {

    if let path = getDocumentsDirectory() {
        let pathWithFileName = path.appendingPathComponent(imageString)
        if let data = try? Data(contentsOf: pathWithFileName),
           let image = UIImage(data: data) {
            
            completion(.success(image))
        } else {
            completion(.failure(DataOperationError.readingError))
        }
    }
}

public func syncReadData(fileName: String, completion: @escaping (Result<Data, Error>) -> Void) {
    do {
        
        if let path = getDocumentsDirectory() {
            let pathWithFileName = path.appendingPathComponent(fileName)
            let jsonData = try Data(contentsOf: pathWithFileName)
            completion(.success(jsonData))
        }
        
    } catch {
        print(error)
        completion(.failure(DataOperationError.readingError))
    }
}

public func syncSaveTheme(fileName: String, theme: Any, completion: @escaping (Result<Bool, Error>) -> Void) {
    
    guard let theme = theme as? ThemeOptions else { return }
    
    let jsonString = "{\"theme\": \"\(theme.rawValue)\"}"
    
    if let path = getDocumentsDirectory() {
        let pathWithFileName = path.appendingPathComponent(fileName)
        do {
            if let data = jsonString.data(using: .utf8) {
                try data.write(to: pathWithFileName)
                completion(.success(true))
            } else {
                completion(.failure(DataOperationError.dataCreateError))
            }
        } catch {
            completion(.failure(DataOperationError.writingError))
        }
    }
}

public func parseUserInfoModel(jsonData: Data, completion: @escaping (Result <[String: String], Error>) -> Void) {
    do {
        let decodedData = try JSONDecoder().decode(UserDataModel.self,
                                                   from: jsonData)
        let dictrionary = ["name": decodedData.name,
                           "workInfo": decodedData.workInfo,
                           "location": decodedData.location]
        
        completion(.success(dictrionary))
    } catch {
        completion(.failure(error))
    }
}

public func parseSavedThemeModel(jsonData: Data, completion: @escaping (Result <[String: String], Error>) -> Void) {
    do {
        let decodedData = try JSONDecoder().decode(SavedThemeModel.self,
                                                   from: jsonData)
        let dictrionary = ["theme": decodedData.theme]
        
        completion(.success(dictrionary))
    } catch {
        
        completion(.failure(error))
    }
}

public func getDocumentsDirectory() -> URL? {
    
    let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
    return path
}

/*
public func syncRetrieveChannels(from dataBase: CollectionReference,
                                 completion: @escaping (Result <[String: Any], Error>) -> Void) {
    
}
 */

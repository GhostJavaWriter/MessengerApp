//
//  DataManager.swift
//  MessengerApp
//
//  Created by Bair Nadtsalov on 14.03.2021.
//

import Foundation
import UIKit

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
                try data.write(to: pathWithFilename)
                sleep(1)
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
            sleep(1)
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
            sleep(1)
            completion(.success(jsonData))
        }
        
    } catch {
        print(error)
        completion(.failure(DataOperationError.readingError))
    }
}

public func parse(jsonData: Data, completion: @escaping (Result<Dictionary<String, String>, Error>) -> Void) {
    do {
        let decodedData = try JSONDecoder().decode(UserDataModel.self,
                                                   from: jsonData)
        let dictrionary = ["name" : decodedData.name,
                           "workInfo" : decodedData.workInfo,
                           "location" : decodedData.location]
        
        completion(.success(dictrionary))
    } catch {
        print("decode error", error)
        completion(.failure(error))
    }
}

public func getDocumentsDirectory() -> URL? {
    
    let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
    return path
}

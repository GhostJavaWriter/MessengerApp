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
            syncReadData(fileName: fileName) { result in
                DispatchQueue.main.async {
                    completion(result)
                }
            }
        }
    }
    func saveData(toFile: String, name: String, workInfo: String, location: String, completion: @escaping (Result<Data, Error>) -> Void) {
        queue.async {
            syncSaveData(toFile: toFile, name: name, workInfo: workInfo, location: location) { result in
                DispatchQueue.main.async {
                    completion(result)
                }
            }
        }
    }
    
    func loadImage(imageString: String, completion: @escaping (Result<UIImage, Error>) -> Void) {
        queue.async {
            syncLoadImg(imageString: imageString) { result in
                DispatchQueue.main.async {
                    completion(result)
                }
            }
        }
    }
    
    func saveImage(imageString: String, image: UIImage, completion: @escaping (Result<UIImage, Error>) -> Void) {
        queue.async {
            syncSaveImg(fileName: imageString, image: image) { (result) in
                switch result {
                case .success(let result):
                    completion(.success(result))
                case .failure(let err):
                    completion(.failure(err))
                }
            }
        }
    }
    
    
}

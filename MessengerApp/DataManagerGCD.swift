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
                completion(result)
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
                completion(result)
            }
        }
    }
    
    // MARK: Save/Load Theme
    
    func saveCurrentTheme(theme: ThemeOptions, fileName: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        queue.async {
            syncSaveTheme(fileName: fileName, theme: theme) { (result) in
                completion(result)
            }
        }
    }
    
    func loadTheme(fileName: String, completion: @escaping (Result<Data, Error>) -> Void) {
        queue.async {
            syncReadData(fileName: fileName) { (result) in
                DispatchQueue.main.async {
                    completion(result)
                }
            }
        }
    }
}

//
//  DataManagerOperations.swift
//  MessengerApp
//
//  Created by Bair Nadtsalov on 14.03.2021.
//

import Foundation
import UIKit

// MARK: DataManagerOperations

class DataManagerOperations {
    private let queue = OperationQueue()

    func loadImage(fileWithImage: String, completion: @escaping (Result<UIImage, Error>) -> Void) {
        
        let imageLoadOperation = ImageLoadOperation(imageString: fileWithImage)
        
        imageLoadOperation.completionBlock = {
            
            OperationQueue.main.addOperation {
                if let result = imageLoadOperation.result {
                    completion(result)
                } else {
                    completion(.failure(DataOperationError.readingError))
                }
            }
        }
        
        queue.addOperations([imageLoadOperation], waitUntilFinished: false)
    }
    
    func loadData(fileWithData: String, completion: @escaping (Result<Data, Error>) -> Void) {
        let dataLoadOperation = DataLoadOperation(fileName: fileWithData)
        
        dataLoadOperation.completionBlock = {
            OperationQueue.main.addOperation {
                if let result = dataLoadOperation.result {
                    completion(result)
                } else {
                    completion(.failure(DataOperationError.readingError))
                }
            }
        }
        
        queue.addOperations([dataLoadOperation], waitUntilFinished: false)
    }
    
    func saveImage(toFile: String, image: UIImage, completion: @escaping (Result<UIImage, Error>) -> Void) {
        let imageSaveOperation = SaveImageOperation(imageString: toFile, image: image)
        
        imageSaveOperation.completionBlock = {
            OperationQueue.main.addOperation {
                if let result = imageSaveOperation.result {
                    completion(result)
                } else {
                    completion(.failure(DataOperationError.writingError))
                }
            }
        }
        
        queue.addOperation(imageSaveOperation)
    }
    
    func saveData(toFile: String, userInfo: UserDataModel, completion: @escaping (Result<Data, Error>) -> Void) {
        let dataSaveOperation = SaveDataOperation(fileName: toFile, userInfo: userInfo)
        
        dataSaveOperation.completionBlock = {
            OperationQueue.main.addOperation {
                if let result = dataSaveOperation.result {
                    completion(result)
                } else {
                    completion(.failure(DataOperationError.writingError))
                }
            }
        }
        queue.addOperation(dataSaveOperation)
    }
}

// MARK: AsyncOperation

class AsyncOperation: Operation {
    
    enum State: String {
        case ready, executing, finished, cancelled
        
        fileprivate var keyPath: String {
            return "is" + rawValue.capitalized
        }
    }
    
    var state = State.ready {
        willSet {
            willChangeValue(forKey: newValue.keyPath)
            willChangeValue(forKey: state.keyPath)
        }
        didSet {
            didChangeValue(forKey: oldValue.keyPath)
            didChangeValue(forKey: state.keyPath)
        }
    }
}

extension AsyncOperation {
    override var isReady: Bool {
        return super.isReady && state == .ready
    }
    
    override var isExecuting: Bool {
        return state == .executing
    }
    
    override var isFinished: Bool {
        return state == .finished
    }
    
    override var isCancelled: Bool {
        return state == .cancelled
    }
    
    override var isAsynchronous: Bool {
        return true
    }
    
    override func start() {
        if isCancelled {
            state = .finished
            return
        }
        main()
        state = .executing
    }
    
    override func cancel() {
        state = .cancelled
    }
}

// MARK: ImageLoadOperation

class ImageLoadOperation: AsyncOperation, ImageProtocol {
    private let imageString: String
    private(set) var result: Result<UIImage, Error>?
    
    init(imageString: String) {
        self.imageString = imageString
        super.init()
    }
    
    override func main() {
        
        if isCancelled {
            state = .finished
            return
        }
        
        syncLoadImg(imageString: imageString) { [weak self] result in
            self?.result = result
            self?.state = .finished
        }
    }
}

// MARK: DataLoadOperation

class DataLoadOperation: AsyncOperation, DataProtocol {
    private let fileName: String
    
    private(set) var result: Result<Data, Error>?
    
    init(fileName: String) {
        self.fileName = fileName
        super.init()
    }
    
    override func main() {
        if isCancelled {
            state = .finished
            return
        }
        syncReadData(fileName: fileName) { [weak self] result in
            self?.result = result
            self?.state = .finished
        }
    }
}

// MARK: SaveImageOperation

class SaveImageOperation: AsyncOperation, ImageProtocol {
    
    private(set) var result: Result<UIImage, Error>?
    private let image: UIImage
    private let imageString: String
    
    init(imageString: String, image: UIImage) {
        self.image = image
        self.imageString = imageString
        super.init()
    }
    
    override func main() {
        
        if isCancelled {
            state = .finished
            return
        }
        syncSaveImg(fileName: imageString, image: image) { [weak self] (result) in
            self?.result = result
            self?.state = .finished
        }
    }
}

// MARK: SaveDataOperation

class SaveDataOperation: AsyncOperation, DataProtocol {
    
    private(set) var result: Result<Data, Error>?
    private var fileName: String
    private var userInfo: UserDataModel
    
    init(fileName: String, userInfo: UserDataModel) {
        self.fileName = fileName
        self.userInfo = userInfo
        super.init()
    }
    
    override func main() {
        if isCancelled {
            state = .finished
            return
        }
        let name = userInfo.name
        let workInfo = userInfo.workInfo
        let location = userInfo.location
        
        syncSaveData(toFile: fileName, name: name, workInfo: workInfo, location: location) { [weak self] (result) in
            self?.result = result
            self?.state = .finished
        }
    }
}

// MARK: ImageProtocol

protocol ImageProtocol {
    var result: Result<UIImage, Error>? { get }
}

// MARK: DataProtocol

protocol DataProtocol {
    var result: Result<Data, Error>? { get }
}

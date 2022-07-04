//
//  MockStorageService.swift
//  ColorApp
//
//  Created by Erkki Nokso-Koivisto on 4.7.2022.
//

import Foundation
import Combine
class MockStorageService : StorageService {
        
    var mockUp : Storage  {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let v = try! decoder.decode(Storage.self, from: "{\"id\",\"123\"}".data(using: .utf8)!)
        return v
    }
    
    func login(username: String, password: String) -> AnyPublisher<Storage, Error> {
        Just(mockUp).setFailureType(to: Error.self).eraseToAnyPublisher()
    }
    
    func create(token: String, data: String) -> AnyPublisher<Storage, Error> {
        Just(mockUp).setFailureType(to: Error.self).eraseToAnyPublisher()
    }
    
    func update(token: String, id: String, data: String) -> AnyPublisher<Storage, Error> {
        Just(mockUp).setFailureType(to: Error.self).eraseToAnyPublisher()
    }
    
    func fetch(token: String, id: String) -> AnyPublisher<Storage, Error> {
        Just(mockUp).setFailureType(to: Error.self).eraseToAnyPublisher()
    }
    
    func delete(token: String, id: String) -> AnyPublisher<String, Error> {
        Just("OK").setFailureType(to: Error.self).eraseToAnyPublisher()
    }
    
    func loadFromDisk() -> Storage? {
        return mockUp
    }
    
    func saveToDisk(storage: Storage) {}
    
    func deleteFromDisk() {}
    
    
}

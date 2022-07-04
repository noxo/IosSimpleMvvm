//
//  ColorService.swift
//  ColorApp
//
//  Created by Erkki Nokso-Koivisto on 4.7.2022.
//

import Foundation
import Combine
import KeychainSwift

public protocol StorageService {
    func login(username: String, password: String) -> AnyPublisher<Storage, Error>
    func create(token: String, data: String) -> AnyPublisher<Storage, Error>
    func update(token: String, id: String, data: String) -> AnyPublisher<Storage, Error>
    func fetch(token: String, id: String) -> AnyPublisher<Storage, Error>
    func delete(token: String, id: String) -> AnyPublisher<String, Error>
    func loadFromDisk() -> Storage?
    func saveToDisk(storage : Storage)
    func deleteFromDisk()
}

class RestStorageService : StorageService {
    
    let baseUrl = "https://id24jneh2i.execute-api.eu-west-1.amazonaws.com/api"
    let client = RestClient()
    let keychain = KeychainSwift()

    func login(username: String, password: String) -> AnyPublisher<Storage, Error> {
        var request = URLRequest(url: URL(string: "\(baseUrl)/v1/login")!)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let parameters = ["username" : username, "password" : password]
        let body = try! JSONSerialization.data(withJSONObject: parameters, options: .withoutEscapingSlashes)
        request.httpBody = body
        return client.doRequestJson(request: request).eraseToAnyPublisher()
    }
    
    func create(token: String, data: String) -> AnyPublisher<Storage, Error> {
        var request = URLRequest(url: URL(string: "\(baseUrl)/v1/storage")!)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(token, forHTTPHeaderField: "Authorization")
        request.httpMethod = "POST"
        let parameters = ["data" : data]
        request.httpBody = try! JSONSerialization.data(withJSONObject: parameters, options: .withoutEscapingSlashes)
        return client.doRequestJson(request: request)
    }
    
    func update(token: String, id: String, data: String) -> AnyPublisher<Storage, Error> {
        var request = URLRequest(url: URL(string: "\(baseUrl)/v1/storage/\(id)")!)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(token, forHTTPHeaderField: "Authorization")
        request.httpMethod = "PUT"
        let parameters = ["id" : id, "data" : data]
        request.httpBody = try! JSONSerialization.data(withJSONObject: parameters, options: .withoutEscapingSlashes)
        return client.doRequestJson(request: request)
    }
    
    func fetch(token: String, id: String) -> AnyPublisher<Storage, Error> {
        var request = URLRequest(url: URL(string: "\(baseUrl)/v1/storage/\(id)")!)
        request.addValue(token, forHTTPHeaderField: "Authorization")
        return client.doRequestJson(request: request)
    }
    
    func delete(token: String, id: String) -> AnyPublisher<String, Error> {
        var request = URLRequest(url: URL(string: "\(baseUrl)/v1/storage/\(id)")!)
        request.addValue(token, forHTTPHeaderField: "Authorization")
        request.httpMethod = "DELETE"
        return client.doRequest(request: request)
    }
    
    func loadFromDisk() -> Storage? {
        guard let json = keychain.getData("stored") else {
            return nil
        }
        return try? JSONDecoder().decode(Storage.self, from: json)
    }
    
    func saveToDisk(storage: Storage) {
        guard let data = try? JSONEncoder().encode(storage) else {
            return
        }
        keychain.set(data, forKey: "stored")
    }
    
    func deleteFromDisk() {
        keychain.delete("stored")
    }
}

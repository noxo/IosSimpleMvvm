//
//  ViewModel.swift
//  ColorApp
//
//  Created by Erkki Nokso-Koivisto on 4.7.2022.
//

import Foundation
import Combine
import SwiftUI
import BlackLabsColor

final class ViewModel : ObservableObject  {
    
    @Published var storage: Storage?
    
    @Published var loginFailed : Bool = false
    @Published var loggedIn : Bool = false
    @Published var color: Color = .white
    
    @Published var username : String = ""
    @Published var password : String = ""
    
    let storageService : StorageService
    var cancellable = Set<AnyCancellable>()
    
    init(storageService : StorageService) {
        self.storageService = storageService
        restoreState()
    }
    
    func login() {
        storageService
            .login(username: username, password: password)
            .sink { [weak self] (completion) in
                switch completion {
                case .failure(_):
                    self?.loginFailed = true
                case .finished: break
                }
            } receiveValue: { [weak self] (value) in
                self?.storage = value
                self?.loggedIn = true
                self?.saveState()
            }.store(in: &cancellable)
    }
    
    func loadColor() {
        guard let token = storage?.token, let id = storage?.id else {
            return
        }
        storageService
            .fetch(token: token, id: id)
            .sink { [weak self] (completion) in
                switch completion {
                case .failure(_):
                    self?.color = Color.white
                case .finished: break
                }
            } receiveValue: { [weak self] (value) in
                self?.color = Color(UIColor.init(hex: value.data))
            }.store(in: &cancellable)
    }
    
    func saveColor() {
        guard let token = storage?.token else {
            return
        }
        let data = UIColor(color).hexDescription()
        if let id = storage?.id {
            storageService
                .update(token: token, id: id, data: data)
                .sink { completion in
                    switch completion {
                    case .failure(_):
                        print("failed")
                    case .finished: break
                    }
                } receiveValue: { [weak self] (value) in
                    self?.storage = Storage(id: value.id, data: data, token: token)
                    self?.saveState()
                }.store(in: &cancellable)
        } else {
            storageService
                .create(token: token, data: data)
                .sink { completion in
                    switch completion {
                    case .failure(_):
                        print("failed")
                    case .finished: break
                    }
                } receiveValue: { [weak self] (value) in
                    self?.storage = Storage(id: value.id, data: data, token: token)
                    self?.saveState()
                }.store(in: &cancellable)
        }
    }
    
    func restoreState() {
        guard let storageOnDisk = storageService.loadFromDisk() else {
            return
        }
        self.storage = storageOnDisk
        loggedIn = true
    }
    
    func saveState() {
        guard let storage = storage else {
            return
        }
        storageService.saveToDisk(storage: storage)
    }
    
    func resetSavedState() {
        storageService.deleteFromDisk()
        loggedIn = false
        color = .white
        username = ""
        password = ""
    }
}

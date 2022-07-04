//
//  ColorAppApp.swift
//  ColorApp
//
//  Created by Erkki Nokso-Koivisto on 4.7.2022.
//

import SwiftUI

@main
struct ColorAppApp: App {
    @StateObject var model = ViewModel(storageService: RestStorageService())
    
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: model)
        }
    }
}

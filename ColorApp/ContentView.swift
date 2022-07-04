//
//  ContentView.swift
//  ColorApp
//
//  Created by Erkki Nokso-Koivisto on 4.7.2022.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel: ViewModel
    
    var body: some View {
        ZStack {
            viewModel.color.ignoresSafeArea()
                .ignoresSafeArea()
            if (!viewModel.loggedIn) {
                LoginView(viewModel: viewModel)
            }
            else {
                ColorView(viewModel: viewModel)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = ViewModel(storageService: MockStorageService())
        ContentView(viewModel: viewModel)
    }
}

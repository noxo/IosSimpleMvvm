//
//  LoginView.swift
//  ColorApp
//
//  Created by Erkki Nokso-Koivisto on 4.7.2022.
//

import SwiftUI
import Combine

struct LoginView: View {
    @ObservedObject var viewModel: ViewModel
    
    var body: some View {
        VStack(alignment: .center){
            TextField(
                "User name",
                text: $viewModel.username
            )
            .textFieldStyle(.roundedBorder)
            .textInputAutocapitalization(.never)
            .disableAutocorrection(true)
            
            SecureField("Enter a password", text: $viewModel.password)
            
            Button("Login", action: {
                viewModel.login()
            })
        }
        .alert("Login failed", isPresented: $viewModel.loginFailed, actions: {})
    }
    
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = ViewModel(storageService: MockStorageService())
        LoginView(viewModel: viewModel)
    }
}

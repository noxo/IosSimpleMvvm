//
//  ColorView.swift
//  ColorApp
//
//  Created by Erkki Nokso-Koivisto on 4.7.2022.
//

import SwiftUI

struct ColorView: View {
    @ObservedObject var viewModel: ViewModel
    
    var body: some View {
        VStack {
            ColorPicker("Color", selection: $viewModel.color)
                .onChange(of: viewModel.color) { _ in
                    viewModel.saveColor()
                }
            Button("Reset", action: {
                viewModel.resetSavedState()
            })
        }.onAppear(perform: viewModel.loadColor)
    }
}

struct ColorView_Previews: PreviewProvider {
    static var previews: some View {
        let model = ViewModel(storageService: MockStorageService())
        ColorView(viewModel: model)
    }
}

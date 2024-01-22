//
//  LocationSearch.swift
//  AirGuard
//
//  Created by Mila B on 17.01.2024.
//

import SwiftUI


struct LocationSearchView: View {
    
    @StateObject var viewModel: LocationSearchViewModel
    @FocusState private var isFocusedTextField: Bool
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 0) {
            
            TextField("Введите местоположение", text: $viewModel.searchableText)
                .padding()
                .autocorrectionDisabled()
                .focused($isFocusedTextField)
                .font(.title)
                .onReceive(
                    viewModel.$searchableText.debounce(
                        for: .seconds(1),
                        scheduler: DispatchQueue.main
                    )
                ) {
                    viewModel.searchAddress($0)
                }
                .background(Color.init(uiColor: .systemBackground))
                .overlay {
                    ClearButton(text: $viewModel.searchableText)
                        .padding(.trailing)
                        .padding(.top, 8)
                }
                .onAppear {
                    isFocusedTextField = true
                }
            
            
            VStack {
                ForEach(viewModel.results) { address in
                    VStack(alignment: .leading) {
                        Text(address.title)
                        Text(address.subtitle)
                            .font(.caption)
                    }
                    .padding(.bottom, 2)
                }
            }
        }
        .background(backgroundColor)
        .edgesIgnoringSafeArea(.bottom)
        
    }
    
    var backgroundColor: Color = Color.init(uiColor: .systemGray6)
}

struct ClearButton: View {
    
    @Binding var text: String
    
    var body: some View {
        if text.isEmpty == false {
            HStack {
                Spacer()
                Button {
                    text = ""
                } label: {
                    Image(systemName: "multiply.circle.fill")
                        .foregroundColor(Color(red: 0.7, green: 0.7, blue: 0.7))
                }
                .foregroundColor(.secondary)
            }
        } else {
            EmptyView()
        }
    }
}



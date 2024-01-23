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
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Environment(\.colorScheme) var colorScheme
    
    @State private var showAlert = false
    @State var chosenLocation: SearchAddressResult? = nil
    
    var onDismiss: (SearchAddressResult) -> Void
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 2) {
            HStack {
                Image(systemName: "magnifyingglass")
                
                TextField("Введите местоположение", text: $viewModel.searchableText)
                    .autocorrectionDisabled()
                    .focused($isFocusedTextField)
                    .font(.title3)
                    .onReceive(
                        viewModel.$searchableText.debounce(
                            for: .seconds(1),
                            scheduler: DispatchQueue.main
                        )
                    ) {
                        viewModel.searchAddress($0)
                    }
                    .overlay {
                        ClearButton(text: $viewModel.searchableText)
                            .padding(.trailing)
                    }
                    .onAppear {
                        isFocusedTextField = true
                    }
            }
            .padding(.all, 5)
            .background(Color(uiColor: .systemGray6))
            .cornerRadius(50)
            
            ScrollView {
                VStack(alignment: .leading) {
                    ForEach(viewModel.results) { address in
                        Button {
                            showAlert = true
                            chosenLocation = address
                        } label: {
                            VStack(alignment: .leading) {
                                Text(address.title)
                                Text(address.subtitle)
                                    .font(.caption)
                            }
                        }
                        .foregroundStyle(colorScheme == .dark ? Color.white : Color.black)
                        .padding(.all, 2)
                        Divider()
                    }
                }
                .padding(.horizontal, 2)
            }
            .padding(.top, 5)
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Изменить местоположение"),
                message: Text("Вы уверены, что хотите изменить ваше местоположение?"),
                primaryButton: .cancel(
                    Text("ОК"),
                    action: {
                        if let location = chosenLocation {
                            onDismiss(location)
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                            self.presentationMode.wrappedValue.dismiss()
                        }
                    }
                ),
                secondaryButton: .destructive(
                    Text("Закрыть"),
                    action: {
                        showAlert = false
                        chosenLocation = nil
                    }
                )
            )
        }
        .navigationBarTitle("Изменить местоположение")
        .padding()
        Spacer()
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
                        .foregroundColor(Color.black)
                }
                .foregroundColor(.secondary)
            }
        } else {
            EmptyView()
        }
    }
}



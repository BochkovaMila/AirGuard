//
//  SettingsView.swift
//  AirGuard
//
//  Created by Mila B on 11.01.2024.
//

import SwiftUI

struct SettingsView: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    @StateObject var viewModel = CurrentDataViewModel()
    
    @State var isMoreInfoLinkActive = false
    @State var isChangeLocationLinkActive = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.clear.ignoresSafeArea()
                
                VStack(spacing: 20) {
                    Button {
                        isChangeLocationLinkActive = true
                    } label: {
                        VStack(alignment: .center, spacing: 5) {
                            Group {
                                Image(systemName: "mappin.circle.fill")
                                Text("Change Location")
                            }
                            .fontWeight(.bold)
                            .font(.title)
                            .foregroundColor(colorScheme == .dark ? .white : .black)
                        }
                    }
                    .accessibilityIdentifier("SettingsChangeLocationButton")
                    .frame(width: 275, height: 275)
                    .background(.accent)
                    .clipShape(RoundedRectangle(cornerRadius: 25, style: .continuous))
                    .padding()
                    
                    
                    Button {
                        isMoreInfoLinkActive = true
                    } label: {
                        VStack(alignment: .center, spacing: 5) {
                            Group {
                                Image(systemName: "info.circle.fill")
                                Text("More Information")
                            }
                            .fontWeight(.bold)
                            .font(.title)
                            .foregroundColor(colorScheme == .dark ? .white : .black)
                        }
                    }
                    .accessibilityIdentifier("SettingsMoreInfoButton")
                    .frame(width: 275, height: 275)
                    .background(.accent)
                    .clipShape(RoundedRectangle(cornerRadius: 25, style: .continuous))
                    .padding()
                }
                .padding()
                Spacer()
            }
            .navigationTitle("Settings")
            .navigationDestination(isPresented: $isMoreInfoLinkActive) {
                MoreInfoView()
                    .accessibilityIdentifier("SettingsMoreInfoView")
            }
            .navigationDestination(isPresented: $isChangeLocationLinkActive) {
                LocationSearchView(viewModel: LocationSearchViewModel(), onDismiss: { newValue in
                    self.viewModel.addressString = newValue.title + "," + newValue.subtitle
                    self.viewModel.locationManager.getCoordinate(from: viewModel.addressString) { coord in
                        if let latitude = coord?.0, let longitude = coord?.1 {
                            self.viewModel.updateUI(lat: latitude, lon: longitude)
                        }
                    }
                })
                .accessibilityIdentifier("SettingsChangeLocationView")
            }
        }
    }
}


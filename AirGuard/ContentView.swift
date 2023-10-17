//
//  ContentView.swift
//  AirGuard
//
//  Created by Mila B on 17.10.2023.
//

import SwiftUI
import MapKit

struct ContentView: View {
    @StateObject var viewModel: ContentViewModel
    
    var body: some View {
        VStack {
            Map(coordinateRegion: $viewModel.locationManager.region, showsUserLocation: true)
                .edgesIgnoringSafeArea(.all)
            Text("Air Quality Data: \(viewModel.airQualityData)")
                .padding()
        }
        .onAppear {
            viewModel.fetchAQData()
        }
    }
}


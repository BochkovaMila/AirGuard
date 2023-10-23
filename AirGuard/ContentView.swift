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
        
        Map(coordinateRegion: $viewModel.locationManager.region, showsUserLocation: true, annotationItems: viewModel.searchResults) { point in
            MapAnnotation(coordinate: point.coordinate) {
                Button(action: {
                    // TODO: - navigate to sub view
                }) {
                    ZStack {
                        Circle()
                            .fill(.green)
                            .frame(width: 30, height: 30)
                        Text(String(point.aqData?.list[0].main.aqi ?? -1))
                            .foregroundStyle(.background)
                    }
                }
            }
        }
        .ignoresSafeArea()
        .onAppear {
            viewModel.loadAnnotationsByCurrentLocation()
        }
        .onReceive(viewModel.locationManager.$region.debounce(for: .milliseconds(500), scheduler: RunLoop.main)) { _ in
            viewModel.loadAnnotationsByCurrentLocation()
        }
    }
}


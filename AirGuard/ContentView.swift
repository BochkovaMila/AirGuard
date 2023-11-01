//
//  ContentView.swift
//  AirGuard
//
//  Created by Mila B on 17.10.2023.
//

import SwiftUI
import MapKit
import CoreLocationUI

struct ContentView: View {
    @StateObject var viewModel: ContentViewModel
    @State private var selectedParam = "Индекс"
    let params = ["Индекс", "SO2", "NO2", "PM10", "PM2.5", "03", "CO3"]
    
    var body: some View {
        
        ZStack(alignment: .topTrailing) {
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
            .onAppear {
                viewModel.loadAnnotationsByCurrentLocation()
            }
            .onReceive(viewModel.locationManager.$region.debounce(for: .milliseconds(500), scheduler: RunLoop.main)) { _ in
                viewModel.loadAnnotationsByCurrentLocation()
            }
            
            LocationButton {
                viewModel.locationManager.requestLocation()
            }
            .frame(width: 60, height: 60)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(UIColor.systemBackground))
              )
            .labelStyle(.iconOnly)
            .symbolVariant(.fill)
            .foregroundColor(Color(UIColor.systemBackground))
            .padding(.top, 100)
            .padding(.trailing, 10)
        }
        .overlay(alignment: .topTrailing) {
            Picker("Параметр", selection: $selectedParam) {
                ForEach(params, id: \.self) {
                    Text($0)
                        .foregroundStyle(.white)
                        .fontWeight(.bold)
                }
            }
            .pickerStyle(.menu)
            .frame(width: 120, height: 60)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(UIColor.systemBackground))
              )
            .padding(.top, 20)
            .padding(.trailing, 10)
        }
        
    }
}


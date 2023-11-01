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
    @State private var selectedParam: AirQualityParameters = .index
    //@State private var
    
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
                                .frame(width: 40, height: 40)
                            Text(getInfoForSelectedParam(point))
                                .frame(width: 40, height: 40)
                                .scaledToFit()
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
                ForEach(AirQualityParameters.allCases, id: \.self) {
                    Text($0.localizedName)
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
    
    private func getInfoForSelectedParam(_ point: InfoPoint) -> String {
        switch self.selectedParam {
        case .index:
            return String(point.aqData?.list[0].main.aqi ?? -1)
        case .SO2:
            if let value = point.aqData?.list[0].components["so2"] as? Double {
              return String(format: "%.1f", value)
            }
            return String(-1)
        case .NO2:
            if let value = point.aqData?.list[0].components["no2"] as? Double {
              return String(format: "%.1f", value)
            }
            return String(-1)
        case .PM10:
            if let value = point.aqData?.list[0].components["pm10"] as? Double {
              return String(format: "%.1f", value)
            }
            return String(-1)
        case .PM2:
            if let value = point.aqData?.list[0].components["pm2_5"] as? Double {
                return String(format: "%.1f", value)
            }
            return String(-1)
        case .O3:
            if let value = point.aqData?.list[0].components["o3"] as? Double {
              return String(format: "%.1f", value)
            }
            return String(-1)
        case .NH3:
            if let value = point.aqData?.list[0].components["nh3"] as? Double {
              return String(format: "%.1f", value)
            }
            return String(-1)
        }
    }
}


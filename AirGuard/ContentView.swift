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
    @State private var showingDetails = false
    @State private var pinLocation :CLLocationCoordinate2D? = nil
    
    var body: some View {
        
        ZStack(alignment: .topTrailing) {
            Map(coordinateRegion: $viewModel.locationManager.region, showsUserLocation: true, annotationItems: viewModel.searchResults) { point in
                MapAnnotation(coordinate: point.coordinate) {
                    Button(action: {
                        showingDetails.toggle()
                    }) {
                        ZStack {
                            Circle()
                                .fill(getColorForSelectedParam(point))
                                .frame(width: 40, height: 40)
                            Text(getInfoForSelectedParam(point))
                                .frame(width: 40, height: 40)
                                .scaledToFit()
                                .foregroundStyle(.background)
                        }
                    }
                    .sheet(isPresented: $showingDetails) {
                        DetailedInfoView(chosenPoint: point)
                            .presentationDetents([.height(300)])
                    }
                }
            }
            .onAppear {
                viewModel.loadAnnotationsByCurrentLocation()
            }
            .onReceive(viewModel.locationManager.$region.debounce(for: .milliseconds(500), scheduler: RunLoop.main)) { _ in
                viewModel.loadAnnotationsByCurrentLocation()
            }
            VStack(alignment: .trailing, spacing: 15) {
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
                .padding(.trailing, 10)
            }
        }
    }
    
    private func getColorForSelectedParam(_ point: InfoPoint) -> Color {
        switch self.selectedParam {
        case .index:
            if let value = point.aqData?.list[0].main.aqi {
                switch value {
                case 1:
                    return Color.green
                case 2:
                    return Color.yellow
                case 3:
                    return Color.orange
                case 4:
                    return Color.red
                case 5:
                    return Color.purple
                default:
                    return Color.gray
                }
            }
            else { return Color.gray }
        case .SO2:
            if let value = point.aqData?.list[0].components["so2"] as? Double {
                switch Int(value) {
                case 0..<20:
                    return Color.green
                case 20..<80:
                    return Color.yellow
                case 80..<250:
                    return Color.orange
                case 250..<350:
                    return Color.red
                case 350...Int.max:
                    return Color.purple
                default:
                    return Color.gray
                }
            }
            else { return Color.gray }
        case .NO2:
            if let value = point.aqData?.list[0].components["no2"] as? Double {
                switch Int(value) {
                case 0..<40:
                    return Color.green
                case 40..<70:
                    return Color.yellow
                case 70..<150:
                    return Color.orange
                case 150..<200:
                    return Color.red
                case 200...Int.max:
                    return Color.purple
                default:
                    return Color.gray
                }
            }
            else { return Color.gray }
        case .PM10:
            if let value = point.aqData?.list[0].components["pm10"] as? Double {
                switch Int(value) {
                case 0..<20:
                    return Color.green
                case 20..<50:
                    return Color.yellow
                case 50..<100:
                    return Color.orange
                case 100..<200:
                    return Color.red
                case 200...Int.max:
                    return Color.purple
                default:
                    return Color.gray
                }
            }
            else { return Color.gray }
        case .PM2:
            if let value = point.aqData?.list[0].components["pm2_5"] as? Double {
                switch Int(value) {
                case 0..<10:
                    return Color.green
                case 10..<25:
                    return Color.yellow
                case 25..<50:
                    return Color.orange
                case 50..<75:
                    return Color.red
                case 75...Int.max:
                    return Color.purple
                default:
                    return Color.gray
                }
            }
            else { return Color.gray }
        case .O3:
            if let value = point.aqData?.list[0].components["o3"] as? Double {
                switch Int(value) {
                case 0..<60:
                    return Color.green
                case 60..<100:
                    return Color.yellow
                case 100..<140:
                    return Color.orange
                case 140..<180:
                    return Color.red
                case 180...Int.max:
                    return Color.purple
                default:
                    return Color.gray
                }
            }
            else { return Color.gray }
        case .CO:
            if let value = point.aqData?.list[0].components["co"] as? Double {
                switch Int(value) {
                case 0..<440:
                    return Color.green
                case 440..<9400:
                    return Color.yellow
                case 9400..<12400:
                    return Color.orange
                case 12400..<15400:
                    return Color.red
                case 15400...Int.max:
                    return Color.purple
                default:
                    return Color.gray
                }
            }
            else { return Color.gray }
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
        case .CO:
            if let value = point.aqData?.list[0].components["co"] as? Double {
              return String(Int(value))
            }
            return String(-1)
        }
    }
}

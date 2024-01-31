//
//  ForecastView.swift
//  AirGuard
//
//  Created by Mila B on 11.01.2024.
//

import SwiftUI
import Charts

struct ForecastView: View {
    
    @Environment(\.colorScheme) var colorScheme
    @StateObject var viewModel = ForecastViewModel()
    @State var isChangeLocationLinkActive = false
    @State var isMoreInfoLinkActive = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                
                VStack {
                    ZStack(alignment: .topTrailing) {
                        Text(viewModel.addressString)
                            .frame(width: 200, height: 50, alignment: .center)
                            .font(Font.system(size: 34))
                            .scaledToFill()
                            .minimumScaleFactor(0.5)
                            .lineLimit(1)
                            .padding(.all, 20)
                        
                        Button {
                            isChangeLocationLinkActive = true
                        } label: {
                            Image(systemName: "pencil")
                                .resizable()
                                .scaledToFit()
                                .foregroundStyle(colorScheme == .dark ? Color.white : Color.black)
                                .frame(width: 20, height: 20)
                                .padding(.all, 5)
                        }
                    }
                    
                    let data = viewModel.forecastData.enumerated().filter { (index, element) in
                        return index % 23 == 0
                    }.map { (index, element) in
                        return element
                    }
                    
                    Text("Индекс (по дням):")
                        .font(.title2)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 20)
                        .padding(.top, 10)
                    
                    Chart {
                        ForEach(data) { viewDay in
                            BarMark(
                                x: .value("Day", viewDay.date, unit: .day),
                                y: .value("Data", viewDay.main.aqi)
                            )
                            .foregroundStyle(
                                getChartColorForIndex(viewDay.main.aqi)
                                .gradient
                            )
                        }
                    }
                    .chartYScale(domain: 0...5)
                    .chartXAxis {
                        AxisMarks(values: data.map { $0.date }) { date in
                            AxisValueLabel(format: .dateTime.day())
                        }
                    }
                    .chartYAxis {
                        AxisMarks(position: .leading)
                    }
                    .frame(height: 200)
                    .padding()
                    
                    AirQualityChartView(data: data, param: "so2", title: AirQualityParameters.SO2.rawValue)
                    AirQualityChartView(data: data, param: "no2", title: AirQualityParameters.NO2.rawValue)
                    AirQualityChartView(data: data, param: "pm10", title: AirQualityParameters.PM10.rawValue)
                    AirQualityChartView(data: data, param: "pm2_5", title: AirQualityParameters.PM2.rawValue)
                    AirQualityChartView(data: data, param: "o3", title: AirQualityParameters.O3.rawValue)
                    AirQualityChartView(data: data, param: "co", title: AirQualityParameters.CO.rawValue)
                    
                    Spacer()
                }
                
                Spacer()
            }
            .navigationTitle("Прогноз качества воздуха")
            .toolbar {
                Button {
                    isMoreInfoLinkActive = true
                } label: {
                    Image(systemName: "info.circle")
                        .foregroundStyle(colorScheme == .dark ? Color.white : Color.black)
                }
            }
            .navigationDestination(isPresented: $isMoreInfoLinkActive) {
                MoreInfoView()
            }
            .navigationDestination(isPresented: $isChangeLocationLinkActive) {
                LocationSearchView(viewModel: LocationSearchViewModel(), onDismiss: { newValue in
                    self.viewModel.addressString = newValue.title + "," + newValue.subtitle
                    self.viewModel.locationManager.getCoordinate(from: viewModel.addressString) { coord in
                        if let latitude = coord?.0, let longitude = coord?.1 {
                            self.viewModel.updateUI(with: latitude, long: longitude)
                        }
                    }
                })
            }
        }
    }
}

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
                    
                    Chart {
                        ForEach(viewModel.forecastData) { viewDay in
                            BarMark(
                                x: .value("Day", viewDay.date, unit: .day),
                                y: .value("Data", viewDay.main.aqi)
                            )
                            .foregroundStyle(Color.pink.gradient)
                            .cornerRadius(10)
                        }
                    }
                    .chartXAxis {
                        AxisMarks(values: viewModel.forecastData.map { $0.date }) { date in
                            AxisGridLine()
                            AxisTick()
                            AxisValueLabel(format: .dateTime.day(.twoDigits), centered: true)
                        }
                    }
                    .chartYAxis {
                        AxisMarks(position: .leading) { mark in
                            AxisGridLine()
                        }
                    }
                    .frame(height: 300)
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


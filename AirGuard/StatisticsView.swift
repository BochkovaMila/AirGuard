//
//  StatisticsView.swift
//  AirGuard
//
//  Created by Mila B on 11.01.2024.
//

import SwiftUI
import Charts

struct StatisticsView: View {
    
    @Environment(\.colorScheme) var colorScheme
    @StateObject var viewModel = StatisticsViewModel()
    @State var isChangeLocationLinkActive = false
    @State var isMoreInfoLinkActive = false
    
    let dateRange: ClosedRange<Date> = {
        let calendar = Calendar.current
        let startComponents = DateComponents(year: 2020, month: 11, day: 27)
        let endComponents = Date()
        return calendar.date(from:startComponents)!
            ...
            endComponents
    }()
    
    
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
                        .accessibilityIdentifier("StatisticsChangeLocationButton")
                    }
                    
                    Group {
                        DatePicker("Выберите начало интервала:",
                                   selection: $viewModel.startDate,
                                   in: dateRange
                        )
                        .accessibilityIdentifier("StartIntervalPicker")
                        .onReceive(self.viewModel.$startDate) { _ in
                            viewModel.updateUI(lat: viewModel.locationManager.region.center.latitude, lon: viewModel.locationManager.region.center.longitude)
                        }
                        
                        DatePicker("Выберите конец интервала:",
                                   selection: $viewModel.endDate,
                                   in: dateRange
                        )
                        .accessibilityIdentifier("EndIntervalPicker")
                        .onReceive(self.viewModel.$endDate) { _ in
                            viewModel.updateUI(lat: viewModel.locationManager.region.center.latitude, lon: viewModel.locationManager.region.center.longitude)
                        }
                    }
                    .padding()
                    
                    let dailyData = viewModel.historyData.enumerated().filter { (index, element) in
                        return (index + 1) % 24 == 0
                    }.map { (index, element) in
                        return element
                    }
                    
                    Text("Индекс:")
                        .font(.title2)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 20)
                        .padding(.top, 10)
                    
                    Chart {
                        ForEach(dailyData) { viewDay in
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
                    .accessibilityIdentifier("StatisticsIndexChart")
                    .chartYScale(domain: 0...5)
                    .chartXAxis(.automatic)
                    .chartYAxis {
                        AxisMarks(position: .leading, values: .automatic(desiredCount: 6))
                    }
                    .frame(height: 200)
                    .padding()
                    
                    AirQualityChartView(data: dailyData, param: "so2", title: AirQualityParameters.SO2.rawValue)
                        .accessibilityIdentifier("StatisticsSO2Chart")
                    AirQualityChartView(data: dailyData, param: "no2", title: AirQualityParameters.NO2.rawValue)
                        .accessibilityIdentifier("StatisticsNO2Chart")
                    AirQualityChartView(data: dailyData, param: "pm10", title: AirQualityParameters.PM10.rawValue)
                        .accessibilityIdentifier("StatisticsPM10Chart")
                    AirQualityChartView(data: dailyData, param: "pm2_5", title: AirQualityParameters.PM2.rawValue)
                        .accessibilityIdentifier("StatisticsPM2Chart")
                    AirQualityChartView(data: dailyData, param: "o3", title: AirQualityParameters.O3.rawValue)
                        .accessibilityIdentifier("StatisticsO3Chart")
                    AirQualityChartView(data: dailyData, param: "co", title: AirQualityParameters.CO.rawValue)
                        .accessibilityIdentifier("StatisticsCOChart")
                    
                    Spacer()
                }
                Spacer()
            }
            .navigationTitle("Статистика качества воздуха")
            .toolbar {
                Button {
                    isMoreInfoLinkActive = true
                } label: {
                    Image(systemName: "info.circle")
                        .foregroundStyle(colorScheme == .dark ? Color.white : Color.black)
                }
                .accessibilityIdentifier("StatisticsMoreInfoButton")
            }
            .navigationDestination(isPresented: $isMoreInfoLinkActive) {
                MoreInfoView()
                    .accessibilityIdentifier("StatisticsMoreInfoView")
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
                .accessibilityIdentifier("StatisticsChangeLocationView")
            }
        }
    }
}


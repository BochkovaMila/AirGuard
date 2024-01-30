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
                    
                    ForecastChartView(data: data, param: "so2", title: AirQualityParameters.SO2.rawValue)
                    ForecastChartView(data: data, param: "no2", title: AirQualityParameters.NO2.rawValue)
                    ForecastChartView(data: data, param: "pm10", title: AirQualityParameters.PM10.rawValue)
                    ForecastChartView(data: data, param: "pm2_5", title: AirQualityParameters.PM2.rawValue)
                    ForecastChartView(data: data, param: "o3", title: AirQualityParameters.O3.rawValue)
                    ForecastChartView(data: data, param: "co", title: AirQualityParameters.CO.rawValue)
                    
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
    
    private func getChartColorForIndex(_ value: Int) -> Color {
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
            return Color("darkRed")
        default:
            return Color.gray
        }
    }
}

struct ForecastChartView: View {
    let data: [ForecastList]
    let param: String
    let title: String
    
    var body: some View {
        Text("\(title): ")
            .font(.title2)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading, 20)
            .padding(.top, 10)
        
        Chart {
            ForEach(data) { viewDay in
                BarMark(
                    x: .value("Day", viewDay.date, unit: .day),
                    y: .value("Value", viewDay.components[param] ?? 0.0)
                )
                .foregroundStyle(
                    getChartColorForParam(title, viewDay.components[param] ?? 0.0)
                    .gradient
                )
            }
        }
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
    }
    
    private func getChartColorForParam(_ param: String, _ value: Double) -> Color {
        if param == "SO2" {
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
                return Color("darkRed")
            default:
                return Color.gray
            }
        }
        else if param == "NO2" {
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
                return Color("darkRed")
            default:
                return Color.gray
            }
        }
        else if param == "PM10" {
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
                return Color("darkRed")
            default:
                return Color.gray
            }
        }
        else if param == "PM2.5" {
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
                return Color("darkRed")
            default:
                return Color.gray
            }
        }
        else if param == "O3" {
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
                return Color("darkRed")
            default:
                return Color.gray
            }
        }
        else if param == "CO" {
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
                return Color("darkRed")
            default:
                return Color.gray
            }
        }
        else { return Color.gray }
    }
}

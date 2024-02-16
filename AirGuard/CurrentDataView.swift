//
//  CurrentDataView.swift
//  AirGuard
//
//  Created by Mila B on 11.01.2024.
//

import SwiftUI

struct CurrentDataView: View {
    
    @Environment(\.colorScheme) var colorScheme
    @StateObject var viewModel = CurrentDataViewModel()
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
                        .accessibilityIdentifier("ChangeLocationButton")
                    }
                    
                    ZStack {
                        CrescentProgressView(value: viewModel.aqi)
                            .frame(width: 200, height: 200)
                            .accessibilityIdentifier("AQIProgressView")
                        VStack {
                            HStack {
                                Text("\(viewModel.aqi)")
                                    .font(Font.system(size: 28))
                                    .bold()
                                Text(AirQualityParameters.index.rawValue)
                            }
                            Text(getInterpretationFromAQI(value: viewModel.aqi))
                        }
                        .padding(.top, -30)
                    }
                    
                    Text("Показатели:")
                        .font(Font.system(size: 28))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 40)
                        .padding(.top, -30)
                    
                    Group {
                        HStack(spacing: 10) {
                            Group {
                                VerticalDataView(param: AirQualityParameters.SO2.rawValue, value: viewModel.SO2)
                                    //.accessibilityIdentifier("SO2ProgressView")
                                VerticalDataView(param: AirQualityParameters.NO2.rawValue, value: viewModel.NO2)
                                    .accessibilityIdentifier("NO2ProgressView")
                            }
                            .padding(.horizontal, 15)
                        }
                        
                        HStack(spacing: 10) {
                            Group {
                                VerticalDataView(param: AirQualityParameters.PM10.rawValue, value: viewModel.PM10)
                                    .accessibilityIdentifier("PM10ProgressView")
                                VerticalDataView(param: AirQualityParameters.PM2.rawValue, value: viewModel.PM2)
                                    .accessibilityIdentifier("PM2ProgressView")
                            }
                            .padding(.horizontal, 15)
                        }
                        
                        HStack(spacing: 10) {
                            Group {
                                VerticalDataView(param: AirQualityParameters.O3.rawValue, value: viewModel.O3)
                                    .accessibilityIdentifier("O3ProgressView")
                                VerticalDataView(param: AirQualityParameters.CO.rawValue, value: viewModel.CO)
                                    .accessibilityIdentifier("COProgressView")
                            }
                            .padding(.horizontal, 15)
                        }
                    }
                    .frame(height: 130)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 15)
                    
                    Spacer()
                }
                
                Spacer()
            }
            .navigationTitle("Текущее качество воздуха")
            .toolbar {
                Button {
                    isMoreInfoLinkActive = true
                } label: {
                    Image(systemName: "info.circle")
                        .foregroundStyle(colorScheme == .dark ? Color.white : Color.black)
                }
                .accessibilityIdentifier("MoreInfoButton")
            }
            .navigationDestination(isPresented: $isMoreInfoLinkActive) {
                MoreInfoView()
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
            }
        }
    }
    
    func getInterpretationFromAQI(value: Int) -> String {
        switch value {
        case 1:
            return "😄 Отлично"
        case 2:
            return "😄 Хорошо"
        case 3:
            return "🙂 Удовлетворительно"
        case 4:
            return "☹️ Плохо"
        case 5:
            return "😫 Ужасно"
        default:
            return "???"
        }
    }
}

struct VerticalDataView: View {
    
    let param: String
    let value: Double
    
    var body: some View {
        HStack {
            VerticalProgressView(param: param, value: value)
                .frame(width: 25)
                .padding(.trailing, 3)
            VStack(alignment: .leading) {
                Text("\(param) (μg/m3)")
                    .padding(.vertical, 2)
                Text("\(String(format: "%.1f", value))")
                    .font(Font.system(size: 28))
                    .bold()
                Spacer()
            }
            .padding(.trailing, 20)
            .frame(width: 125)
            Spacer()
        }
    }
    
}

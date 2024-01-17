//
//  CurrentDataView.swift
//  AirGuard
//
//  Created by Mila B on 11.01.2024.
//

import SwiftUI

struct CurrentDataView: View {
    var body: some View {
        ScrollView {
            
            ZStack(alignment: .topTrailing) {
                Text("Текущее качество воздуха")
                    .font(.largeTitle)
                    .padding(.all, 15)
                Button {
                    // show more information about meaning of aq data params
                } label: {
                    Image(systemName: "questionmark.circle")
                        .resizable()
                        .scaledToFit()
                        .foregroundStyle(.black)
                        .frame(width: 20, height: 20)
                        .padding(.all, 2)
                }
            }
            
            VStack {
                ZStack(alignment: .topTrailing) {
                    Text("Моя локация")
                        .font(Font.system(size: 34))
                        .padding(.all, 20)
                    Button {
                        // change location
                    } label: {
                        Image(systemName: "pencil")
                            .resizable()
                            .scaledToFit()
                            .foregroundStyle(.black)
                            .frame(width: 20, height: 20)
                            .padding(.all, 5)
                    }
                }
                
                ZStack {
                    CrescentProgressView(progress: 0.1)
                        .frame(width: 200, height: 200)
                    VStack {
                        HStack {
                            Text("-1")
                                .font(Font.system(size: 28))
                                .bold()
                            Text(AirQualityParameters.index.rawValue)
                        }
                        HStack {
                            Text("😄")
                            Text("Отлично")
                        }
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
                            VerticalDataView(param: AirQualityParameters.SO2.rawValue, value: 1.1)
                            VerticalDataView(param: AirQualityParameters.NO2.rawValue, value: 3.6)
                        }
                        .padding(.horizontal, 15)
                    }
                    
                    HStack(spacing: 10) {
                        Group {
                            VerticalDataView(param: AirQualityParameters.PM10.rawValue, value: 1.4)
                            VerticalDataView(param: AirQualityParameters.PM2.rawValue, value: 0.5)
                        }
                        .padding(.horizontal, 15)
                    }
                    
                    HStack(spacing: 10) {
                        Group {
                            VerticalDataView(param: AirQualityParameters.O3.rawValue, value: 45.8)
                            VerticalDataView(param: AirQualityParameters.CO.rawValue, value: 283)
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
    }
}

struct VerticalDataView: View {
    
    let param: String
    let value: Double
    
    var body: some View {
        HStack {
            VerticalProgressView(progress: 0.3)
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

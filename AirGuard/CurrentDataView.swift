//
//  CurrentDataView.swift
//  AirGuard
//
//  Created by Mila B on 11.01.2024.
//

import SwiftUI

struct CurrentDataView: View {
    var body: some View {
        VStack(spacing: 15) {
            Text("Моя локация")
                .font(Font.system(size: 38))
                .bold()
                .padding(.bottom, 20)
            ZStack {
                CrescentProgressView(progress: 0.1)
                    .frame(width: 200, height: 200)
                VStack {
                    HStack {
                        Text("-1")
                            .font(Font.system(size: 28))
                            .bold()
                        Text("AQI")
                    }
                    HStack {
                        Text("😄")
                        Text("Отлично")
                    }
                }
                .padding(.top, -30)
            }
            
            HStack(spacing: 10) {
                VerticalDataView(param: "SO2", value: 1.1)
                VerticalDataView(param: "NO2", value: 3.6)
            }
            .frame(width: 250, height: 150)
            .padding(.leading, 20)
            
            HStack(spacing: 10) {
                VerticalDataView(param: "PM10", value: 1.4)
                VerticalDataView(param: "PM2.5", value: 0.5)
            }
            .frame(width: 250, height: 150)
            .padding(.leading, 20)
            
            HStack(spacing: 10) {
                VerticalDataView(param: "O3", value: 45.8)
                VerticalDataView(param: "CO", value: 283)
            }
            .frame(width: 250, height: 150)
            .padding(.leading, 20)
        }
    }
}

struct VerticalDataView: View {
    
    let param: String
    let value: Double
    
    var body: some View {
        HStack(spacing: 10) {
            VerticalProgressView(progress: 0.3)
            VStack(alignment: .leading) {
                Text("\(param) (μg/m3)")
                    .padding(.bottom, 2)
                Text("\(String(format: "%.2f", value))")
                    .font(Font.system(size: 28))
                    .bold()
            }
            .padding(.trailing, 20)
        }
    }
    
}

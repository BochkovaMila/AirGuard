//
//  DetailedInfoView.swift
//  AirGuard
//
//  Created by Mila B on 03.12.2023.
//

import SwiftUI

struct DetailedInfoView: View {
    @Environment(\.dismiss) var dismiss
    var chosenPoint: InfoPoint
    
    var body: some View {
        NavigationView {
            VStack(spacing: 5) {
                Text("Индекс качества воздуха: \(chosenPoint.aqData?.list[0].main.aqi ?? -1)")
                Text("SO2: \(chosenPoint.aqData?.list[0].components["so2"] ?? -1)")
                Text("NO2: \(chosenPoint.aqData?.list[0].components["no2"] ?? -1)")
                Text("PM10: \(chosenPoint.aqData?.list[0].components["pm10"] ?? -1)")
                Text("PM2.5: \(chosenPoint.aqData?.list[0].components["pm2_5"] ?? -1)")
                Text("O3: \(chosenPoint.aqData?.list[0].components["o3"] ?? -1)")
                Text("CO: \(chosenPoint.aqData?.list[0].components["co"] ?? -1)")
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "x.circle.fill")
                }
            }
        }
    }
}


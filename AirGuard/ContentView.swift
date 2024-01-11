//
//  ContentView.swift
//  AirGuard
//
//  Created by Mila B on 17.10.2023.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            Group {
                CurrentDataView()
                    .tabItem {
                        Label("Сегодня", systemImage: "chart.xyaxis.line")
                            .foregroundStyle(.black)
                    }
                MapView(viewModel: MapViewModel())
                    .tabItem {
                        Label("Карта", systemImage: "map")
                    }
                StatisticsView()
                    .tabItem {
                        Label("История", systemImage: "chart.bar.xaxis")
                    }
                ForecastView()
                    .tabItem {
                        Label("Прогноз", systemImage: "chart.line.uptrend.xyaxis")
                    }
                SettingsView()
                    .tabItem {
                        Label("Настройки", systemImage: "gearshape.fill")
                    }
            }
            .toolbarBackground(.visible, for: .tabBar)
        }
    }
}

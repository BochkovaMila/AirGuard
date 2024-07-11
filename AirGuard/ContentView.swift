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
                CurrentDataView(viewModel: CurrentDataViewModel())
                    .tabItem {
                        Label("Current", systemImage: "chart.xyaxis.line")
                            .foregroundStyle(.black)
                    }
                MapView(viewModel: MapViewModel())
                    .tabItem {
                        Label("Map", systemImage: "map")
                    }
                StatisticsView(viewModel: StatisticsViewModel())
                    .tabItem {
                        Label("History", systemImage: "chart.bar.xaxis")
                    }
                ForecastView(viewModel: ForecastViewModel())
                    .tabItem {
                        Label("Forecast", systemImage: "chart.line.uptrend.xyaxis")
                    }
                SettingsView(viewModel: CurrentDataViewModel())
                    .tabItem {
                        Label("Settings", systemImage: "gearshape.fill")
                    }
            }
            .toolbarBackground(.visible, for: .tabBar)
        }
    }
}

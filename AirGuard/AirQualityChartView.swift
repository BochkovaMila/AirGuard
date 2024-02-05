//
//  AirQualityChartView.swift
//  AirGuard
//
//  Created by Mila B on 31.01.2024.
//

import SwiftUI
import Charts

struct AirQualityChartView: View {
    let data: [AirQualityList]
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
        .chartXAxis(.automatic)
        .chartYAxis {
            AxisMarks(position: .leading)
        }
        .frame(height: 200)
        .padding()
    }
    
    func getChartColorForParam(_ param: String, _ value: Double) -> Color {
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


//
//  VerticalProgressView.swift
//  AirGuard
//
//  Created by Mila B on 15.01.2024.
//

import SwiftUI

struct VerticalProgressView: View {
    let param: String
    let value: Double
    
    var colorAndProgressTuple: (Color, Double) {
        return getColorAndProgressForSelectedParam()
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .bottom) {
                Rectangle()
                    .frame(width: 20, height: geometry.size.height)
                    .opacity(0.3)
                    .foregroundColor(colorAndProgressTuple.0)
                    .clipShape(Capsule())
                
                Rectangle()
                    .frame(
                        width: 20,
                        height: min(colorAndProgressTuple.1 * geometry.size.height,
                                    geometry.size.height)
                    )
                    .foregroundColor(colorAndProgressTuple.0)
                    .clipShape(Capsule())
                    .animation(.easeInOut, value: colorAndProgressTuple.1)
            }
        }
    }
    
    func getColorAndProgressForSelectedParam() -> (Color, Double) {
        
        if param == "SO2" {
            switch Int(value) {
            case 0..<20:
                return (Color.green, 0.1 + Double(value / 350))
            case 20..<80:
                return (Color.yellow, Double(value / 350))
            case 80..<250:
                return (Color.orange, Double(value / 350))
            case 250..<350:
                return (Color.red, Double(value / 350))
            case 350...Int.max:
                return (Color("darkRed"), 0.95)
            default:
                return (Color.gray, 0.0)
            }
        }
        else if param == "NO2" {
            switch Int(value) {
            case 0..<40:
                return (Color.green, 0.1 + Double(value / 200))
            case 40..<70:
                return (Color.yellow, Double(value / 200))
            case 70..<150:
                return (Color.orange, Double(value / 200))
            case 150..<200:
                return (Color.red, Double(value / 200))
            case 200...Int.max:
                return (Color("darkRed"), 0.95)
            default:
                return (Color.gray, 0.0)
            }
        }
        else if param == "PM10" {
            switch Int(value) {
            case 0..<20:
                return (Color.green, 0.1 + Double(value / 200))
            case 20..<50:
                return (Color.yellow, Double(value / 200))
            case 50..<100:
                return (Color.orange, Double(value / 200))
            case 100..<200:
                return (Color.red, Double(value / 200))
            case 200...Int.max:
                return (Color("darkRed"), 0.95)
            default:
                return (Color.gray, 0.0)
            }
        }
        else if param == "PM2.5" {
            switch Int(value) {
            case 0..<10:
                return (Color.green, 0.1 + Double(value / 75))
            case 10..<25:
                return (Color.yellow, Double(value / 75))
            case 25..<50:
                return (Color.orange, Double(value / 75))
            case 50..<75:
                return (Color.red, Double(value / 75))
            case 75...Int.max:
                return (Color("darkRed"), 0.95)
            default:
                return (Color.gray, 0.0)
            }
        }
        else if param == "O3" {
            switch Int(value) {
            case 0..<60:
                return (Color.green, 0.1 + Double(value / 180))
            case 60..<100:
                return (Color.yellow, Double(value / 180))
            case 100..<140:
                return (Color.orange, Double(value / 180))
            case 140..<180:
                return (Color.red, Double(value / 180))
            case 180...Int.max:
                return (Color("darkRed"), 0.95)
            default:
                return (Color.gray, 0.0)
            }
        }
        else if param == "CO" {
            switch Int(value) {
            case 0..<440:
                return (Color.green, 0.1 + Double(value / 15400))
            case 440..<9400:
                return (Color.yellow, 0.2 + Double(value / 15400))
            case 9400..<12400:
                return (Color.orange, Double(value / 15400))
            case 12400..<15400:
                return (Color.red, Double(value / 15400))
            case 15400...Int.max:
                return (Color("darkRed"), 0.95)
            default:
                return (Color.gray, 0.0)
            }
        }
        else { return (Color.gray, 0.0) }
    }
}


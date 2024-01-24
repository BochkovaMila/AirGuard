//
//  CrescentProgressView.swift
//  AirGuard
//
//  Created by Mila B on 12.01.2024.
//

import SwiftUI

struct CrescentProgressView: View {
    
    let value: Int
    
    var colorAndProgressTuple: (Color, Double) {
        return getColorAndProgress(value)
    }
    
    var body: some View {
        ZStack {
            Circle()
                .trim(from: 0, to: 0.5)
                .stroke(
                    colorAndProgressTuple.0.opacity(0.5),
                    style: StrokeStyle(
                        lineWidth: 20,
                        lineCap: .round
                    )
                )
                .rotationEffect(.degrees(-180))
            Circle()
                .trim(from: 0, to: colorAndProgressTuple.1)
                .stroke(
                    colorAndProgressTuple.0,
                    style: StrokeStyle(
                        lineWidth: 20,
                        lineCap: .round
                    )
                )
                .rotationEffect(.degrees(-180))
                .animation(.easeInOut, value: colorAndProgressTuple.1)
        }
    }
    
    private func getColorAndProgress(_ value: Int) -> (Color, Double) {
        switch value {
        case 1:
            return (Color.green, 0.1)
        case 2:
            return (Color.yellow, 0.2)
        case 3:
            return (Color.orange, 0.3)
        case 4:
            return (Color.red, 0.4)
        case 5:
            return (Color("darkRed"), 0.5)
        default:
            return (Color.gray, 0.0)
        }
    }
}


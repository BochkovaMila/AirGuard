//
//  View+Extension.swift
//  AirGuard
//
//  Created by Mila B on 03.12.2023.
//

import SwiftUI

extension View {
    func hidden(_ shouldHide: Bool) -> some View {
        opacity(shouldHide ? 0 : 1)
    }
    
    func getChartColorForIndex(_ value: Int) -> Color {
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

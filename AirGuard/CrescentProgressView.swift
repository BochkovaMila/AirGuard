//
//  CrescentProgressView.swift
//  AirGuard
//
//  Created by Mila B on 12.01.2024.
//

import SwiftUI

struct CrescentProgressView: View {
    
    let progress: Double
    
    var body: some View {
        ZStack {
            Circle()
                .trim(from: 0, to: 0.5)
                .stroke(
                    Color.pink.opacity(0.5),
                    style: StrokeStyle(
                        lineWidth: 20,
                        lineCap: .round
                    )
                )
                .rotationEffect(.degrees(-180))
            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    Color.pink,
                    style: StrokeStyle(
                        lineWidth: 20,
                        lineCap: .round
                    )
                )
                .rotationEffect(.degrees(-180))
                .animation(.easeInOut, value: progress)
        }
    }
}

#Preview {
    CrescentProgressView(progress: 0.3)
}

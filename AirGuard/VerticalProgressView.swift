//
//  VerticalProgressView.swift
//  AirGuard
//
//  Created by Mila B on 15.01.2024.
//

import SwiftUI

struct VerticalProgressView: View {
    let progress: CGFloat
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .bottom) {
                Rectangle()
                    .frame(width: 20, height: geometry.size.height)
                    .opacity(0.3)
                    .foregroundColor(.pink)
                    .clipShape(Capsule())
                
                Rectangle()
                    .frame(
                        width: 20,
                        height: min(progress * geometry.size.height,
                                    geometry.size.height)
                    )
                    .foregroundColor(.pink)
                    .clipShape(Capsule())
            }
        }
    }
}

#Preview {
    VerticalProgressView(progress: 0.2)
}

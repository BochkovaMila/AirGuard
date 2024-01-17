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
}

extension View {
    func animate(using animation: Animation = .easeInOut(duration: 1), _ action: @escaping () -> Void) -> some View {
        onAppear {
            withAnimation(animation) {
                action()
            }
        }
    }
}

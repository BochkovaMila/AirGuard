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

//
//  AirGuardApp.swift
//  AirGuard
//
//  Created by Mila B on 17.10.2023.
//

import SwiftUI

@main
struct AirGuardApp: App {
    
    init() {
        UILabel.appearance(whenContainedInInstancesOf: [UINavigationBar.self]).adjustsFontSizeToFitWidth = true
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

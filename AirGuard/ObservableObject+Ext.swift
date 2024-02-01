//
//  ObservableObject+Ext.swift
//  AirGuard
//
//  Created by Mila B on 01.02.2024.
//

import Foundation
import UIKit

extension ObservableObject {
    func present(_ alert: UIAlertController, animated: Bool = true, completion: (() -> Void)? = nil) {
        
        let keyWindow = UIApplication
                            .shared
                            .connectedScenes
                            .compactMap { ($0 as? UIWindowScene)?.keyWindow }
                            .last
        keyWindow?.rootViewController?.present(alert, animated: animated, completion: completion)
    }
}

//
//  AGError.swift
//  AirGuard
//
//  Created by Mila B on 17.10.2023.
//

import Foundation

enum AGError: String, Error {
    
    case invalidToken       = "This token is invalid. Please try again."
    case unableToComplete   = "Unable to complete this request. Please check your internet connection."
    case invalidResponse    = "Invalid response from server. Please try again."
    case invalidData        = "Invalid data from server. Please try again."
}

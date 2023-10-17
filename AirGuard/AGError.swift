//
//  AGError.swift
//  AirGuard
//
//  Created by Mila B on 17.10.2023.
//

import Foundation

enum AGError: String, Error {
    
    case invalidToken       = "This token created an invalid request. Please try again."
    case unableToComplete   = "Unable to complete your request. Please check your internet connection."
    case invalidResponse    = "Invalid response from the server. Please try again."
    case invalidData        = "The data received from the server was invalid. Please try again."
    case unableToFavorite   = "There was an error favoriting this place. Please try again."
    case alreadyInFavorites = "You have already favorited this place."
}

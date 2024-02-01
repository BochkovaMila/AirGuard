//
//  AGError.swift
//  AirGuard
//
//  Created by Mila B on 17.10.2023.
//

import Foundation

enum AGError: String, Error {
    
    case invalidToken       = "Этот токен создал недопустимый запрос. Пожалуйста, попробуйте снова."
    case unableToComplete   = "Не удалось выполнить ваш запрос. Пожалуйста, проверьте ваше подключение к Интернету."
    case invalidResponse    = "Неверный ответ от сервера. Пожалуйста, попробуйте снова."
    case invalidData        = "Данные, полученные с сервера, оказались недействительными. Пожалуйста, попробуйте снова."
}

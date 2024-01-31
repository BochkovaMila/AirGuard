//
//  NetworkManager.swift
//  AirGuard
//
//  Created by Mila B on 17.10.2023.
//

import Foundation

class NetworkManager {
    
    static let shared   = NetworkManager()
    private let token   = NetworkingConstants.token
    private let baseURL = "https://api.openweathermap.org/data/2.5/"
    let decoder         = JSONDecoder()
    
    private init() {
        decoder.keyDecodingStrategy  = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601
    }
    
    func getData(latitude: Double, longitude: Double) async throws -> AirQualityData {
        let endpoint = baseURL + "air_pollution?lat=\(latitude)&lon=\(longitude)&appid=\(token)"
        
        guard let url = URL(string: endpoint) else {
            throw AGError.invalidToken
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw AGError.invalidResponse
        }
        
        do {
            return try decoder.decode(AirQualityData.self, from: data)
        } catch {
            throw AGError.invalidData
        }
    }
    
    func getForecastData(latitude: Double, longitude: Double) async throws -> AirQualityData {
        let endpoint = baseURL + "air_pollution/forecast?lat=\(latitude)&lon=\(longitude)&appid=\(token)"
        
        guard let url = URL(string: endpoint) else {
            throw AGError.invalidToken
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw AGError.invalidResponse
        }
        
        do {
            return try decoder.decode(AirQualityData.self, from: data)
        } catch {
            throw AGError.invalidData
        }
    }
    
    func getHistoricalData(lat: Double, lon: Double, start: Int, end: Int) async throws -> AirQualityData {
        let endpoint = baseURL + "air_pollution/history?lat=\(lat)&lon=\(lon)&start=\(start)&end=\(end)&appid=\(token)"
        
        guard let url = URL(string: endpoint) else {
            throw AGError.invalidToken
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw AGError.invalidResponse
        }
        
        do {
            return try decoder.decode(AirQualityData.self, from: data)
        } catch {
            throw AGError.invalidData
        }
    }
}

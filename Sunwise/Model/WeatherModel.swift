//
//  WeatherModel.swift
//  Sunwise
//
//  Created by Ariel Waraney on 21/12/22.
//

import Foundation

struct WeatherResponse: Codable {
    let lat: Float
    let lon: Float
    let timezone: String
    let current: CurrentWeather
    let hourly: [HourlyWeather]
    let daily: [DailyWeather]
}

struct CurrentWeather: Codable {
    let dt: Int
    let sunrise: Int
    let sunset: Int
    let temp: Float
    let uvi: Float
    let clouds: Int
    let weather: [TheWeather]
}

struct TheWeather: Codable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}

struct HourlyWeather: Codable {
    let dt: Int
    let temp: Float
    let uvi: Float
    let clouds: Int
    let weather: [TheWeather]
}

struct DailyWeather: Codable {
    let dt: Int
    let sunrise: Int
    let sunset: Int
    let temp: Temp
    let weather: [TheWeather]
    let clouds: Int
    let uvi: Float
}

struct Temp: Codable {
    let min: Float
    let max: Float
}

//MARK: - Location Weather Geocoding

struct LocationCoordinate: Codable {
    let name: String
    let lat: Float
    let lon: Float
    let country: String
    let state: String
}

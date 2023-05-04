//
//  Weather.swift
//  WeatherList
//
//  Created by ybKim on 2023/04/28.
//

import Foundation

enum weatherImage: String {
    case Thunderstorm = "11d"
    case Drizzle = "09d"
    case Rain = "10d"
    case Snow = "13d"
    case Fog = "50d"
    case Clear = "01d"
    case Clouds1 = "02d"
    case Clouds2 = "03d"
    case Clouds3 = "04d"
}

struct Weather: Codable {
    var list: [WeatherList]?
}

struct WeatherList: Codable {
    let dt: Int?
    let temp: Temp?
    let weatherInfo: [WeatherInfo]?

    enum CodingKeys: String, CodingKey {
        case dt, temp
        case weatherInfo = "weather"
    }
}

struct Temp: Codable {
    let min: Float?
    let max: Float?

    enum CodingKeys: String, CodingKey {
        case min, max
    }
}

struct WeatherInfo: Codable {
    let id: Int?
    let main: String?
    let description: String?
    let icon: String?

    enum CodingKeys: String, CodingKey {
        case id, main, description, icon
    }
}


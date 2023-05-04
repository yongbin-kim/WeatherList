//
//  Geocoding.swift
//  WeatherList
//
//  Created by ybKim on 2023/05/02.
//

import Foundation

struct Geocoding: Codable {
    let name: String?
    let lat: Double?
    let lon: Double?
    
    enum CodingKeys: String, CodingKey {
        case name, lat, lon
    }
}

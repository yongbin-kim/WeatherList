//
//  extension.swift
//  WeatherList
//
//  Created by ybKim on 2023/05/03.
//

import Foundation

extension String {
    var toStrWeatherImage: String {
        var strIcon = "Clear"
        let weatherIcon: weatherImage = weatherImage(rawValue: self) ?? .Clear
        
        switch weatherIcon {
        case .Clear:
            strIcon = "Clear"
        case .Thunderstorm:
            strIcon = "Thunderstorm"
        case .Drizzle:
            strIcon = "Drizzle"
        case .Rain:
            strIcon = "Rain"
        case .Snow:
            strIcon = "Snow"
        case .Fog:
            strIcon = "Fog"
        case .Clouds1:
            strIcon = "Cloud1"
        case .Clouds2:
            strIcon = "Cloud2"
        case .Clouds3:
            strIcon = "Cloud3"
        }
        
        return strIcon
    }
    
    func stringToDate(date: Date) -> String {
        let relativeDateFormatter = DateFormatter()
        relativeDateFormatter.timeStyle = .none
        relativeDateFormatter.dateStyle = .medium
        relativeDateFormatter.locale = Locale(identifier: "en_US")
        relativeDateFormatter.doesRelativeDateFormatting = true
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.dateFormat = "EEE d MMM"
        
        var strWeatherDate = ""
        let string = relativeDateFormatter.string(from: date)
        if let _ = string.rangeOfCharacter(from: .decimalDigits) {
            strWeatherDate = dateFormatter.string(from: date)
        } else {
            strWeatherDate = string
        }
        
        return strWeatherDate
    }
}

extension Float {
    var toCelsius: Float {
        return (self - 273.15)
    }
}

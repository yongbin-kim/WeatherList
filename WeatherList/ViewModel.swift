//
//  ViewModel.swift
//  WeatherList
//
//  Created by ybKim on 2023/04/28.
//

import Foundation
import Alamofire

class ViewModel {
    var sections: [WeatherSection] = []
    let geoList = ["Seoul", "London,GB", "Chicago,Us"]
    
    let UrlStringGeo:String = "https://api.openweathermap.org/geo/1.0/direct"
    let UrlStringDaily:String = "https://api.openweathermap.org/data/2.5/forecast/daily"
    let apiKey = "ec1890bdba5390c6904ef86e729ed905"
    
    func getGeoData(_ strQuery: String, completion: @escaping(_ success: [Geocoding]?, _ fail: Error?) -> Void) {
        let param: Parameters = [
            "q":        strQuery,
            "appid":    apiKey,
            "limit":    "1"
        ]
        
        AF.request(self.UrlStringGeo, method: .get, parameters: param, encoding: URLEncoding.default, headers: nil)
            .responseData{ response in
                switch response.result {
                case .success(let data):
                    do {
                        let decodeData = try JSONDecoder().decode([Geocoding].self, from: data)
                        
                        completion(decodeData, nil)
                    } catch let error {
                        completion(nil, error)
                    }
                case .failure(let error):
                    completion(nil, error)
                }
            }
    }
    
    func getData(_ location: Geocoding, completion:  @escaping(_ success: Weather?, _ fail: Error?) -> Void) {
        let param: Parameters = [
            "lat":      location.lat ?? 0.0,
            "lon":      location.lon ?? 0.0,
            "appid":    apiKey,
            "lang":     "kr"
        ]
        
        AF.request(self.UrlStringDaily, method: .get, parameters: param, encoding: URLEncoding.default, headers: nil)
            .responseData{ response in
                switch response.result {
                case .success(let data):
                    do {
                        let decodeData = try JSONDecoder().decode(Weather.self, from: data)
                        
                        completion(decodeData, nil)
                    } catch let error {
                        print("\(error)")
                        completion(nil, error)
                    }
                case .failure(let error):
                    completion(nil, error)
                }
            }
    }
}

class WeatherSection {
    let location: String
    var weather: [WeatherList]?
    
    init(location: String, weather: [WeatherList]) {
        self.location = location
        self.weather = weather
    }
}

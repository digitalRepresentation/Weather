//
//  Forecast.swift
//  WeatherJapan
//
//  Created by 金宝ヨン on 2020/10/27.
//  Copyright © 2020 kimjinyoung. All rights reserved.
//

import Foundation

struct ForecastData {
    let date: Date
    let description: String
    let icon: String
    let temp: Float64
}

struct Forecast: Codable {
    struct List: Codable {
        struct Main: Codable {
            let temp: Float64
        }
        struct Weather: Codable {
            let description: String
            let icon: String
        }
        let dt_txt: String
        let main: Main
        let weather: [Weather]
        }
    
    let list: [List]
}

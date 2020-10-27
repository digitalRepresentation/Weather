//
//  WeatherSummary.swift
//  WeatherJapan
//
//  Created by 金宝ヨン on 2020/10/27.
//  Copyright © 2020 kimjinyoung. All rights reserved.
//

import Foundation

struct WeatherSummary: Codable {
    struct Weather: Codable {
        // 英語天気名
        let main: String
        // 日本語天気名
        let description: String
        // 写真iconコード
        let icon: String
    }
    
    struct Main: Codable {
        let temp: Float64
        let temp_min: Float64
        let temp_max: Float64
    }

    
    let weather: [Weather]
    let main: Main
    let cod: Int
}

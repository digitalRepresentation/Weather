//
//  WeatherDataSource.swift
//  WeatherJapan
//
//  Created by 金宝ヨン on 2020/10/27.
//  Copyright © 2020 kimjinyoung. All rights reserved.
//

import Foundation

class WeatherDataSource {
    static let shared = WeatherDataSource()
    private init() {}
    
    var summary: WeatherSummary?
    var forecast: Forecast?
    
    func fetchSummary(q:String, completion: @escaping() -> ()) {
        let apiUrl = "http://api.openweathermap.org/data/2.5/weather?q=\(q)&appid=\(appKey)&lang=ja&units=metric"

        let url = URL(string: apiUrl)!

        let session = URLSession.shared

        let task = session.dataTask(with: url) { (data, response, error) in
            
            defer {
                DispatchQueue.main.async {
                    completion()
                }
            }
            
            
            if let error = error {
                print(error)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("Invalid Response")
                return
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                print("\(httpResponse.statusCode)")
                return
            }
            
            // 바인딩
            guard let data = data else {
                fatalError("Invalid data")
            }
            
            do {
                
                let decoder = JSONDecoder()
                self.summary = try decoder.decode(WeatherSummary.self, from: data)
                
                
            } catch {
                print (error)
            }
            
            
        }

        task.resume()

    }
    
    func fetchForecast(q:String, completion: @escaping() -> ()) {
        let apiUrl = "http://api.openweathermap.org/data/2.5/forecast?q=\(q)&units=metric&lang=ja&APPID=\(appKey)&cnt=10"

        let url = URL(string: apiUrl)!

        let session = URLSession.shared

        let task = session.dataTask(with: url) { (data, response, error) in
            
            if let error = error {
                print(error)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("Invalid Response")
                return
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                print("\(httpResponse.statusCode)")
                return
            }
            
            // 바인딩
            guard let data = data else {
                fatalError("Invalid data")
            }
            
            do {
                
                let decoder = JSONDecoder()
                self.forecast = try decoder.decode(Forecast.self, from: data)
                
                //forecast.list[0].dt_txt
                
                
            } catch {
                print (error)
            }
            
            
        }

        task.resume()

    }
}

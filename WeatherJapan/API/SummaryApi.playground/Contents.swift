import UIKit

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

let apiUrl = "http://api.openweathermap.org/data/2.5/weather?q=Tokyo&appid=af93762fb49b4075bd2844d989ef0f56&lang=ja&units=metric"

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
        let summary = try decoder.decode(WeatherSummary.self, from: data)
        
        summary.cod
        
        summary.weather.first?.description
        summary.weather.first?.icon
        
        summary.main.temp
        summary.main.temp_min
        summary.main.temp_max
        
    } catch {
        print (error)
    }
    
    
}

task.resume()

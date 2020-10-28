import UIKit

struct Forecast: Codable {
    struct List: Codable {
        struct Main: Codable {
            let temp: Float64
        }
        struct Weather: Codable {
            let description: String
            let icon: String
        }
        let main: Main
        let weather: [Weather]
        let dt_txt: String
    }
    let list: [List]
}

let apiUrl = "http://api.openweathermap.org/data/2.5/forecast?q=Tokyo&units=metric&lang=ja&APPID=af93762fb49b4075bd2844d989ef0f56&cnt=10"

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
        let forecast = try decoder.decode(Forecast.self, from: data)
        
        forecast.list
        forecast.list.index(after: 2)
        forecast.list.index(after: 3)
        forecast.list.index(after: 4)
        forecast.list[0].weather.first?.icon
        forecast.list[1].main.temp
        
    } catch {
        print (error)
    }
    
    
}

task.resume()

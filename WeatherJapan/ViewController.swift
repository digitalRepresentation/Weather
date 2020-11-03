//
//  ViewController.swift
//  WeatherJapan
//
//  Created by 金宝 on 2020/10/11.
//  Copyright © 2020 kimjinyoung. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
    
    lazy var locationManager: CLLocationManager = {
       let m = CLLocationManager()
        m.delegate = self
        return m
    }()

    // 日本語で日付
    let dateFormatter: DateFormatter = {
        let f = DateFormatter()
        f.locale = Locale(identifier: "ja_JP")
        return f
    }()
    
    @IBOutlet weak var listTableView: UITableView!
    
    //一番上位のラベル
    @IBOutlet weak var locationLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        listTableView.backgroundColor = UIColor.clear
        listTableView.separatorStyle = .none
        listTableView.showsVerticalScrollIndicator = false
        
        WeatherDataSource.shared.fetchSummary(q:"Tokyo"){
            [weak self]
            in
            self?.listTableView.reloadData()
        }
        
        WeatherDataSource.shared.fetchForecast(q:"Tokyo"){
            [weak self]
            in
            self?.listTableView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        locationLabel.text = "アップデート中。。。"
        
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            //初期表示か許可をもらわない場合
            case .notDetermined:
                locationManager.requestWhenInUseAuthorization()
            case .authorizedAlways, .authorizedWhenInUse:
                updateCurrentLocation()
            case .denied, .restricted:
                show(message: "位置サービスが活性になってないです。")
            @unknown default:
                fatalError()
            }
        } else {
            show(message: "位置サービスが活性になってないです。")
        }
        
    }
    
    var topInset: CGFloat = 0.0

    //View配置が完了できたら呼び出す。
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        if topInset == 0.0 {
            let first = IndexPath(row: 0, section: 0)
            if let cell = listTableView.cellForRow(at: first) {
                topInset = listTableView.frame.height - cell.frame.height

                var inset = listTableView.contentInset
                inset.top = topInset
                listTableView.contentInset = inset
            }
        }
    }


}

extension ViewController: CLLocationManagerDelegate {
    func updateCurrentLocation() {
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations location: [CLLocation]) {
        manager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        show(message: error.localizedDescription)
        manager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            updateCurrentLocation()
        default:
            break
        }
    }
}


//現在時間、３時間ごとの二つセッションを表示する。
//※基本的にはViewControllは１個の画面を表示する。
extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 10
            // WeatherDataSource.shared.forecast?.list.count ?? 0
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: SummaryTableViewCell.identifier, for: indexPath) as! SummaryTableViewCell
        
            if let data = WeatherDataSource.shared.summary?.weather.first {
                cell.weatherImageView.image = UIImage(named: data.icon)
                cell.statusLabel.text = data.description
            }
            
            if let data = WeatherDataSource.shared.summary?.main {
                cell.minMaxLabel.text = "最高　\(data.temp_max)° 最低　\(data.temp_min)°"
                cell.currentTemperatureLabel.text = "\(data.temp)°"
            }
            
            
        return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: ForecastTableViewCell.identifier, for: indexPath) as! ForecastTableViewCell
        
            
        let target = WeatherDataSource.shared.forecast?.list[indexPath.row] ?? nil
                //WeatherDataSource.shared.forecastList[indexPath.row]
            //forecast?.list[indexPath.row]
            
            dateFormatter.dateFormat = "M.d (E)"
            cell.dateLabel.text = dateFormatter.string(for: target?.dt_txt)

            dateFormatter.dateFormat = "HH:00"
            cell.timeLabel.text = dateFormatter.string(for: target?.dt_txt)

            cell.weatherImageView.image = UIImage(named: target?.weather.first!.icon ?? "0")

            cell.statusLabel.text = target?.weather.first?.description

            cell.temperatureLabel.text = "\(target?.main.temp ?? 00)°"

        return cell
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
}

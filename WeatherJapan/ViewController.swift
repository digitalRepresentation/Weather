//
//  ViewController.swift
//  WeatherJapan
//
//  Created by 金宝ヨン on 2020/10/11.
//  Copyright © 2020 kimjinyoung. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    @IBOutlet weak var listTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        WeatherDataSource.shared.fetchSummary(q:"Tokyo"){
            [weak self]
            in
            self?.listTableView.reloadData()
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
            return 0
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
        
        return cell
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
}

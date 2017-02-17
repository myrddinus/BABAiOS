//
//  ViewController.swift
//  BABA
//
//  Created by Guihal Gwenn on 16/02/17.
//  Copyright © 2017 Guihal Gwenn. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    let weatherService = WeatherService()
    var weatherModel:WeatherModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Metéo ..."
        
        // register cell
        let nib = UINib(nibName: "WeatherCellTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "WeatherCellTableViewCell")
        
        // setup tableView
        tableView.dataSource = self
        tableView.delegate = self
        
        // service
        weatherService.get16DaysWeather { [weak self] (response) in
            switch response {
            
            case .success(let weatherModel):
                self?.title = "Metéo \(weatherModel.cityName)"
                self?.weatherModel = weatherModel
                self?.tableView.reloadData()
            
            case .error(let error):
                print("Error occured \(error)")
            }
        }
    }
}

extension ViewController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherModel?.weatherDays.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherCellTableViewCell") as? WeatherCellTableViewCell,
            let weatherDay = weatherModel?.weatherDays[indexPath.row] else {
                return UITableViewCell()
        }
        
        let weatherCellAdapter = WeatherCellAdapter(weatherDay: weatherDay)
        cell.update(weatherCellAdapter)
        return cell

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}

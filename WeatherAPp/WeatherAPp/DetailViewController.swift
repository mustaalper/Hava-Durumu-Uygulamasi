//
//  DetailViewController.swift
//  WeatherAPp
//
//  Created by MAA on 17.03.2022.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var labelCityName: UILabel!
    @IBOutlet weak var labelTemp: UILabel!
    @IBOutlet weak var imageViewicon: UIImageView!
    @IBOutlet weak var labelMaxTemp: UILabel!
    @IBOutlet weak var labelMinTemp: UILabel!
    @IBOutlet weak var labelHum: UILabel!
    @IBOutlet weak var labelWindSpeed: UILabel!
    @IBOutlet weak var labelTitle: UILabel!
    
    var city = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let cityNameCap = city.capitalized
        
        labelCityName.text = cityNameCap
        getTodayResult(cityName: city)
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "bg1")!)
        // Do any additional setup after loading the view.
    }
    
    func getTodayResult(cityName:String) {
        
        if let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?q=\(cityName)&appid=8d7b6ef9e4a5321d84f640c138896c93") {
            let request = URLRequest(url: url)
            
            let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
                
                if error == nil {
                    
                    if let incomingData = data {
                        
                        do {
                            let jsonResult = try JSONSerialization.jsonObject(with: incomingData, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
                            if let main = jsonResult["main"] as? NSDictionary {
                                
                                if let temp = main["temp"] as? Double {
                                    let state = (Int)(temp - 273.15)
                                    
                                    let maxTemp = main["temp_max"] as! Double
                                    let maxState = (Int)(maxTemp - 273.15)
                                    
                                    let minTemp = main["temp_min"] as! Double
                                    let minState = (Int)(minTemp - 273.15)
                                    
                                    let hum = main["humidity"] as! Int
                                    
                                    DispatchQueue.main.sync(execute: {
                                        //print(jsonResult)
                                        self.labelTemp.text = "\(String(state))°"
                                        self.labelMaxTemp.text = "\(String(maxState))°"
                                        self.labelMinTemp.text = "\(String(minState))°"
                                        self.labelHum.text = "%\(String(hum))"
                                    })
                                }
                                
                                if let weather = jsonResult["weather"] as? [Any] {
                                    
                                    for i in weather {
                                        if let object = i as? [String:Any] {
                                            
                                            if let icon = object["icon"] as? String {
                                                self.title(icon: icon)
                                                DispatchQueue.main.sync(execute: {
                                                    self.imageViewicon.image = UIImage(named: "\(icon)")
                                                })
                                            }
                                        }
                                    }
                                }
                                
                                if let wind = jsonResult["wind"] as? NSDictionary {
                                    if let wSpeed = wind["speed"] as? Double {
                                        DispatchQueue.main.sync(execute: {
                                            self.labelWindSpeed.text = "\(String(wSpeed))"
                                        })
                                    }
                                }
                            }
                        } catch  {
                            print(error.localizedDescription)
                        }
                    }
                }
            }
            task.resume()
        }
    }
    
    func title(icon:String) {
        
        func exp (){
            DispatchQueue.main.sync(execute: {
                self.labelTitle.text = title
            })
        }
        
        var title = String()
        switch icon {
        case "01d":
            title = "Hava açık"
            exp()
        case "01n":
            title = "Hava açık"
            exp()
        case "02d":
            title = "Az bulutlu"
            exp()
        case "02n":
            title = "Az bulutlu"
            exp()
        case "03d":
            title = "Bulutlu"
            exp()
        case "03n":
            title = "Bulutlu"
            exp()
        case "04d":
            title = "Parçalı bulutlu"
            exp()
        case "04n":
            title = "Parçalı bulutlu"
            exp()
        case "09d":
            title = "Sağanak yağışlı"
            exp()
        case "09n":
            title = "Sağanak yağışlı"
            exp()
        case "10d":
            title = "Yağmurlu"
            exp()
        case "10n":
            title = "Yağmurlu"
            exp()
        case "11d":
            title = "Fırtınalı"
            exp()
        case "11n":
            title = "Fırtınalı"
            exp()
        case "13d":
            title = "Kar yağışlı"
            exp()
        case "13n":
            title = "Kar yağışlı"
            exp()
        case "50d":
            title = "Sisli"
            exp()
        case "50n":
            title = "Sisli"
            exp()
        default:
            print("*\(title)*")
        }
    }

}

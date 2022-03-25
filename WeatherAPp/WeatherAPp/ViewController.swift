//
//  ViewController.swift
//  WeatherAPp
//
//  Created by MAA on 17.03.2022.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
    
    var locationManager:CLLocationManager = CLLocationManager()

    @IBOutlet weak var textFieldCityName: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    
    @IBOutlet weak var labelCity: UILabel!
    @IBOutlet weak var labelMaxTemp: UILabel!
    @IBOutlet weak var labelMinTemp: UILabel!
    @IBOutlet weak var labelHum: UILabel!
    @IBOutlet weak var labelWSpeed: UILabel!
    @IBOutlet weak var labelTemp: UILabel!
    @IBOutlet weak var imageViewicon: UIImageView!
    
    @IBOutlet weak var labelTitle: UILabel!
    
    
    @IBOutlet weak var labelLat: UILabel!
    @IBOutlet weak var labelLon: UILabel!
    
    var latitude = Double()
    var longitude = Double()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        locationManager.delegate = self
        
        locationManager.requestWhenInUseAuthorization()
        
        locationManager.startUpdatingLocation()
        
        labelLon.isHidden = true
        labelLat.isHidden = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        
        view.addGestureRecognizer(tap)
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "bg1")!)
        
        
    }
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        label()
    }
    
    func label() {
        
        if let lat = Double(labelLat.text!), let lon = Double(labelLon.text!) {
            getTodayResult(lat: lat, lon: lon)
        } else {
            print("*boş*")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        textFieldCityName.text = ""
    }
    
    func getTodayResult(lat:Double, lon:Double) {
        
        if let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&appid=8d7b6ef9e4a5321d84f640c138896c93") {
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
                                
                                if let wind = jsonResult["wind"] as? NSDictionary {
                                    
                                    if let wSpeed = wind["speed"] as? Double {
                                        DispatchQueue.main.sync(execute: {
                                            self.labelWSpeed.text = "\(String(wSpeed))"
                                        })
                                    }
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
                                
                                if let name = jsonResult["name"] as? String {
                                        DispatchQueue.main.sync(execute: {
                                            self.labelCity.text = name
                                        })
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

    @IBAction func buttonSearch(_ sender: Any) {
        
        let cities = ["","adana", "adıyaman", "afyonkarahisar", "ağrı", "aksaray", "amasya", "ankara", "antalya", "ardahan", "artvin", "aydın", "balıkesir", "bartın", "batman", "bayburt", "bilecik", "bingöl", "bitlis", "bolu", "burdur", "bursa", "çanakkale", "çankırı", "çorum", "denizli", "diyarbakır", "düzce", "edirne", "elazığ", "erzincan", "erzurum", "eskişehir", "gaziantep", "giresun", "gümüşhane", "hakkâri", "hatay", "ığdır", "ısparta", "istanbul", "izmir", "kahramanmaraş", "karabük", "karaman", "kars", "kastamonu", "kayseri", "kilis", "kırıkkale", "kırklareli", "kırşehir", "kocaeli", "konya", "kütahya", "malatya", "manisa", "mardin", "mersin", "muğla", "muş", "nevşehir", "niğde", "ordu", "osmaniye", "rize", "sakarya", "samsun", "şanlıurfa", "siirt", "sinop", "sivas", "şırnak", "tekirdağ", "tokat", "trabzon", "tunceli", "uşak", "van", "yalova", "yozgat", "zonguldak"]
        
        var city = textFieldCityName.text ?? ""
    
        let lowercasedCity = city.lowercased()
        
        if city.isEmpty {
            
            let alert = UIAlertController(title: "Hata", message: "Lütfen bir şehir giriniz!", preferredStyle: .alert)
            
            let cancelButton = UIAlertAction(title: "İptal", style: .cancel, handler: nil)
            
            alert.addAction(cancelButton)
            
            self.present(alert, animated: true, completion: nil)
            
        } else {
            
            city = lowercasedCity
            if cities.firstIndex(of: "\(city)") ?? 0 > 0 {
                let vc = self.storyboard?.instantiateViewController(identifier: "DetailVC") as! DetailViewController
                
                vc.city = city
                
                self.show(vc, sender: nil)
            } else {
                
                let alert = UIAlertController(title: "Hata", message: "Girdiğiniz şehir bulunamadı!", preferredStyle: .alert)
                
                let cancelButton = UIAlertAction(title: "İptal", style: .cancel, handler: nil)
                
                alert.addAction(cancelButton)
                
                self.present(alert, animated: true, completion: nil)
            }
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

extension ViewController:CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let lastLoca:CLLocation = locations[locations.count - 1]
        
        self.labelLat.text = "\(lastLoca.coordinate.latitude)"
        self.labelLon.text = "\(lastLoca.coordinate.longitude)"
    }
}


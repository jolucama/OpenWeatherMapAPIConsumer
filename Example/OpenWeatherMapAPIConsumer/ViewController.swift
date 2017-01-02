//
//  ViewController.swift
//  OpenWeatherMapAPIConsumer
//
//  Created by Jose Luis Cardosa on 12/24/2016.
//  Copyright (c) 2016 Jose Luis Cardosa. All rights reserved.
//

import UIKit
import CoreLocation
import OpenWeatherMapAPIConsumer

class ViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var degrees: UILabel!
    @IBOutlet weak var pressure: UILabel!
    @IBOutlet weak var humidity: UILabel!
    @IBOutlet weak var tempMax: UILabel!
    @IBOutlet weak var tempMin: UILabel!
    @IBOutlet weak var windSpeed: UILabel!
    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var location: UILabel!
    
    var backgroundImageView: UIImageView!
    
    var apiKey : String!
    var weatherAPI : OpenWeatherMapAPI!
    
    var locationManager: CLLocationManager = CLLocationManager()
    var locationObject: CLLocation?
    
    var responseWeatherApi : ResponseOpenWeatherMapProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let now = Date()
        self.datePicker.setDate(now, animated: true)
        self.datePicker.minimumDate = now
        self.datePicker.maximumDate = Calendar.current.date(byAdding: .day, value: 5, to: now)
        self.apiKey = PlistManager.getValue(forKey: "APIWeatherKey") as! String
        
        //Location Services
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        weatherAPI = OpenWeatherMapAPI(apiKey: self.apiKey, forType: OpenWeatherMapType.Current)
        weatherAPI.setTemperatureUnit(unit: TemperatureFormat.Celsius)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        if self.locationObject == nil {
            self.locationObject = locations[locations.count - 1]
            let currentLatitude: CLLocationDistance = self.locationObject!.coordinate.latitude
            let currentLongitude: CLLocationDistance = self.locationObject!.coordinate.longitude
            weatherAPI.weather(byLatitude: currentLatitude, andLongitude: currentLongitude)
            weatherAPI.performWeatherRequest(completionHandler:{(data: Data?, urlResponse: URLResponse?, error: Error?) in
                NSLog("Response Current Weather Done")
                if (error != nil) {
                    self.showAddOutfitAlert(message: "Error fetching the current weather", error: error)
                } else {
                    do {
                        self.responseWeatherApi = try CurrentResponseOpenWeatherMap(data: data!)
                        DispatchQueue.main.async { [unowned self] in
                            self.updateViewWithResponseWeatherAPI()
                        }
                    } catch let error as Error {
                        self.showAddOutfitAlert(message: "Error fetching the current weather", error: error)
                    }
                }
            })
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        NSLog("Impossible to get the location of the device")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func datePickerAction(_ sender: UIDatePicker) {
        if self.locationObject != nil {
            weatherAPI.type = OpenWeatherMapType.Forecast
            weatherAPI.performWeatherRequest(completionHandler:{(data: Data?, urlResponse: URLResponse?, error: Error?) in
                NSLog("Response Current Forecast Done")
                if (error != nil) {
                    self.showAddOutfitAlert(message: "Error fetching the forecast weather", error: error)
                } else {
                    do {
                        self.responseWeatherApi = try ForecastResponseOpenWeatherMap(data: data!, date: self.datePicker.date)
                        DispatchQueue.main.async { [unowned self] in
                            self.updateViewWithResponseWeatherAPI()
                        }
                    } catch let error as Error {
                        self.showAddOutfitAlert(message: "Error fetching the forecast weather", error: error)
                    }
                }
            })
        }
    }
    
    private func updateViewWithResponseWeatherAPI(){
        self.degrees.text = String(Int(self.responseWeatherApi.getTemperature())) + "°"
        self.pressure.text = String(self.responseWeatherApi.getPressure()) + "hPa"
        self.humidity.text = String(self.responseWeatherApi.getHumidity()) + "%"
        self.tempMax.text = String(self.responseWeatherApi.getTempMax()) + "°"
        self.tempMin.text = String(self.responseWeatherApi.getTempMin()) + "°"
        self.windSpeed.text = String(self.responseWeatherApi.getWindSpeed()) + "mps"
        self.weatherLabel.text = self.responseWeatherApi.getDescription()
        self.location.text = self.responseWeatherApi.getCityName()
    }
    
    private func showAddOutfitAlert(message: String, error: Error?) {
        let alert = UIAlertController(title: "Oups!", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (action) in
            print(error ?? "No error object")
        }))
        self.present(alert, animated: true, completion: nil)
    }
}

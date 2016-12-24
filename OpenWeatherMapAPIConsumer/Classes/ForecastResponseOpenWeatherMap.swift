//
//  ResponseOpenWeatherMap.swift
//  WhatWearToday
//
//  Created by jlcardosa on 17/11/2016.
//  Copyright © 2016 Cardosa. All rights reserved.
//

import Foundation
import CoreLocation

public class ForecastResponseOpenWeatherMap : ResponseOpenWeatherMap, ResponseOpenWeatherMapProtocol {
	
    var forecastList = Array<Dictionary<String, Any>>()
    public var currentListElement = Dictionary<String, Any>()
    var pickedDate : Date!
    
    public init(data : Data, date : Date) throws {
        try super.init(data: data)
        self.pickedDate = date
		self.forecastList = self.getArrayOfDictionary(byKey: "list")
		if self.forecastList.count == 0 {
			throw BadDataError.NoForecastList
		}
        self.getCurrentListElementDependingOnTheDate()
    }
	
	public func getCoord() -> CLLocationCoordinate2D {
		let city = self.getDictionary(byKey: "city")
		let coord = city["coord"] as! Dictionary<String,Float>
		return CLLocationCoordinate2D(latitude: CLLocationDegrees(coord["lat"]!), longitude: CLLocationDegrees(coord["long"]!))
	}
    
    public func getTemperature() -> Float {
		let main = self.currentListElement["main"] as! Dictionary<String, Float>
        return main["temp"]!
    }
    
    public func getPressure() -> Float {
		let main = self.currentListElement["main"] as! Dictionary<String, Float>
		return main["pressure"]!
    }
    
	public func getHumidity() -> Float {
		let main = self.currentListElement["main"] as! Dictionary<String, Float>
		return main["humidity"]!
    }
    
	public func getTempMax() -> Float {
		let main = self.currentListElement["main"] as! Dictionary<String, Float>
		return main["temp_max"]!
    }
    
	public func getTempMin() -> Float {
		let main = self.currentListElement["main"] as! Dictionary<String, Float>
		return main["temp_min"]!
    }
    
    public func getCityName() -> String {
        let city = self.getDictionary(byKey: "city")
        return city["name"] as! String
    }
	
	public func getIconList() -> IconList {
		let weather = self.currentListElement["weather"] as! Array<Dictionary<String, Any>>
		let icon = weather.first?["icon"] as! String
	
		return IconList(rawValue: icon)!
	}
	
    public func getDescription() -> String {
        let weather = self.currentListElement["weather"] as! Array<Dictionary<String, Any>>
        return weather.first?["description"] as! String
    }
    
    public func getWindSpeed() -> Float {
		
		let wind = self.currentListElement["wind"] as! Dictionary<String, Float>
		return wind["speed"]!
    }
    
    public func getDate() -> Date {
        return Date(timeIntervalSince1970: self.currentListElement["dt"] as! TimeInterval)
    }
    
    private func getCurrentListElementDependingOnTheDate() {
        let unixDate = Int(self.pickedDate.timeIntervalSince1970)
        self.currentListElement = self.forecastList.first!
        for elementList in self.forecastList {
            let elementListDate = elementList["dt"] as! Int
            if (unixDate < elementListDate) {
                self.currentListElement = elementList
                break
            }
        }
    }
}

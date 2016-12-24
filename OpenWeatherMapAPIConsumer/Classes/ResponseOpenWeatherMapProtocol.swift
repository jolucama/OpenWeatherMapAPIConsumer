//
//  ResponseOpenWeatherMapProtocol.swift
//  WhatWearToday
//
//  Created by jlcardosa on 17/11/2016.
//  Copyright © 2016 Cardosa. All rights reserved.
//

import Foundation
import CoreLocation


public protocol ResponseOpenWeatherMapProtocol {
	
	func getCoord() -> CLLocationCoordinate2D
	
    func getTemperature() -> Float
    
    func getPressure() -> Float
    
    func getHumidity() -> Float
    
    func getTempMax() -> Float
    
    func getTempMin() -> Float
    
    func getCityName() -> String
	
	func getIconList() -> IconList
	
    func getDescription() -> String
    
    func getWindSpeed() -> Float
    
    func getDate() -> Date
}

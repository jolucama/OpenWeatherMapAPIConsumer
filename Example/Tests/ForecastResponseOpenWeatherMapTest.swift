//
//  CurrentResponseOpenWeatherMapTest.swift
//  WhatWearToday
//
//  Created by jlcardosa on 15/12/2016.
//  Copyright © 2016 Cardosa. All rights reserved.
//

import XCTest
import CoreLocation
import OpenWeatherMapAPIConsumer

class ForecastResponseOpenWeatherMapTest: XCTestCase {
	
	var forecastResponse: ForecastResponseOpenWeatherMap!
	var date: Date!
	
	override func setUp() {
		super.setUp()
		let rawDataJSON = self.mockJSONOpenWeatherMapAPI()
		do {
			//13/12/2016 - 00:00:00
			self.date = Date(timeIntervalSince1970: 1481587200)
			try self.forecastResponse = ForecastResponseOpenWeatherMap(data: rawDataJSON!, date: date)
		} catch _ as Error{
			XCTFail("Wrong error")
		}
	}
	
	override func tearDown() {
		super.tearDown()
		self.forecastResponse = nil
		self.date = nil
	}
	
	func testGetCurrentListElementDependingOnTheDate() {
		//13 Dec 2016 02:00:00
		XCTAssertEqual(self.forecastResponse.currentListElement["dt"] as! Int, 1481594400)
	}
	
	func testGetCoord() {
		let coord = self.forecastResponse.getCoord()
		XCTAssertTrue(coord is CLLocationCoordinate2D)
		XCTAssertEqual(coord.latitude, 2.5)
		XCTAssertEqual(coord.longitude, 2.5)
	}
	
	func testGetTemperature() {
		let temp = self.forecastResponse.getTemperature()
		XCTAssertEqual(temp, 2.5)
	}
	
	func testGetPressure() {
		let pressure = self.forecastResponse.getPressure()
		XCTAssertEqual(pressure, 2.5)
	}
	
	func testGetHumidity() {
		let humidity = self.forecastResponse.getHumidity()
		XCTAssertEqual(humidity, 2.5)
	}
	
	func testGetTempMax() {
		let tempMax = self.forecastResponse.getTempMax()
		XCTAssertEqual(tempMax, 2.5)
	}
	
	func testGetTempMin() {
		let tempMin = self.forecastResponse.getTempMin()
		XCTAssertEqual(tempMin, 2.5)
	}
	
	func testGetCityName() {
		let cityName = self.forecastResponse.getCityName()
		XCTAssertEqual(cityName, "London")
	}
	
	func testGetIconList() {
		let icon = self.forecastResponse.getIconList()
		XCTAssertEqual(icon, IconList.RainDay)
	}
	
	func testGetDescription() {
		let description = self.forecastResponse.getDescription()
		XCTAssertEqual(description, "light rain")
	}
	
	func testGetWindSpeed() {
		let wind = self.forecastResponse.getWindSpeed()
		XCTAssertEqual(wind, 4.6)
	}
	
	func testGetDate() {
		let date = self.forecastResponse.getDate()
		XCTAssertEqual(date, Date(timeIntervalSince1970: 1481594400))
	}
	
	func testNilDataSent(){
		do {
			try self.forecastResponse = ForecastResponseOpenWeatherMap(data: self.mockEmptyJSONOpenWeatherMapAPI()!, date: self.date)
		} catch let error as ResponseOpenWeatherMap.BadDataError {
			
			switch error {
			case ResponseOpenWeatherMap.BadDataError.NoDataEntry:
				XCTAssertTrue(true)
			default:
				XCTFail("Wrong error")
			}
		} catch {
			XCTFail("Wrong error")
		}
	}
	
	func testEmptyForecastListDataSent(){
		do {
			try self.forecastResponse = ForecastResponseOpenWeatherMap(data: self.mockJSONWithEmptyForecastListOpenWeatherMapAPI()!, date: self.date)
		} catch let error as ResponseOpenWeatherMap.BadDataError {
			
			switch error {
			case ResponseOpenWeatherMap.BadDataError.NoForecastList:
				XCTAssertTrue(true)
			default:
				XCTFail("Wrong error")
			}
		} catch {
			XCTFail("Wrong error")
		}
	}
	
	func testWrongJSON(){
		do {
			let wrongJSON = "{jose wrong JSON Format }"
			
			try self.forecastResponse = ForecastResponseOpenWeatherMap(data: wrongJSON.data(using: String.Encoding.ascii)!, date: self.date)
		} catch let error as ResponseOpenWeatherMap.BadDataError {
			
			switch error {
			case ResponseOpenWeatherMap.BadDataError.SerializationIssue(let errorSerializationJSON):
				XCTAssertTrue(true)
				XCTAssertEqual(errorSerializationJSON.localizedDescription, "The data couldn’t be read because it isn’t in the correct format.")
			default:
				XCTFail("Wrong error")
			}
		} catch {
			XCTFail("Wrong error")
		}
	}
	
	func testPerformanceExample() {
		// This is an example of a performance test case.
		self.measure {
			// Put the code you want to measure the time of here.
		}
	}
	
	private func mockJSONOpenWeatherMapAPI() -> Data? {
		
		var responseAPI = Dictionary<String, Any>()
		
		responseAPI["cod"] = 200
		responseAPI["message"] = 0.00123
		responseAPI["cnt"] = 5
		
		var city = Dictionary<String, Any>()
		var coord = Dictionary<String, Float>()
		coord["lat"] = 2.5
		coord["long"] = 2.5
		city["coord"] = coord
		city["id"] = 2643743
		city["name"] = "London"
		city["country"] = "GB"
		responseAPI["city"] = city

		var list = Array<Dictionary<String, Any>>()
		
		let firstDate = 1481572800 // 12 Dec 2016 20:00:00
		for i in (0..<10) {
			var forecast = Dictionary<String, Any>()
			
			var main = Dictionary<String, Float>()
			main["temp"] = 2.5
			main["pressure"] = 2.5
			main["humidity"] = 2.5
			main["temp_max"] = 2.5
			main["temp_min"] = 2.5
			main["sea_level"] = 2.5
			main["grnd_level"] = 2.5
			main["temp_kf"] = 2.5
			forecast["main"] = main
			
			var weather = Array<Dictionary<String, Any>>()
			var first = Dictionary<String, Any>()
			first["id"] = 500
			first["main"] = "Rain"
			first["description"] = "light rain"
			first["icon"] = "10d"
			weather.append(first)
			var second = Dictionary<String, Any>()
			second["id"] = 400
			second["main"] = "Rain"
			second["description"] = "light rain"
			second["icon"] = "10n"
			weather.append(second)
			forecast["weather"] = weather
			
			var wind = Dictionary<String, Float>()
			wind["speed"] = 4.6
			wind["deg"] = 60
			forecast["wind"] = wind
			
			//Increase the time 3h each element
			forecast["dt"] = firstDate + (60*60*3*i)
			
			list.append(forecast)
		}
		responseAPI["list"] = list
		
		do {
			return try JSONSerialization.data(withJSONObject: responseAPI, options: .prettyPrinted)
		} catch let error as NSError {
			XCTAssertTrue(false, error.localizedDescription)
		}
		return nil
	}
	
	private func mockEmptyJSONOpenWeatherMapAPI() -> Data? {
		
		let responseAPI = Dictionary<String, Any>()
		
		do {
			return try JSONSerialization.data(withJSONObject: responseAPI, options: .prettyPrinted)
		} catch let error as NSError {
			XCTAssertTrue(false, error.localizedDescription)
		}
		return nil
	}
	
	private func mockJSONWithEmptyForecastListOpenWeatherMapAPI() -> Data? {
		
		var responseAPI = Dictionary<String, Any>()
		
		responseAPI["cod"] = 200
		responseAPI["message"] = 0.00123
		responseAPI["cnt"] = 5
		
		let list = Array<Dictionary<String, Any>>()
		responseAPI["list"] = list
		
		do {
			return try JSONSerialization.data(withJSONObject: responseAPI, options: .prettyPrinted)
		} catch let error as NSError {
			XCTAssertTrue(false, error.localizedDescription)
		}
		return nil
	}
}

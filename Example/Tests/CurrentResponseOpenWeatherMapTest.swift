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

class CurrentResponseOpenWeatherMapTest: XCTestCase {
	
	var currentResponse: CurrentResponseOpenWeatherMap!
	
    override func setUp() {
        super.setUp()
		let rawDataJSON = self.mockJSONOpenWeatherMapAPI()
		do {
			try self.currentResponse = CurrentResponseOpenWeatherMap(data: rawDataJSON!)
		} catch _ as Error{
			XCTFail("Wrong error")
		}
    }
    
    override func tearDown() {
        super.tearDown()
		self.currentResponse = nil
    }
    
    func testGetCoord() {
		let coord = self.currentResponse.getCoord()
		XCTAssertTrue(coord is CLLocationCoordinate2D)
		XCTAssertEqual(coord.latitude, 2.5)
		XCTAssertEqual(coord.longitude, 2.5)
    }
	
	func testGetTemperature() {
		let temp = self.currentResponse.getTemperature()
		XCTAssertEqual(temp, 2.5)
	}
	
	func testGetPressure() {
		let pressure = self.currentResponse.getPressure()
		XCTAssertEqual(pressure, 2.5)
	}
	
	func testGetHumidity() {
		let humidity = self.currentResponse.getHumidity()
		XCTAssertEqual(humidity, 2.5)
	}
	
	func testGetTempMax() {
		let tempMax = self.currentResponse.getTempMax()
		XCTAssertEqual(tempMax, 2.5)
	}
	
	func testGetTempMin() {
		let tempMin = self.currentResponse.getTempMin()
		XCTAssertEqual(tempMin, 2.5)
	}
	
	func testGetCityName() {
		let cityName = self.currentResponse.getCityName()
		XCTAssertEqual(cityName, "London")
	}
	
	func testGetIconList() {
		let icon = self.currentResponse.getIconList()
		XCTAssertEqual(icon, IconList.RainDay)
	}
	
	func testGetDescription() {
		let description = self.currentResponse.getDescription()
		XCTAssertEqual(description, "light rain")
	}
	
	func testGetWindSpeed() {
		let wind = self.currentResponse.getWindSpeed()
		XCTAssertEqual(wind, 4.6)
	}
	
	func testGetDate() {
		let date = self.currentResponse.getDate()
		XCTAssertEqual(date, Date(timeIntervalSince1970: 1481817480))
	}
	
	func testNilDataSent(){
		do {
			try self.currentResponse = CurrentResponseOpenWeatherMap(data: self.mockEmptyJSONOpenWeatherMapAPI()!)
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
	
	func testWrongJSON(){
		do {
			let wrongJSON = "{jose wrong JSON Format }"
			
			try self.currentResponse = CurrentResponseOpenWeatherMap(data: wrongJSON.data(using: String.Encoding.ascii)!)
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
		
		var coord = Dictionary<String, Float>()
		coord["lat"] = 2.5
		coord["long"] = 2.5
		responseAPI["coord"] = coord
		
		var main = Dictionary<String, Float>()
		main["temp"] = 2.5
		main["pressure"] = 2.5
		main["humidity"] = 2.5
		main["temp_max"] = 2.5
		main["temp_min"] = 2.5
		responseAPI["main"] = main
		
		responseAPI["name"] = "London"
		
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
		responseAPI["weather"] = weather
		
		var wind = Dictionary<String, Float>()
		wind["speed"] = 4.6
		wind["deg"] = 60
		responseAPI["wind"] = wind
		
		responseAPI["dt"] = 1481817480
	
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
}

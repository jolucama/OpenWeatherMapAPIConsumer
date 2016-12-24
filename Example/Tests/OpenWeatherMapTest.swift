//
//  OpenWeatherMapTest.swift
//  WhatWearToday
//
//  Created by jlcardosa on 23/12/2016.
//  Copyright © 2016 Cardosa. All rights reserved.
//

import XCTest
import CoreLocation
import OpenWeatherMapAPIConsumer

class OpenWeatherMapTest: XCTestCase {
	
	var weatherAPI: OpenWeatherMapAPI!
	var response: CurrentResponseOpenWeatherMap!
	
	var parameters = [String:String]()
	
    override func setUp() {
        super.setUp()
		let apiKey = PlistManager.getValue(forKey: "APIWeatherKey") as! String
		self.weatherAPI = OpenWeatherMapAPI(apiKey: apiKey)
		parameters[RequestParametersKey.apiKey.rawValue] = apiKey
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
		self.weatherAPI = nil
    }
    
    func testWeatherByCityName() {
		self.weatherAPI.weather(byCityName: "London")
		self.parameters[RequestParametersKey.cityName.rawValue] = "London"
		
		XCTAssertEqual(self.weatherAPI.parameters, parameters)
	}
	
	func testWeatherByCityNameAndCountryCode() {
		self.weatherAPI.weather(byCityName: "London", andCountryCode: "GB")
		self.parameters[RequestParametersKey.cityName.rawValue] = "London,GB"
		
		XCTAssertEqual(self.weatherAPI.parameters, parameters)
	}
	
	func testWeatherByCityId() {
		self.weatherAPI.weather(byCityId: 12345)
		self.parameters[RequestParametersKey.cityID.rawValue] = "12345"
		
		XCTAssertEqual(self.weatherAPI.parameters, parameters)
	}
	
	func testWeatherByLatitudeAndLongitude() {
		self.weatherAPI.weather(byLatitude: 10.0, andLongitude: 15.0)
		self.parameters[RequestParametersKey.latitude.rawValue] = "10.0"
		self.parameters[RequestParametersKey.longitude.rawValue] = "15.0"
		
		XCTAssertEqual(self.weatherAPI.parameters, parameters)
	}
	
	func testResetLocationParameters() {
		self.weatherAPI.weather(byLatitude: 10.0, andLongitude: 15.0)
		self.weatherAPI.resetLocationParameters()
		
		XCTAssertEqual(self.weatherAPI.parameters, parameters)
	}
	
	
	func testSetSearchAccuracy() {
		self.weatherAPI.setSearchAccuracy(searchAccuracy: SearchAccuracyType.Accurate)
		self.parameters[RequestParametersKey.searchAccuracy.rawValue] = SearchAccuracyType.Accurate.rawValue
		
		XCTAssertEqual(self.weatherAPI.parameters, parameters)
	}
	
	func testSetLimitionOfResult() {
		self.weatherAPI.setLimitationOfResult(in: 10)
		self.parameters[RequestParametersKey.limit.rawValue] = "10"
		
		XCTAssertEqual(self.weatherAPI.parameters, parameters)
	}
	
	func testSetTemperatureUnit() {
		self.weatherAPI.setTemperatureUnit(unit: TemperatureFormat.Celsius)
		self.parameters[RequestParametersKey.units.rawValue] = TemperatureFormat.Celsius.rawValue
		
		XCTAssertEqual(self.weatherAPI.parameters, parameters)
	}
	
	func testMultilingualSupport() {
		self.weatherAPI.setMultilingualSupport(language: Language.German)
		self.parameters[RequestParametersKey.language.rawValue] = Language.German.rawValue
		
		XCTAssertEqual(self.weatherAPI.parameters, parameters)
	}
	
	func testPerformRequest() {
		self.weatherAPI.weather(byCityName: "London")
		self.performRequest(handlerAssertions: {(error: Error?) in
			XCTAssertNil(error)
			XCTAssertEqual(self.response.getCityName(), "London")
		})
	}
	
	func testPerformRequestWithCityNameAndCountryCode() {
		self.weatherAPI.weather(byCityName: "Madrid", andCountryCode: "ES")
		self.performRequest(handlerAssertions: {(error: Error?) in
			XCTAssertNil(error)
			XCTAssertEqual(self.response.getCityName(), "Madrid")
		})
	}
	
	
	func testPerformRequestWithCityId() {
		self.weatherAPI.weather(byCityId: 2172797)
		self.performRequest(handlerAssertions: {(error: Error?) in
			XCTAssertNil(error)
			XCTAssertEqual(self.response.getCityName(), "Cairns")
		})
	}
	
	func testPerformRequestWithLatitudeAndLongitude() {
		self.weatherAPI.weather(byLatitude: 10.0, andLongitude: 15.0)
		self.performRequest(handlerAssertions: {(error: Error?) in
			XCTAssertNil(error)
			XCTAssertEqual(self.response.getCityName(), "Yagoua")
		})
	}
	
	private func performRequest(handlerAssertions: @escaping (Error?) -> Swift.Void)
	{
		let asyncExpectation = expectation(description: "longRunningFunction")
		self.weatherAPI.performWeatherRequest(completionHandler: {(data: Data?, urlResponse: URLResponse?, error: Error?) -> Void in
				XCTAssertNil(error)
				do {
					self.response = try CurrentResponseOpenWeatherMap(data: data!)
				} catch _ as Error {
					XCTFail("Unexpected error")
				}
				asyncExpectation.fulfill()
		})
		self.waitForExpectations(timeout: 5, handler: handlerAssertions)
	}
}

//
//  RequestOpenWeatherMapTest.swift
//  WhatWearToday
//
//  Created by jlcardosa on 11/12/2016.
//  Copyright © 2016 Cardosa. All rights reserved.
//

import XCTest
import OpenWeatherMapAPIConsumer

class RequestOpenWeatherMapTest: XCTestCase {
	
	var parameters: [String:String] = [:]
	var apiKey: String = ""
	var dataResult: Dictionary<String, Any>!
	
    override func setUp() {
        super.setUp()
		self.parameters = [:]
		self.apiKey = PlistManager.getValue(forKey: "APIWeatherKey") as! String
    }
    
    override func tearDown() {
        super.tearDown()
		self.dataResult = [:]
    }
    
    func testStringFromHttpParametersEmpty() {
		let requestOpenWeatherMap = RequestOpenWeatherMap(withType: OpenWeatherMapType.Current, andParameters: self.parameters)
		
		XCTAssertEqual(requestOpenWeatherMap.stringFromHttpParameters(),"")
	}
	
	func testStringFromHttpParametersWithOne() {
		self.parameters = ["key":"value"]
		let requestOpenWeatherMap = RequestOpenWeatherMap(withType: OpenWeatherMapType.Current, andParameters: self.parameters)
		
		XCTAssertEqual(requestOpenWeatherMap.stringFromHttpParameters(),"key=value")
	}
	
	func testStringFromHttpParametersWithTwo() {
		self.parameters = ["key":"value", "key2":"value2"]
		let requestOpenWeatherMap = RequestOpenWeatherMap(withType: OpenWeatherMapType.Current, andParameters: self.parameters)
		
		XCTAssertEqual(requestOpenWeatherMap.stringFromHttpParameters(),"key2=value2&key=value")
	}
	
	func testRequestCurrentWithoutApiKey()
	{
		self.makeRequest(type: OpenWeatherMapType.Current, handlerAssertions: { error in
			XCTAssertNil(error)
			XCTAssertEqual(self.dataResult["cod"] as! Int, 401)
			XCTAssertEqual(self.dataResult["message"] as! String, "Invalid API key. Please see http://openweathermap.org/faq#error401 for more info.")
		})
	}
	
	func testRequestCurrentJustWithApiKey()
	{
		self.parameters[RequestParametersKey.apiKey.rawValue] = self.apiKey
		self.makeRequest(type: OpenWeatherMapType.Current, handlerAssertions: { error in
			XCTAssertNil(error)
			XCTAssertEqual(self.dataResult["cod"] as! String, "502")
			XCTAssertEqual(self.dataResult["message"] as! String, "Error: Not found city")
		})
	}
	
	func testRequestCurrentWithApiKeyAndCityName()
	{
		self.parameters[RequestParametersKey.apiKey.rawValue] = self.apiKey
		self.parameters[RequestParametersKey.cityName.rawValue] = "London"
		self.makeRequest(type: OpenWeatherMapType.Current, handlerAssertions: { error in
			XCTAssertNil(error)
			
			XCTAssertTrue(self.dataResult["coord"] != nil)
			let coord = self.dataResult["coord"] as! Dictionary<String,Float>
			XCTAssertTrue(coord["lon"] != nil)
			XCTAssertTrue(coord["lat"] != nil)
			
			let wheaters = self.dataResult["weather"] as! Array<Dictionary<String,Any>>
			let wheater = wheaters.first
			XCTAssertTrue(wheater?["id"] != nil)
			XCTAssertTrue(wheater?["main"] != nil)
			XCTAssertTrue(wheater?["description"] != nil)
			XCTAssertTrue(wheater?["icon"] != nil)
			
			XCTAssertTrue(self.dataResult["base"] is String)
			
			XCTAssertTrue(self.dataResult["main"] != nil)
			let main = self.dataResult["main"] as! Dictionary<String,Float>
			XCTAssertTrue(main["temp"] != nil)
			XCTAssertTrue(main["pressure"] != nil)
			XCTAssertTrue(main["humidity"] != nil)
			XCTAssertTrue(main["temp_min"] != nil)
			XCTAssertTrue(main["temp_max"] != nil)
		
			XCTAssertTrue(self.dataResult["visibility"] is Float)
			
			XCTAssertTrue(self.dataResult["wind"] != nil)
			let wind = self.dataResult["wind"] as! Dictionary<String,Float>
			XCTAssertTrue(wind["speed"] != nil)
			XCTAssertTrue(wind["deg"] != nil)
			
			XCTAssertTrue(self.dataResult["clouds"] != nil)
			let clouds = self.dataResult["clouds"] as! Dictionary<String,Float>
			XCTAssertTrue(clouds["all"] != nil)
			
			XCTAssertTrue(self.dataResult["dt"] is Int)
			
			XCTAssertTrue(self.dataResult["sys"] != nil)
			let sys = self.dataResult["sys"] as! Dictionary<String,Any>
			XCTAssertTrue(sys["type"] is Int)
			XCTAssertTrue(sys["id"] is Int)
			XCTAssertTrue(sys["message"] is Float)
			XCTAssertTrue(sys["country"] is String)
			XCTAssertTrue(sys["sunrise"] is Int)
			XCTAssertTrue(sys["sunset"] is Int)
			
			XCTAssertEqual(self.dataResult["id"] as! Int, 2643743)
			XCTAssertEqual(self.dataResult["cod"] as! Int, 200)
			XCTAssertEqual(self.dataResult["name"] as! String, "London")
		})
	}
	
	
	func testRequestForecastWithoutApiKey()
	{
		self.makeRequest(type: OpenWeatherMapType.Forecast, handlerAssertions: { error in
			XCTAssertNil(error)
			XCTAssertEqual(self.dataResult["cod"] as! Int, 401)
			XCTAssertEqual(self.dataResult["message"] as! String, "Invalid API key. Please see http://openweathermap.org/faq#error401 for more info.")
		})
	}
	
	func testRequestForecastJustWithApiKey()
	{
		self.parameters[RequestParametersKey.apiKey.rawValue] = self.apiKey
		self.makeRequest(type: OpenWeatherMapType.Forecast, handlerAssertions: { error in
			XCTAssertNil(error)
			XCTAssertEqual(self.dataResult["cod"] as! String, "502")
			XCTAssertEqual(self.dataResult["message"] as! String, "Error: Not found city")
		})
	}
	
	func testRequestForecastWithApiKeyAndCityName()
	{
		//TODO
	}
	
	private func makeRequest(type: OpenWeatherMapType, handlerAssertions: @escaping (Error?) -> Swift.Void)
	{
		let requestOpenWeatherMap = RequestOpenWeatherMap(withType: type, andParameters: self.parameters)
		let asyncExpectation = expectation(description: "longRunningFunction")
		requestOpenWeatherMap.request(onCompletion: { (data : Data?, response, error) in
			do {
				self.dataResult = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableLeaves) as! Dictionary<String, AnyObject>
				
				asyncExpectation.fulfill()
			} catch let error {
				XCTAssertTrue(false, "testRequestWithoutApiKey error:" + error.localizedDescription)
			}
		})
		self.waitForExpectations(timeout: 5, handler: handlerAssertions)
	}
	
    func testPerformanceRequestWithoutApiKey() {
        // This is an example of a performance test case.
        self.measure {
			self.testRequestCurrentWithoutApiKey()
        }
    }
}

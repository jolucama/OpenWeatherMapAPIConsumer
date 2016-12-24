//
//  RequestOpenWeatherMap.swift
//  WhatWearToday
//
//  Created by jlcardosa on 14/11/2016.
//  Copyright © 2016 Cardosa. All rights reserved.
//

import Foundation


public class RequestOpenWeatherMap {
    
    let baseURLString = "http://api.openweathermap.org/data/"
    let apiVersion = "2.5/"
    let method = "GET"
	
	var type : OpenWeatherMapType!
    var parameters : [String: String]
    
    public init(withType type : OpenWeatherMapType, andParameters parameters:[String: String]) {
        self.type = type
        self.parameters = parameters
    }
    
    public func request(onCompletion : @escaping (Data?, URLResponse?, Error?) -> Swift.Void) {
        let paramString = self.stringFromHttpParameters()
        let url = URL(string: baseURLString + apiVersion + type.rawValue + "?" + paramString)!
        let session = URLSession.shared
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.cachePolicy = URLRequest.CachePolicy.reloadIgnoringCacheData
        
        let task = session.dataTask(with: request, completionHandler: onCompletion)
        task.resume()
        NSLog("Request to : %@", url.absoluteString)
    }
    
    public func stringFromHttpParameters() -> String {
        var parameterArray = [String]()
        for (key, value) in self.parameters {
            parameterArray.append(key + "=" + value.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
        }
        
        return parameterArray.joined(separator: "&")
    }
}

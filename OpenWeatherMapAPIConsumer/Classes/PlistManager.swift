//
//  PlistManager.swift
//  WhatWearToday
//
//  Created by jlcardosa on 17/11/2016.
//  Copyright © 2016 Cardosa. All rights reserved.
//

import Foundation

public class PlistManager {
    
    
    public static func getValue(forKey key: String) -> Any? {
        var config: NSDictionary
        if let path = Bundle.main.path(forResource: "Info", ofType: "plist") {
            config = NSDictionary(contentsOfFile: path)!
            return config.value(forKey: "APIWeatherKey")
        }
        return nil
    }
}

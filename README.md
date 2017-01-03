# OpenWeatherMapAPIConsumer

Get current weather and 3-hourly forecast 5 days for your city. Helpful stats, temperature, clouds, pressure, wind around your location... This API is a consumer of <a href="https://openweathermap.org/">Open Weather Map</a> and the description of the api may be found <a href="https://openweathermap.org/api">here</a>

Note: In the consumer has been implemented just the free version of the API. In order to start using it, please register and get the API Key <a href="https://openweathermap.org/price">Sign up</a>

[![CI Status](http://img.shields.io/travis/Jose Luis Cardosa/OpenWeatherMapAPIConsumer.svg?style=flat)](https://travis-ci.org/Jose Luis Cardosa/OpenWeatherMapAPIConsumer)
[![Version](https://img.shields.io/cocoapods/v/OpenWeatherMapAPIConsumer.svg?style=flat)](http://cocoapods.org/pods/OpenWeatherMapAPIConsumer)
[![License](https://img.shields.io/cocoapods/l/OpenWeatherMapAPIConsumer.svg?style=flat)](http://cocoapods.org/pods/OpenWeatherMapAPIConsumer)
[![Platform](https://img.shields.io/cocoapods/p/OpenWeatherMapAPIConsumer.svg?style=flat)](http://cocoapods.org/pods/OpenWeatherMapAPIConsumer)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

<p align="center">
    <img src="https://github.com/jolucama/OpenWeatherMapAPIConsumer/blob/master/Example/OpenWeatherMapAPIConsumer/CurrentWeatherViewController.png" width="300"/>
    <img src="https://github.com/jolucama/OpenWeatherMapAPIConsumer/blob/master/Example/OpenWeatherMapAPIConsumer/ForecastWeatherViewController.png" width="300"/>
</p>

Basically, the example makes use of the CLLocationManager to obtain the current coordenates, and then make a request to our API to get all the displayed information. All the code is located in <a href="https://github.com/jolucama/OpenWeatherMapAPIConsumer/blob/master/Example/OpenWeatherMapAPIConsumer/ViewController.swift">View Controller</a>

## Requirements

- iOS 10.2
- Swift 3
- Xcode 8

## Installation

OpenWeatherMapAPIConsumer is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "OpenWeatherMapAPIConsumer"
```
## Usage

### Import the pod in your file

```swift
import OpenWeatherMapAPIConsumer
```

### Setup the api key

```swift

// Type by default OpenWeatherMapType.Current
let weatherAPI = OpenWeatherMapAPI(apiKey: "YOUR_API_KEY")

// Type forecast
let weatherAPI = OpenWeatherMapAPI(apiKey: "YOUR_API_KEY", forType: OpenWeatherMapType.Forecast)

```


### Set the location using 

```swift

public func weather(byLatitude latitude : Double, andLongitude longitude : Double)

public func weather(byCityName cityName : String)

public func weather(byCityName cityName : String, andCountryCode countryCode: String)

// List of city ids may be found here: http://bulk.openweathermap.org/sample/
public func weather(byCityId cityId : Int)

```

### API Options

```swift
public func setSearchAccuracy(searchAccuracy : SearchAccuracyType)

public func setLimitationOfResult(in limitation : Int)

public func setTemperatureUnit(unit : TemperatureFormat)

public func setMultilingualSupport(language : Language)
```

### Perform request

```swift
public func performWeatherRequest(completionHandler: @escaping (Data?, URLResponse?, Error?) -> Swift.Void)

//Example
weatherAPI.performWeatherRequest(completionHandler:{(data: Data?, urlResponse: URLResponse?, error: Error?) in
    if (error != nil) {
        //Handling error
    } else {
        do {
            let responseWeatherApi = try CurrentResponseOpenWeatherMap(data: data!)
        } catch let error as Error {
            //Handling error
        }
    }
})

```

### Response classes

The response classes are parsers, that give you a better use of the api response

- CurrentResponseOpenWeatherMap(data : Data)
- ForecastResponseOpenWeatherMap(data : Data)

```swift

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

```

## Author

Jose Luis Cardosa, jlcardosa@gmail.com

## License

OpenWeatherMapAPIConsumer is available under the MIT license. See the LICENSE file for more info.

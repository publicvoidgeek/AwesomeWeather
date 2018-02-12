//
//  CurrentWeather.swift
//  Awesome Weather
//
//  Created by Sanam Suri on 11/02/18.
//  Copyright © 2018 SocialPeddler. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class CurrentWeather {
    
    private var _cityName: String!
    private var _date: String!
    private var _weatherType: String!
    private var _currentTemp: Double!
    
    
    var cityName: String {
        if _cityName == nil {
            _cityName = ""
        }
        return _cityName
    }
    
    var date: String {
        if _date == nil {
            _date = ""
        }
        return _date
    }
    
    var weatherType: String {
        if _weatherType == nil {
            _weatherType = ""
        }
        return _weatherType
    }
    
    var currentTemp: Double {
        if _currentTemp == nil {
            _currentTemp = 0.0
        }
        return _currentTemp
    }
    
    func downloadCurrentWeather(completed: @escaping DownloadComplete){
        Alamofire.request(API_URL).responseJSON { (response) in
            //print(response)
            print(response)
            let result = response.result
            //print(result.value)
            let json = JSON(result.value)
            self._cityName = json["name"].stringValue
            let tempDate = json["dt"].double
            print(tempDate)
            let convertedDate = Date(timeIntervalSince1970: tempDate!)
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .none
            let currentDate = dateFormatter.string(from: convertedDate)
            self._date = "\(currentDate)"
            print(currentDate)
            self._weatherType = json["weather"][0]["main"].stringValue
            let downloadedTemp = json["main"]["temp"].double
            self._currentTemp = (downloadedTemp! - 273.15).rounded(toPlaces: 0)
            completed()
        }
        
    }
    
    
    
}

//
//  ViewController.swift
//  Awesome Weather
//
//  Created by Sanam Suri on 11/02/18.
//  Copyright © 2018 SocialPeddler. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    // Outlets
    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var weatherType: UILabel!
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var currentCityTemp: UILabel!
    @IBOutlet weak var currentDate: UILabel!
    @IBOutlet weak var specialBG: UIImageView!
    
    
    
    // Constants
    let locationManager = CLLocationManager()
    
    
    // Variables
    var currentWeather: CurrentWeather!
    var currentLocation: CLLocation!
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        callDelegates()
        currentWeather = CurrentWeather()
        setupLocation()
        applyEffect()
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        locationAuthCheck()
    }
    
    func callDelegates() {
        locationManager.delegate = self
    }
    
    func setupLocation() {
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization() // Take Permission from the user
        locationManager.startMonitoringSignificantLocationChanges()
    }
    
    func locationAuthCheck() {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            // Get the location from the device
            currentLocation = locationManager.location
            
            // Pass the location coord to our API
            Location.sharedInstance.latitude = currentLocation.coordinate.latitude
            Location.sharedInstance.longitude = currentLocation.coordinate.longitude
            
            // Download the API Data
            currentWeather.downloadCurrentWeather {
                // Update the UI after download is completed.
                self.updateUI()
            }
            
            
            
        } else { // User did not allow
            locationManager.requestWhenInUseAuthorization()  // Take Permission from the user again
            locationAuthCheck()  // Make a check
        }
        
    }
    
    
    func applyEffect() {
        specialEffect(view: specialBG, intensity: 45)
    }
    
    
    func specialEffect(view: UIView, intensity: Double) {
        let horizontalMotion = UIInterpolatingMotionEffect(keyPath: "center.x", type: .tiltAlongHorizontalAxis)
        horizontalMotion.minimumRelativeValue = -intensity
        horizontalMotion.maximumRelativeValue = intensity
        
        let verticalMotion = UIInterpolatingMotionEffect(keyPath: "center.y", type: .tiltAlongVerticalAxis)
        verticalMotion.minimumRelativeValue = -intensity
        verticalMotion.maximumRelativeValue = intensity
        
        let movement = UIMotionEffectGroup()
        movement.motionEffects = [horizontalMotion, verticalMotion]
        view.addMotionEffect(movement)
    }
    
    
    func updateUI() {
        cityName.text = currentWeather.cityName
        currentCityTemp.text = "\(Int(currentWeather.currentTemp))"
        weatherType.text = currentWeather.weatherType
        currentDate.text = currentWeather.date
    }
    
  
}


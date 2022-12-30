//
//  SunbatheViewController.swift
//  Sunwise
//
//  Created by Uray Muhamad Noor Fajri Widiansyah on 19/12/22.
//

import UIKit
import CoreLocation

class SunbatheViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var uvCurrentView: UVCurrent!
    @IBOutlet weak var protectionView: ProtectionSelected!
    @IBOutlet weak var seeMoreButton: UIButton!
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var startSunbathe: UIButton!
    
    var currentWeather: CurrentWeather?
    var currentLocation: CLLocation?
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupLocation()
    }

    func setupLocation(){
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if !locations.isEmpty, currentLocation == nil {
            currentLocation = locations.first
            locationManager.stopUpdatingLocation()
            requestUviConditionBasedOnLocation()
        }
    }
    
    func requestUviConditionBasedOnLocation() {
        guard let currentLocation = currentLocation else {
            return
        }
        let longitude = currentLocation.coordinate.longitude
        let latitude = currentLocation.coordinate.latitude
        
        let url = "https://api.openweathermap.org/data/3.0/onecall?lat=\(latitude)&lon=\(longitude)&exclude=minutely&appid=2806ff2f0729ec6bedab98f254cb1226&units=metric"
        
        print("-=============== latitude longitude got \(latitude) + \(longitude) \n")
        
        URLSession.shared.dataTask(with: URL(string: url)!, completionHandler: { data, response, error in
            guard let data = data, error == nil else {
                print("something went wrong during validation!")
                return
            }
            print("======= masuk sini euyyy")
            var json: WeatherResponse?
            do {
                json = try JSONDecoder().decode(WeatherResponse.self, from: data)
                
            }
            catch {
                print("error: \(error)")
            }
            
            guard let result = json else {
                return
            }
            
            DispatchQueue.main.async {
                
                self.uvCurrentView.uvi.text = "\(Int(result.current.uvi))"
                self.uvCurrentView.categoryText.text = "(\(self.getUVCategory(uvi: Int(result.current.uvi))))"
                self.uvCurrentView.recommendationText.text = "\(self.getUVRecommendation(uvi: Int(result.current.uvi)))"
            }
        }).resume()
    }

    func getUVCategory(uvi: Int) -> String {
        switch uvi{
        case 0...2:
            return "Low"
        case 3...6:
            return "Moderate"
        case 6...7:
            return "High"
        case 8...10:
            return "Very High"
        case 11...99:
            return "Extreme"
        default:
            return ""
        }
    }
    
    func getUVRecommendation(uvi: Int) -> String {
        switch uvi{
        case 0...2:
            return "Safe Sunlight"
        case 3...6:
            return "Moderate Sunlight"
        case 6...7:
            return "Hot Sunlight"
        case 8...10:
            return "Avoid Sunlight"
        case 11...99:
            return "Avoid Sunlight"
        default:
            return ""
        }
    }
    

}

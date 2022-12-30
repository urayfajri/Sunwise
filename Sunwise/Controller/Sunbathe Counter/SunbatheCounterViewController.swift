//
//  SunbatheCounterViewController.swift
//  Sunwise
//
//  Created by Ariel Waraney on 30/12/22.
//

import UIKit
import CoreLocation

class SunbatheCounterViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet var uvCurrentView: UVCurrent!
    @IBOutlet var locationCurrentView: LocationCurrent!
    @IBOutlet weak var finishSunbatheButton: UIButton!
    
    var currentWeather: CurrentWeather?
    var currentLocation: CLLocation?
    let locationManager = CLLocationManager()
    var modelLocation = [LocationCoordinate]()
    
    var duration: Date?
    var finishTime: Date?
    var location: String?
    var startTime: Date?
    var temp: Double?
    var uvi: Int?
    var weather: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let location = location else { return }
        guard let weather = weather else { return }
        guard let temp = temp else { return }
        guard let uvi = uvi else { return }
        guard let startTime = startTime else { return }
        
        //MARK: CORE DATA NOT CREATED IN HERE (this prints is just for displaying the data)
        print("\n===== SESSION CREATED WITH DATA =====")
        print("location : \(location)")
        print("weatherID : \(weather)")
        print("temp : \(temp)")
        print("uvi : \(uvi)")
        print("start time : \(startTime)\n")
        //MARK: duration and finishTime should still empty / nil
    }

    @IBAction func finishSunbatheButtonPressed(_ sender: Any) {
        //TODO: Update Core Data Model for finish and duration storing.
        self.dismiss(animated: true)
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
        
        URLSession.shared.dataTask(with: URL(string: url)!, completionHandler: { data, response, error in
            guard let data = data, error == nil else {
                print("something went wrong during validation!")
                return
            }
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
                
                self.locationCurrentView.temp.text = "\(Int(result.current.temp))°C"
                self.locationCurrentView.weatherIcon.image = UIImage(systemName: "\(self.getConditionWeatherId(id: result.current.weather[0].id))")
            }
        }).resume()
        
        let geoUrl = "https://api.openweathermap.org/geo/1.0/reverse?lat=\(latitude)&lon=\(longitude)&limit=1&appid=2806ff2f0729ec6bedab98f254cb1226"
        
        URLSession.shared.dataTask(with: URL(string: geoUrl)!, completionHandler: { data, response, error in
            guard let data = data, error == nil else {
                print("something went wrong during validation!")
                return
            }
            
            var jsonLocation: [LocationCoordinate]?
            do {
                jsonLocation = try JSONDecoder().decode([LocationCoordinate].self, from: data)
            }
            catch {
                print("error: \(error)")
            }
            
            guard let resultLocation = jsonLocation else {
                return
            }
            
            DispatchQueue.main.async {
                self.locationCurrentView.location.text = resultLocation[0].name
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
    
    func getConditionWeatherId(id: Int) -> String {
        switch id{
        case 200...232:
            return "cloud.bolt.rain.fill"
        case 300...321:
            return "cloud.drizzle"
        case 500...531:
            return "cloud.rain"
        case 600...622:
            return "cloud.snow"
        case 701...781:
            return "cloud.fog"
        case 800:
            return "sun.max"
        case 801...804:
            return "cloud.bolt"
        default:
            return "cloud"
        }
    }
}

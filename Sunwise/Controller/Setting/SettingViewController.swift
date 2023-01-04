//
//  SettingViewController.swift
//  Sunwise
//
//  Created by Uray Muhamad Noor Fajri Widiansyah on 19/12/22.
//

import UIKit
import CoreLocation

class SettingViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var dailySunbatheView: UIView!
    @IBOutlet weak var locationView: UIView!
    @IBOutlet weak var notificationView: UIView!
    @IBOutlet weak var skinProfileView: UIView!
    

    @IBOutlet weak var dailySunbatheGoalLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var skinTypeLabel: UILabel!
    @IBOutlet weak var skinTypeImage: UIImageView!
    @IBOutlet weak var skinTypeRecommendedSunExposureGoalLabel: UILabel!
    @IBOutlet weak var skinTypeBurnLabel: UILabel!
    @IBOutlet weak var skinTypeTanLabel: UILabel!
    @IBOutlet weak var skinTypePeelLabel: UILabel!
    
    @IBOutlet weak var setSkinProfileButton: UIButton!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var user: User?
    
    var modelDaily = [DailyWeather]()
    var modelHourly = [HourlyWeather]()
    var modelLocation = [LocationCoordinate]()
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getUserInfo()
        initElements()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupLocation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getUserInfo()
        initElements()
    }
    
    func initElements() {
        dailySunbatheView.layer.cornerRadius = 10
        locationView.layer.cornerRadius = 10
        notificationView.layer.cornerRadius = 10
        skinProfileView.layer.cornerRadius = 10
        
        dailySunbatheGoalLabel.text = "\(user?.sunbath_goal ?? 0) Min / Day"
        skinTypeLabel.text = user?.skin_type ?? "-"
        initSkinTypeRespone()
    }
    
    @IBAction func EditGoalButtonTapped(_ sender: Any) {
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "GoalSettingViewController") as! GoalSettingViewController
        controller.user = user
        controller.modalPresentationStyle = .popover
        present(controller, animated: true, completion: nil)
    }
    
    @IBAction func setSkinProfileButtonTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(identifier: "skinCheck") as! UINavigationController
        controller.modalTransitionStyle = .flipHorizontal
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: true)
    }
    
    
    func getUserInfo(){
        do {
            let users = try context.fetch(User.fetchRequest())
            if(!users.isEmpty) {
                user = users[0]
            }
        }
        catch {
            
        }
    }
    
    func initSkinTypeRespone() {
        switch skinTypeLabel.text {
            case "Skin Type I":
                skinTypeImage.image = UIImage(named:"SkinType1")
                skinTypeRecommendedSunExposureGoalLabel.text = "10 Min / Day"
                skinTypeBurnLabel.text = "Easily, Severely (Painful Burn)"
                skinTypeTanLabel.text = "Little or none"
                skinTypePeelLabel.text = "Yes"
            case "Skin Type II":
                skinTypeImage.image = UIImage(named:"SkinType2")
                skinTypeRecommendedSunExposureGoalLabel.text = "20 Min / Day"
                skinTypeBurnLabel.text = "Easily, Severely (Painful Burn)"
                skinTypeTanLabel.text = "Minimally or lightly"
                skinTypePeelLabel.text = "Yes"
            case "Skin Type III":
                skinTypeImage.image = UIImage(named:"SkinType3")
                skinTypeRecommendedSunExposureGoalLabel.text = "30 Min / Day"
                skinTypeBurnLabel.text = "Burns Moderately"
                skinTypeTanLabel.text = "Easily"
                skinTypePeelLabel.text = "No"
            case "Skin Type IV":
                skinTypeImage.image = UIImage(named:"SkinType4")
                skinTypeRecommendedSunExposureGoalLabel.text = "40 Min / Day"
                skinTypeBurnLabel.text = "Burns Minimally"
                skinTypeTanLabel.text = "Easily"
                skinTypePeelLabel.text = "No"
            case "Skin Type V":
                skinTypeImage.image = UIImage(named:"SkinType5")
                skinTypeRecommendedSunExposureGoalLabel.text = "60 Min / Day"
                skinTypeBurnLabel.text = "Rarely Burns"
                skinTypeTanLabel.text = "Easily and substantially"
                skinTypePeelLabel.text = "No"
            case "Skin Type VI":
                skinTypeImage.image = UIImage(named:"SkinType6")
                skinTypeRecommendedSunExposureGoalLabel.text = "60 Min / Day"
                skinTypeBurnLabel.text = "Never Burns"
                skinTypeTanLabel.text = "Profusely"
                skinTypePeelLabel.text = "No"
            default:
                skinTypeImage.image = UIImage(named:"SkinType1")
                skinTypeRecommendedSunExposureGoalLabel.text = "10 Min / Day"
                skinTypeBurnLabel.text = "Easily, Severely (Painful Burn)"
                skinTypeTanLabel.text = "Little or none"
                skinTypePeelLabel.text = "Yes"
        }
    }
    
    //MARK: - Location Functions
    func setupLocation() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if !locations.isEmpty, currentLocation == nil {
            currentLocation = locations.first
            locationManager.stopUpdatingLocation()
            requestWeatherForLocation()
        }
    }
    
    //MARK: - Weather
    func requestWeatherForLocation() {
        guard let currentLocation = currentLocation else {
            return
        }
        let longitude = currentLocation.coordinate.longitude
        let latitude = currentLocation.coordinate.latitude
        print("long: \(longitude), lat: \(latitude)")
        
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
            
            let enteries = result.daily
            self.modelDaily.append(contentsOf: enteries)
            self.modelHourly = result.hourly
            
            // DispatchQueue.main.async {
                //self.dayLabel.text = self.convertUnixToDate(unix: result.current.dt, format: "EEEE, d MMMM yyyy")
                //self.sunriseHour.text = self.convertUnixToDate(unix: result.current.sunrise, format: "HH.mm")
                // self.sunsetHour.text = self.convertUnixToDate(unix: result.current.sunset, format: "HH.mm")
                
                // self.uVI = Int(result.current.uvi)
                
                // self.uvSelectedView.uviSelectedText.text = "\(Int(result.current.uvi))"
                // self.uvSelectedView.categoryUviSelectedText.text = "(\(self.getUVCategory(uvi: Int(result.current.uvi))))"
                // self.uvSelectedView.recommendationText.text = self.getUVRecommendation(uvi: Int(result.current.uvi))
                
                // self.locationSelected.weatherIcon.image = UIImage(systemName: "\(self.getConditionWeatherId(id: Int(result.current.weather[0].id)))")
                // self.locationSelected.temp.text = "\(Int(result.current.temp))°C"
                
                // self.protectionSelected.configureView(uvi: Int(result.current.uvi))
                
                // self.hourlyForecastView.reloadData()
                // self.dailyForecastTable.reloadData()
            // }
        }).resume()
        
        //MARK: User Exact City Precise Location By Coordinates
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
                print("error location: \(error)")
            }
            
            guard let resultLocation = jsonLocation else {
                return
            }
    
            self.modelLocation = resultLocation
            
            DispatchQueue.main.async {
                self.locationLabel.text = "\(resultLocation[0].name)"
            }
            
        }).resume()
    }

}

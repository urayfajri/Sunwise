//
//  WeatherViewController.swift
//  Sunwise
//
//  Created by Uray Muhamad Noor Fajri Widiansyah on 19/12/22.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet var hourlyForecastView: UICollectionView!
    @IBOutlet var dailyForecastTable: UITableView!
    @IBOutlet var dayLabel: UILabel!
    @IBOutlet var sunriseHour: UILabel!
    @IBOutlet var sunsetHour: UILabel!
    @IBOutlet var uvSelectedView: UVSelected!
    @IBOutlet var locationSelected: LocationSelected!
    @IBOutlet var protectionSelected: ProtectionSelected!
    @IBOutlet var nowButton: UIButton!
    @IBOutlet var seeMoreButton: UIButton!
    
    var modelDaily = [DailyWeather]()
    var modelHourly = [HourlyWeather]()
    var modelLocation = [LocationCoordinate]()
    var currentWeather: CurrentWeather?
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    var uVI = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dailyForecastTable.register(WeatherTableViewCell.nib(), forCellReuseIdentifier: WeatherTableViewCell.identifier)
        dailyForecastTable.delegate = self
        dailyForecastTable.dataSource = self
        hourlyForecastView.register(HourlyCollectionViewCell.nib(), forCellWithReuseIdentifier: HourlyCollectionViewCell.identifier)
        hourlyForecastView.delegate = self
        hourlyForecastView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupLocation()
    }

    @IBAction func nowButtonPressed(_ sender: Any) {
        self.hourlyForecastView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .left, animated: true)
        getCurrentWeatherView()
    }
    
    @IBAction func seeMoreButtonPressed(_ sender: Any) {
        print("Go to modal \(uVI)")
        let controller = SunProtectionDetailViewController()
        present(controller, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "sunProtectionDetailVC" {
            let vc = segue.destination as! SunProtectionDetailViewController
            vc.uvi = uVI
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
            
            DispatchQueue.main.async {
                self.dayLabel.text = self.convertUnixToDate(unix: result.current.dt, format: "EEEE, d MMMM yyyy")
                self.sunriseHour.text = self.convertUnixToDate(unix: result.current.sunrise, format: "HH.mm")
                self.sunsetHour.text = self.convertUnixToDate(unix: result.current.sunset, format: "HH.mm")
                
                self.uVI = Int(result.current.uvi)
                
                self.uvSelectedView.uviSelectedText.text = "\(Int(result.current.uvi))"
                self.uvSelectedView.categoryUviSelectedText.text = "(\(self.getUVCategory(uvi: Int(result.current.uvi))))"
                self.uvSelectedView.recommendationText.text = self.getUVRecommendation(uvi: Int(result.current.uvi))
                
                self.locationSelected.weatherIcon.image = UIImage(systemName: "\(self.getConditionWeatherId(id: Int(result.current.weather[0].id)))")
                self.locationSelected.temp.text = "\(Int(result.current.temp))°C"
                
                self.protectionSelected.configureView(uvi: Int(result.current.uvi))
                
                self.hourlyForecastView.reloadData()
                self.dailyForecastTable.reloadData()
            }
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
                self.locationSelected.location.text = "\(resultLocation[0].name)"
            }
            
        }).resume()
    }
    
    //MARK: - Table View
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return modelDaily.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: WeatherTableViewCell.identifier, for: indexPath) as! WeatherTableViewCell
        cell.configure(with: modelDaily[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    //MARK: - Collection View
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return modelHourly.count/2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HourlyCollectionViewCell.identifier, for: indexPath) as! HourlyCollectionViewCell
        cell.configure(with: modelHourly[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 170)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        uVI = getUVIndexFromModel(model: modelHourly, index: indexPath)
        uvSelectedView.uviSelectedText.text = "\(getUVIndexFromModel(model: modelHourly, index: indexPath))"
        uvSelectedView.categoryUviSelectedText.text = "(\(getUVCategory(uvi: getUVIndexFromModel(model: modelHourly, index: indexPath))))"
        uvSelectedView.recommendationText.text = getUVRecommendation(uvi: getUVIndexFromModel(model: modelHourly, index: indexPath))
        
        locationSelected.weatherIcon.image = UIImage(systemName: "\(getConditionWeatherId(id: getWeatherIconByID(model: modelHourly, index: indexPath)))")
        locationSelected.temp.text = "\(Int(modelHourly[indexPath.row].temp))°C"
        
        protectionSelected.configureView(uvi: getUVIndexFromModel(model: modelHourly, index: indexPath))
    }
    
    //MARK: - Other
    func convertUnixToDate(unix: Int, format: String) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(unix))
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.current //current device time zone
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = format
        let strDate = dateFormatter.string(from: date)
        return strDate
    }
    
    func getUVIndexFromModel(model: [HourlyWeather], index: IndexPath) -> Int {
        return Int(model[index.row].uvi)
    }
    
    func getWeatherIconByID(model: [HourlyWeather], index: IndexPath) -> Int {
        return model[index.row].weather[0].id
    }
    
    func getCurrentWeatherView() {
        uVI = getUVIndexFromModel(model: modelHourly, index: IndexPath(row: 0, section: 0))
        uvSelectedView.uviSelectedText.text = "\(getUVIndexFromModel(model: modelHourly, index: IndexPath(row: 0, section: 0)))"
        uvSelectedView.categoryUviSelectedText.text = "(\(getUVCategory(uvi: getUVIndexFromModel(model: modelHourly, index: IndexPath(row: 0, section: 0)))))"
        uvSelectedView.recommendationText.text = getUVRecommendation(uvi: getUVIndexFromModel(model: modelHourly, index: IndexPath(row: 0, section: 0)))
        
        locationSelected.weatherIcon.image = UIImage(systemName: "\(getConditionWeatherId(id: getWeatherIconByID(model: modelHourly, index: IndexPath(row: 0, section: 0))))")
        locationSelected.temp.text = "\(Int(modelHourly[IndexPath(row: 0, section: 0).row].temp))°C"
        
        protectionSelected.configureView(uvi: getUVIndexFromModel(model: modelHourly, index: IndexPath(row: 0, section: 0)))
    }
    
    func getUVCategory(uvi: Int) -> String {
        switch uvi{
        case 0...2:
            return "low"
        case 3...6:
            return "moderate"
        case 6...7:
            return "high"
        case 8...10:
            return "very high"
        case 11...99:
            return "extreme"
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

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
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var goalLabel: UILabel!
    
    var currentWeather: CurrentWeather?
    var currentLocation: CLLocation?
    let locationManager = CLLocationManager()
    var modelLocation = [LocationCoordinate]()
    
    var duration: Date = Date()
    var finishTime: Date?
    var location: String = ""
    var startTime: Date?
    var temp: Int = 0 //MARK: To int
    var uvi: Int = 0
    var weather: Int = 0 //MARK: To int (by weather id)
    var savedStartTime = Date()
    var savedFinishedTime = Date()
    
    var timerIsCounting: Bool = false
    var scheduledTimer: Timer!
    var goalDuration: TimeInterval = 60 //seconds of target MARK: Example 60 seconds target
    
    let userDefaults = UserDefaults.standard
    let START_TIME_KEY = "startTime"
    let FINISH_TIME_KEY = "stopTime"
    let COUNTING_KEY = "countingKey"
    let circularProgress = CircularProgressBarView(frame: .zero)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //MARK: duration and finishTime should still empty / nil
        setupCircularProgressBarView()
        
        startTime = userDefaults.object(forKey: START_TIME_KEY) as? Date
        finishTime = userDefaults.object(forKey: FINISH_TIME_KEY) as? Date
        timerIsCounting = userDefaults.bool(forKey: COUNTING_KEY)
        
        //MARK: START TIMER HERE
        setStartTime(date: Date())
        startTimer()
        savedStartTime = getlocalDate()
    }

    @IBAction func finishSunbatheButtonPressed(_ sender: Any) {
        let alertConfirmation = UIAlertController(title: "Finish Sunbathe?", message: "Are you sure you want to finish your sunbath session?", preferredStyle: .alert)
        
        alertConfirmation.addAction(UIAlertAction(title: "Finish", style: .default, handler: { action in
            self.savedFinishedTime = self.getlocalDate()
            let durationInSeconds = self.savedFinishedTime.timeIntervalSinceReferenceDate - self.savedStartTime.timeIntervalSinceReferenceDate
            //MARK: CORE DATA IS CREATED IN HERE ONLY AFTER FINISH BUTTON IS PRESSED
            print("\n===== SESSION CREATED WITH DATA =====")
            print("location : \(self.location)")
            print("weatherID : \(self.weather)") //MARK: to Int (by wheather id, not name)
            print("temp : \(self.temp)") //MARK: to Int
            print("uvi : \(self.uvi)")
            print("start time: \(self.savedStartTime)")
            print("finish time: \(self.savedFinishedTime)")
            print("duration in seconds: \(durationInSeconds)\n===============\n")
            
            
            //TODO: Add Core Data Session Here
            
            
            self.setFinishTime(date: nil)
            self.setStartTime(date: nil)
            self.timerLabel.text = self.makeTimeString(hour: 0, min: 0, sec: 0)
            self.circularProgress.progressAnimation(duration: 1, value: 0)
            self.finishTimer()
            self.dismiss(animated: true)
        }))
        
        alertConfirmation.addAction(UIAlertAction(title: "cancel", style: .cancel, handler: nil))
        
        self.present(alertConfirmation, animated: true, completion: nil)
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
                self.weather = result.current.weather[0].id
                self.temp = Int(result.current.temp)
                self.uvi = Int(result.current.uvi)
                
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
                self.location = resultLocation[0].name
                
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
    
    func setupCircularProgressBarView() {
        circularProgress.createCircularPath()
        circularProgress.center = view.center
        view.addSubview(circularProgress)
    }
    
    func startTimer(){
        scheduledTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(refreshValue), userInfo: nil, repeats: true)
        setTimerCounting(true)
    }
    
    func finishTimer(){
        if scheduledTimer != nil {
            scheduledTimer.invalidate()
        }
        
        setTimerCounting(false)
    }
    
    func setTimerCounting(_ val: Bool){
        timerIsCounting = val
        userDefaults.set(timerIsCounting, forKey: COUNTING_KEY)
    }
    
    func setStartTime(date: Date?){
        startTime = date
        userDefaults.set(startTime, forKey: START_TIME_KEY)
    }
    
    func setFinishTime(date: Date?){
        finishTime = date
        userDefaults.set(finishTime, forKey: FINISH_TIME_KEY)
    }
    
    @objc func refreshValue(){
        if let start = startTime {
            let diff = Date().timeIntervalSince(start)
            setTimeLabel(Int(diff))
            setRingAnimation(Int(diff))
        }
        else {
            finishTimer()
            setTimeLabel(0)
        }
    }
    
    func calcRestartTime(start: Date, finish: Date) -> Date {
        let diff = start.timeIntervalSince(finish)
        return Date().addingTimeInterval(diff)
    }
    
    func setTimeLabel(_ val: Int){
        let time = secondsToHoursMinutesSeconds(val)
        let timeString = makeTimeString(hour: time.0, min: time.1, sec: time.2)
        timerLabel.text = timeString
    }
    
    func secondsToHoursMinutesSeconds(_ ms: Int) -> (Int, Int, Int) {
        let hour = ms/3600
        let min = (ms % 3600) / 60
        let sec = (ms % 3600) % 60
        return (hour, min, sec)
    }
    
    func makeTimeString(hour: Int, min: Int, sec: Int) -> String {
        var timeString = ""
        timeString += String(format: "%02d", hour)
        timeString += ":"
        timeString += String(format: "%02d", min)
        timeString += ":"
        timeString += String(format: "%02d", sec)
        return timeString
    }
    
    //MARK: - Ring Animation
    func setUpCircularProgressBarView(){
        circularProgress.createCircularPath()
        circularProgress.center = view.center
        view.addSubview(circularProgress)
    }
    
    func setRingAnimation(_ val: Int) {
        let time = secondsToHoursMinutesSeconds(val)
        let totalseconds = (time.0 * 3600) + (time.1 * 60) + time.2
        let progressValue = Float(TimeInterval(totalseconds) / goalDuration)
        circularProgress.progressAnimation(duration: 0.1, value: progressValue)
    }
    
    func getlocalDate()-> Date {
        let nowUTC = Date()
        let timeZoneOffSet = Double(TimeZone.current.secondsFromGMT(for: nowUTC))
        guard let localDate = Calendar.current.date(byAdding: .second, value: Int(timeZoneOffSet), to: nowUTC) else {
            return Date()
        }
        return localDate
    }
}

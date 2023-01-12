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
    @IBOutlet weak var circularProgressBarView: CircularProgressBarView!
    @IBOutlet weak var viewCurrentUV: UIView!
    
    var currentWeather: CurrentWeather?
    var currentLocation: CLLocation?
    let locationManager = CLLocationManager()
    var modelLocation = [LocationCoordinate]()
    
    var duration: Date = Date()
    var finishTime: Date?
    var location: String = ""
    var startTime: Date?
    var temp: Int = 0
    var uvi: Int = 0
    var weather: Int = 0
    var savedStartTime = Date()
    var savedFinishedTime = Date()
    
    var timerIsCounting: Bool = false
    var scheduledTimer: Timer!
    var goalDuration: TimeInterval = 0
    
    let userDefaults = UserDefaults.standard
    let START_TIME_KEY = "startTime"
    let FINISH_TIME_KEY = "stopTime"
    let COUNTING_KEY = "countingKey"
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var user: User?
    var todayDailySunbathe: DailySunbathe?
    var dailySunbathes = [DailySunbathe]()
    var sessions = [Session]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCircularProgressBarView()
        getUserInfo()
        viewCurrentUV.layer.cornerRadius = 10
        
        let duration = todayDailySunbathe != nil ?
                        ((todayDailySunbathe?.target_time ?? 0) / 60) - ((todayDailySunbathe?.achieve_time ?? 0) / 60)
                            :
                        (user?.sunbath_goal ?? 0)
        goalDuration = TimeInterval(duration * 60)
        print("goal duration: ", goalDuration)
        
        startTime = userDefaults.object(forKey: START_TIME_KEY) as? Date
        finishTime = userDefaults.object(forKey: FINISH_TIME_KEY) as? Date
        timerIsCounting = userDefaults.bool(forKey: COUNTING_KEY)
        
        let sunbatheAchieveTimeToday = (todayDailySunbathe?.achieve_time ?? 0) / 60
        let sunbatheGoalToday = todayDailySunbathe != nil ? (todayDailySunbathe?.target_time ?? 0) / 60 : user?.sunbath_goal ?? 0
        if(goalDuration <= 0.0) {
            goalLabel.text = "Your Have Achieved You \(user?.sunbath_goal ?? -1) min(s) Goal ✅"
        }

        setStartTime(date: Date())
        startTimer()
        savedStartTime = Date()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupLocation()
    }

    func getUserInfo(){
        do {
            let users = try context.fetch(User.fetchRequest())
            if(!users.isEmpty) {
                user = users[0]
            }
            
            //MARK: Fetch all daily sunbathe data from existing user
            self.fetchUserDailySunbathe()
            
            //MARK: get today daily sunbathe
            self.getDailySunbatheByDate(selectedDate: Date())
        }
        catch {
            print("error : \(error)")
        }
    }
    
    @IBAction func finishSunbatheButtonPressed(_ sender: Any) {
        let alertConfirmation = UIAlertController(title: "Finish Sunbathe?", message: "Are you sure you want to finish your sunbath session?", preferredStyle: .alert)
        
        alertConfirmation.addAction(UIAlertAction(title: "Finish", style: .default, handler: { action in
            self.savedFinishedTime = Date()
            let durationInSeconds = self.savedFinishedTime.timeIntervalSinceReferenceDate - self.savedStartTime.timeIntervalSinceReferenceDate
          
            print("\n===== SESSION CREATED WITH DATA =====")
            print("location : \(self.location)")
            print("weatherID : \(self.weather)")
            print("temp : \(self.temp)")
            print("uvi : \(self.uvi)")
            print("start time: \(self.savedStartTime)") //MARK: Ignore the local time here (only in terminal, in actual device and simulator working fine)
            print("finish time: \(self.savedFinishedTime)") //MARK: Ignore the local time here (only in terminal, in actual device and simulator working fine)
            print("target time: \(self.goalDuration)")
            print("duration in seconds: \(durationInSeconds)\n===============\n")
            
            
            //TODO: Add Core Data Session Here
            if(self.dailySunbathes.isEmpty) {
                //create new if still empty
                self.createDailySunbathe(
                    achieveTime: Int32(durationInSeconds),
                    targetTime: (self.user?.sunbath_goal ?? 0) * 60,
                    duration: Int32(durationInSeconds),
                    location: self.location,
                    startTime: self.savedStartTime,
                    finishTime: self.savedFinishedTime,
                    temp: Int32(self.temp),
                    uvi: Int32(self.uvi),
                    weatherID: Int32(self.weather)
                )
            } else {
                if((self.todayDailySunbathe ) == nil) {
                    //create new if today daily sunbathe not exist
                    self.createDailySunbathe(
                        achieveTime: Int32(durationInSeconds),
                        targetTime: (self.user?.sunbath_goal ?? 0) * 60,
                        duration: Int32(durationInSeconds),
                        location: self.location,
                        startTime: self.savedStartTime,
                        finishTime: self.savedFinishedTime,
                        temp: Int32(self.temp),
                        uvi: Int32(self.uvi),
                        weatherID: Int32(self.weather)
                    )
                } else {
                    
                    // print("ada daily sunbathe hari ini(before): ", self.todayDailySunbathe?.achieve_time, self.todayDailySunbathe?.target_time)
                    self.updateDailySunbathe(
                        dailySunbathe: self.todayDailySunbathe,
                        updateAchieveTime: Int32(durationInSeconds)
                    )
                    self.createSession(dailySunbathe: self.todayDailySunbathe,
                                       duration: Int32(durationInSeconds),
                                       location: self.location,
                                       startTime: self.savedStartTime,
                                       finishTime: self.savedFinishedTime,
                                       temp: Int32(self.temp),
                                       uvi: Int32(self.uvi),
                                       weatherID: Int32(self.weather)
                    )
                    // print("ada daily sunbathe hari ini(after): ", self.todayDailySunbathe?.achieve_time, self.todayDailySunbathe?.target_time)
                }
            }
            
            self.setFinishTime(date: nil)
            self.setStartTime(date: nil)
            self.timerLabel.text = self.makeTimeString(hour: 0, min: 0, sec: 0)
            self.circularProgressBarView.progressAnimation(duration: 1, value: 0)
            self.finishTimer()
            self.dismiss(animated: true)
        }))
        
        alertConfirmation.addAction(UIAlertAction(title: "cancel", style: .cancel, handler: nil))
        
        self.present(alertConfirmation, animated: true, completion: nil)
    }
    
    //MARK: Create Daily Sunbathe core data model
    func createDailySunbathe (achieveTime: Int32, targetTime: Int32, duration: Int32, location: String, startTime: Date, finishTime: Date, temp: Int32, uvi: Int32, weatherID: Int32) {
        let newDailySunbathe = DailySunbathe(context: self.context)
        newDailySunbathe.date = Date()
        newDailySunbathe.achieve_time = achieveTime
        newDailySunbathe.target_time = targetTime
        
        createSession(dailySunbathe: newDailySunbathe, duration: duration, location: location, startTime: startTime, finishTime: finishTime, temp: temp, uvi: uvi, weatherID: weatherID)
        
        user?.addToDailySunbathes(newDailySunbathe)

        do{
            try context.save()
        }
        catch
        {
            print(error)
        }
    }
    
    //MARK: - Update Daily Sunbathe core data model
    func updateDailySunbathe(dailySunbathe: DailySunbathe?, updateAchieveTime: Int32)
    {
        dailySunbathe?.achieve_time += updateAchieveTime
 
        do{
            try context.save()
        }
        catch
        {
            print(error)
        }
    }
    
    //MARK: Create Session Sunbathe core data model
    func createSession (dailySunbathe: DailySunbathe?, duration: Int32, location: String, startTime: Date, finishTime: Date, temp: Int32, uvi: Int32, weatherID: Int32) {
        let newSession = Session(context: self.context)
        
        newSession.duration = duration
        newSession.location = location
        newSession.start_time = startTime
        newSession.finish_time = finishTime
        newSession.temp = temp
        newSession.uv_index = uvi
        newSession.weather_id = weatherID
        
        dailySunbathe?.addToSessions(newSession)

        do{
            try context.save()
        }
        catch
        {
            print(error)
        }
    }
    
    func fetchUserDailySunbathe()
    {
        if let datas = user?.dailySunbatheArray {
            dailySunbathes = datas
        }
    }
    
    func getDailySunbatheByDate(selectedDate: Date) {
        let dateFormat = DateFormatter()
        dateFormat.dateStyle = .medium
        
        let dateCalendar = dateFormat.string(from: selectedDate)
        
        for dailySunbathe in dailySunbathes {
            let dailySunbatheDate = dateFormat.string(from: dailySunbathe.date!)
            if(dateCalendar == dailySunbatheDate){
                todayDailySunbathe = dailySunbathe
                break
            }
        }
        
    }
    
    
    //MARK: - CORE LOCATION
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
        circularProgressBarView.createCircularPath()
        circularProgressBarView.center = view.center
        view.addSubview(circularProgressBarView)
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
        let durationPerMinute = Int32(val/60)
        let sunbatheAchieveTimeToday = (todayDailySunbathe?.achieve_time ?? 0) / 60
        let durationAchieveTimeTotal = sunbatheAchieveTimeToday+durationPerMinute
        
        let sunbatheGoalToday = todayDailySunbathe != nil ? (todayDailySunbathe?.target_time ?? 0) / 60 : user?.sunbath_goal ?? 0
        
        if Int(goalDuration) == val {
            self.goalLabel.text = "Your Have Achieved You \(user?.sunbath_goal ?? -1) min(s) Goal ✅"
        } else if (val % 60 == 0 && ((sunbatheGoalToday - durationAchieveTimeTotal) > 0)) {
            
            goalLabel.text = "Progress : \(durationAchieveTimeTotal) / \(sunbatheGoalToday) Min"
        }
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
        circularProgressBarView.createCircularPath()
        circularProgressBarView.center = view.center
        view.addSubview(circularProgressBarView)
    }
    
    func setRingAnimation(_ val: Int) {
        let time = secondsToHoursMinutesSeconds(val)
        let totalseconds = (time.0 * 3600) + (time.1 * 60) + time.2
        let progressValue = Float(TimeInterval(totalseconds) / (goalDuration > 0.0 ? goalDuration : 1))
        circularProgressBarView.progressAnimation(duration: 0.1, value: progressValue)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        if #available(iOS 13.0, *) {
            if self.traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
               setupCircularProgressBarView()
            }
        }
    }
    
}

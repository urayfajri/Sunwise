//
//  SettingViewController.swift
//  Sunwise
//
//  Created by Uray Muhamad Noor Fajri Widiansyah on 19/12/22.
//

import UIKit
import CoreLocation
import UserNotifications

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
    @IBOutlet weak var idealSunbathSwitch: UISwitch!
    @IBOutlet weak var sunProtectionSwitch: UISwitch!
    
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
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupLocation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
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
        
        idealSunbathSwitch.setOn(user?.ideal_time_notif ?? false, animated: true)
        sunProtectionSwitch.setOn(user?.sun_protection_notif ?? false, animated: true)
        
        if idealSunbathSwitch.isOn {
            self.checkForSunbathePermission()
        }
        
        if sunProtectionSwitch.isOn {
            self.checkForSunProtectionPermission()
        }
    
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
    
    @IBAction func idealSunbatheSwitchChanged(_ sender: UISwitch) {
        if sender.isOn {
            checkForSunbathePermission()
            showAlertSunbatheNotification(isActive: true)
        } else {
            cancelSunbatheNotification()
            showAlertSunbatheNotification(isActive: false)
        }
        updateIdealTimeNotif(user: user!)
    }
    
    @IBAction func sunProtectionSwitchChanged(_ sender: UISwitch) {
        if sender.isOn {
            checkForSunProtectionPermission()
            showAlertProctectionNotification(isActive: true)
        } else {
            cancelProtectionNotification()
            showAlertProctectionNotification(isActive: false)
        }
        updateSunProtectionNotif(user: user!)
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
    
    //MARK: - Update core data user - ideal time notif
    func updateIdealTimeNotif(user: User)
    {
        user.ideal_time_notif = self.idealSunbathSwitch.isOn
 
        do{
            try context.save()
        }
        catch
        {
            print(error)
        }
    }
    
    //MARK: - Update core data user - sun protection recommended
    func updateSunProtectionNotif(user: User)
    {
        user.sun_protection_notif = self.sunProtectionSwitch.isOn
 
        do{
            try context.save()
        }
        catch
        {
            print(error)
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
    
    //MARK: Local Notification - ideal sunbathe time
    func checkForSunbathePermission() {
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.getNotificationSettings { settings in
            switch settings.authorizationStatus {
                case .authorized:
                    self.dispatchSunbatheNotification()
                case .denied:
                    return
                case .notDetermined:
                notificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { didAllow, error in
                        if didAllow {
                            self.dispatchSunbatheNotification()
                        }
                    }
                default:
                    return
            }
        }
    }
    
    //MARK: Local Notification - ideal sunbathe time
    func checkForSunProtectionPermission() {
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.getNotificationSettings { settings in
            switch settings.authorizationStatus {
                case .authorized:
                    self.dispatchSunProtectionNotification()
                case .denied:
                    return
                case .notDetermined:
                notificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { didAllow, error in
                        if didAllow {
                            self.dispatchSunProtectionNotification()
                        }
                    }
                default:
                    return
            }
        }
    }
    
    //MARK: Dispatch notification for sunbathe time
    func dispatchSunbatheNotification() {
        let identifier = "sunbathe-notification"
        let title = "Time to Sunbathe"
        let body = "It’s perfect time to do sunbathing!"
        let isDaily = true
        
        let notificationCenter = UNUserNotificationCenter.current()
        
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        
        notificationCenter.removePendingNotificationRequests(withIdentifiers: [identifier])
        
        for (index, model) in modelHourly.enumerated() {
            if (index < modelHourly.count / 2) {
                // safe uvi index
                if (model.uvi > 0.00 && model.uvi < 2.00) {
                    let dayHourly = getTimeForDate(Date(timeIntervalSince1970: Double(model.dt)))

                    // get hour string
                    let hourString = dayHourly.prefix(2)

                    // get minute string
                    let indexMinute = dayHourly.index(dayHourly.endIndex, offsetBy: -2)
                    let minuteString = dayHourly[indexMinute...]

                    let hour = Int(hourString)!
                    let minute = Int(minuteString)!

                    let calendar = Calendar.current
                    var dateComponents = DateComponents(calendar: calendar, timeZone: TimeZone.current)
                    dateComponents.hour = hour
                    dateComponents.minute = minute

                    let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: isDaily)
                    let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)

                    notificationCenter.add(request)
                }
            }
        }
    }
    
    //MARK: Dispatch notification for sunbathe time
    func dispatchSunProtectionNotification() {
        let identifier = "sun-protection-notification"
        let title = "Sun Protection Recommendation"
        let isDaily = true
        
        let notificationCenter = UNUserNotificationCenter.current()
        
        notificationCenter.removePendingNotificationRequests(withIdentifiers: [identifier])
        
        // for check hour range based on changed message body
        var currentBody: String = ""
        
        for (index, model) in modelHourly.enumerated() {
            if (index < modelHourly.count / 2) {
                var body: String = ""
                var hour: Int = 0
                var minute: Int = 0
                
                // unsafe uvi index for sunbathing
                if (model.uvi >= 2.00 && model.uvi < 5.00) {
                
                    let dayHourly = getTimeForDate(Date(timeIntervalSince1970: Double(model.dt)))

                    // get hour string
                    let hourString = dayHourly.prefix(2)

                    // get minute string
                    let indexMinute = dayHourly.index(dayHourly.endIndex, offsetBy: -2)
                    let minuteString = dayHourly[indexMinute...]

                    hour = Int(hourString)!
                    minute = Int(minuteString)!

                    print("Moderate level at hour: ", hour)
                    
                    body = "Sun Protection Is Recommended When Outside ~ Current UVI is on Moderate Level."
                
                }
                else if(model.uvi >= 5.00 && model.uvi < 7.00) {
                    let dayHourly = getTimeForDate(Date(timeIntervalSince1970: Double(model.dt)))

                    // get hour string
                    let hourString = dayHourly.prefix(2)

                    // get minute string
                    let indexMinute = dayHourly.index(dayHourly.endIndex, offsetBy: -2)
                    let minuteString = dayHourly[indexMinute...]

                    hour = Int(hourString)!
                    minute = Int(minuteString)!

                    print("High Level at hour: ", hour)
                    
                    body = "Sun Protection Is a Must When Outside ~ Current UVI is on High Level."
                    
                }
                else if ( model.uvi >= 7.00 && model.uvi < 10.00) {
                    let dayHourly = getTimeForDate(Date(timeIntervalSince1970: Double(model.dt)))

                    // get hour string
                    let hourString = dayHourly.prefix(2)

                    // get minute string
                    let indexMinute = dayHourly.index(dayHourly.endIndex, offsetBy: -2)
                    let minuteString = dayHourly[indexMinute...]

                    hour = Int(hourString)!
                    minute = Int(minuteString)!

                    print("Very  High Level at hour: ", hour)
                    
                    body = "Limit Outdoor Activity, Sun Protection Is a Must When Outside ~ Current UVI is on Very High Level."
                    
                }
                else if (model.uvi >= 10.00) {
                    let dayHourly = getTimeForDate(Date(timeIntervalSince1970: Double(model.dt)))

                    // get hour string
                    let hourString = dayHourly.prefix(2)

                    // get minute string
                    let indexMinute = dayHourly.index(dayHourly.endIndex, offsetBy: -2)
                    let minuteString = dayHourly[indexMinute...]

                    hour = Int(hourString)!
                    minute = Int(minuteString)!

                    print("Extreme Level at hour: ", hour)
                    
                    body = "Stay Indoor, Sun Protection Is a Must When Outside ~ Current UVI is on Extreme Level"
                    
                } else {
                    continue
                }
                
                if(!currentBody.contains(body)) {
                    print("message: ", body)
                    print("current message: ", currentBody)
                    
                    currentBody = body
                
                    let content = UNMutableNotificationContent()
                    content.title = title
                    content.body = body
                    content.sound = .default

                    let calendar = Calendar.current
                    var dateComponents = DateComponents(calendar: calendar, timeZone: TimeZone.current)
                    dateComponents.hour = hour
                    dateComponents.minute = minute

                    let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: isDaily)
                    let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)

                    notificationCenter.add(request)
                }
                
            }
        }
    }
    
    func cancelSunbatheNotification() {
        let center = UNUserNotificationCenter.current()
        let identifier = "sunbathe-notification"
        
        center.removePendingNotificationRequests(withIdentifiers: [identifier])
        center.removeDeliveredNotifications(withIdentifiers: [identifier])
    }
    
    func cancelProtectionNotification() {
        let center = UNUserNotificationCenter.current()
        let identifier = "protection-notification"
        
        center.removePendingNotificationRequests(withIdentifiers: [identifier])
        center.removeDeliveredNotifications(withIdentifiers: [identifier])
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
    
    func getTimeForDate(_ date: Date?) -> String {
        guard let inputDate = date else {
            return ""
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: inputDate)
    }
    
    func getUVIndexFromModel(model: [HourlyWeather], index: IndexPath) -> Int {
        return Int(model[index.row].uvi)
    }
    
    
    //MARK: Alert Sunbathe Notification
    func showAlertSunbatheNotification(isActive: Bool) {
        let messageActivated = "Your sunbathe notification is activated"
        let messageDeactivated = "Your sunbathe notification is deactivated"
        
        let alertControl = UIAlertController(title: "Sunbathe Notification", message: isActive ? messageActivated : messageDeactivated, preferredStyle: .alert)
        alertControl.addAction(UIAlertAction(title: "OK", style: .default, handler: {_ in
            alertControl.dismiss(animated: true, completion: nil)
        }))
        self.present(alertControl, animated: true)
    }
    
    //MARK: Alert Protection Notification
    func showAlertProctectionNotification(isActive: Bool) {
        let messageActivated = "Your sun protection notification is activated"
        let messageDeactivated = "Your sun protection notification is deactivated"
        
        let alertControl = UIAlertController(title: "Sun Protection Notification", message: isActive ? messageActivated : messageDeactivated, preferredStyle: .alert)
        alertControl.addAction(UIAlertAction(title: "OK", style: .default, handler: {_ in
            alertControl.dismiss(animated: true, completion: nil)
        }))
        self.present(alertControl, animated: true)
    }

}

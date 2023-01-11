//
//  HistoryDetailViewController.swift
//  Sunwise
//
//  Created by Ariel Waraney on 10/01/23.
//

import UIKit

class HistoryDetailViewController: UIViewController {

    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var statementLabel: UILabel!
    @IBOutlet weak var sessionLabel: UILabel!
    @IBOutlet weak var circularProgressBarView: CircularProgressBarView!
    
    @IBOutlet weak var tableViewSessions: UITableView!
    @IBOutlet weak var heightTableView: NSLayoutConstraint!
    
    var selectedDate = Date()
    var achieveTime = 0
    var targetTime = 0
    var sessions = [Session]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDateTitle()
        displayHistoryDetail()
        setupCircularProgressBarHistoryView()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: animated)
        tabBarController?.tabBar.isHidden = true
        self.tableViewSessions.addObserver(self, forKeyPath: "contentSize", options: .new,  context: nil)
        self.tableViewSessions.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
        self.tableViewSessions.removeObserver(self, forKeyPath: "contentSize")
    }
    
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "contentSize" {
            if let newValue = change?[.newKey]{
                let newSize = newValue as! CGSize
                heightTableView.constant = newSize.height
            }
        }
    }
    
    func setupCircularProgressBarHistoryView() {
        circularProgressBarView.createCircularPath()
        let valueProgress = Float(achieveTime) / Float(targetTime)
        circularProgressBarView.progressAnimation(duration: 0.1, value: valueProgress)
    }
    
    public func setupDateTitle() {
        let formatter = DateFormatter()
        formatter.dateFormat = "E, d MMM yyyy"
        let selectedDate = formatter.string(from: selectedDate)
        title = selectedDate
    }
    
    func displayHistoryDetail() {
        progressLabel.text = "\(convertSecondsToMin(seconds: achieveTime))/\(convertSecondsToMin(seconds: targetTime)) min"
        sessionLabel.text = "\(sessions.count)"
        statementLabel.text = "\"\(getStatementLabel(achiveTime: achieveTime, targetTime: targetTime))\""
    }
    
    func convertSecondsToMin (seconds: Int) -> Int {
        let min = (seconds / 60)
        return min
    }
    
    func getStatementLabel(achiveTime: Int, targetTime: Int) -> String {
        let value = Float(achiveTime)/Float(targetTime)
        switch value {
        case 0..<0.3:
            return "Good start, try better next time 😄"
        case 0.3..<0.5:
            return "Don't give up to try your best next time ☺️"
        case 0.5..<0.8:
            return "Half way there, keep improving 🤗"
        case 0.8..<1.0:
            return "Great, you are almost there 😍"
        case 1.0...:
            return "Goal Achieved ✅, Congratulations on closing the ring 🥳🤩"
        default:
            return ""
        }
    }
    
    func getDurationTimeString(seconds : Int) -> String {
        if seconds < 60 {
            return "\(seconds) sec"
        }
        else {
            return "\(convertSecondsToMin(seconds: seconds)) min"
        }
    }
    
    func getHrMinSecByDotFormat(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        let dateHour = formatter.string(from: date)
        return "\(dateHour)"
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

extension HistoryDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sessions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "SessionDetailCell", for: indexPath) as? SessionDetailTableViewCell {
            cell.sessionNumberLabel.text = "Sunbathe Detail - Session \(indexPath.row+1)"
            cell.durationLabel.text = getDurationTimeString(seconds: Int(sessions[indexPath.row].duration))
            cell.startTimeLabel.text = getHrMinSecByDotFormat(date: sessions[indexPath.row].start_time ?? Date())
            cell.finishTimeLabel.text = getHrMinSecByDotFormat(date: sessions[indexPath.row].finish_time ?? Date())
            cell.uviLabel.text = "\(Int(sessions[indexPath.row].uv_index))"
            cell.tempLabel.text = "\(Int(sessions[indexPath.row].temp))°C"
            cell.weatherIcon.image = UIImage(systemName: getConditionWeatherId(id: Int(sessions[indexPath.row].weather_id)))
            cell.locationLabel.text = sessions[indexPath.row].location
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}

//
//  WeatherTableViewCell.swift
//  Sunwise
//
//  Created by Ariel Waraney on 21/12/22.
//

import UIKit

class WeatherTableViewCell: UITableViewCell {

    @IBOutlet var day: UILabel!
    @IBOutlet var weatherIcon: UIImageView!
    @IBOutlet var temp: UILabel!
    @IBOutlet var uvi: UILabel!
    
    static let identifier = "WeatherTableViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "WeatherTableViewCell", bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(with model: DailyWeather) {
        self.day.text = getDateForDate(Date(timeIntervalSince1970: Double(model.dt)))
        self.weatherIcon.image = UIImage(systemName: getConditionWeatherId(id: model.weather[0].id))
        self.temp.text = "\(Int(model.temp.max))°C"
        self.uvi.text = "\(Int(model.uvi))"
    }
    
    func getDateForDate(_ date: Date?) -> String {
        guard let inputDate = date else {
            return ""
        }
        let formatter = DateFormatter()
        formatter.dateFormat = "E, d MMM"
        return formatter.string(from: inputDate)
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

//
//  HourlyCollectionViewCell.swift
//  Sunwise
//
//  Created by Ariel Waraney on 21/12/22.
//

import UIKit

class HourlyCollectionViewCell: UICollectionViewCell {

    @IBOutlet var symbolText: UILabel!
    @IBOutlet var uVI: UILabel!
    @IBOutlet var hour: UILabel!
    @IBOutlet weak var viewColor: UIView!
    
    static let identifier = "HourlyCollectionViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "HourlyCollectionViewCell", bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configure(with model: HourlyWeather){
        self.symbolText.text = "☀️"
        self.uVI.text = "\(Int(model.uvi))"
        self.hour.text = getTimeForDate(Date(timeIntervalSince1970: Double(model.dt)))
        self.viewColor.layer.cornerRadius = 5
    }
    
    func getTimeForDate(_ date: Date?) -> String {
        guard let inputDate = date else {
            return ""
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: inputDate)
    }
}

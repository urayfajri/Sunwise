//
//  LocationCurrent.swift
//  Sunwise
//
//  Created by Ariel Waraney on 30/12/22.
//

import UIKit

class LocationCurrent: UIView {

    @IBOutlet var weatherIcon: UIImageView!
    @IBOutlet var temp: UILabel!
    @IBOutlet var location: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        viewInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        viewInit()
    }
    
    func viewInit(){
        let xibView = Bundle.main.loadNibNamed("LocationCurrent", owner: self)![0] as! UIView
        xibView.frame = self.bounds
        addSubview(xibView)
    }
    
    func setWeatherIcon(text: String){
        self.weatherIcon.image = UIImage(systemName: text)
    }
    
    func setTemperature(text: String){
        self.temp.text = text
    }
    
    func setLocation(text: String){
        self.location.text = text
    }
}

//
//  LocationSelected.swift
//  Sunwise
//
//  Created by Ariel Waraney on 21/12/22.
//

import UIKit

class LocationSelected: UIView {

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
    
    func viewInit() {
        let xibView = Bundle.main.loadNibNamed("LocationSelected", owner: self)![0] as! UIView
        xibView.frame = self.bounds
        addSubview(xibView)
    }
    
    func setWeatherIconView(text: String) {
        self.weatherIcon.image = UIImage(systemName: text)
    }
    
    func setTemperatureText(text: String) {
        self.temp.text = text
    }
    
    func setLoactionText(text: String) {
        self.location.text = text
    }

}

//
//  UVCurrent.swift
//  Sunwise
//
//  Created by Ariel Waraney on 30/12/22.
//

import UIKit

class UVCurrent: UIView {

    @IBOutlet weak var uvi: UILabel!
    @IBOutlet weak var categoryText: UILabel!
    @IBOutlet weak var recommendationText: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func viewInit(){
        let xibView = Bundle.main.loadNibNamed("UVCurrent", owner: self)![0] as! UIView
        xibView.frame = self.bounds
        addSubview(xibView)
    }
    
    func setUviText(text: String){
        self.uvi.text = text
    }
    
    func setCategoryText(text: String){
        self.categoryText.text = text
    }

    func setRecommendationText(text: String){
        self.recommendationText.text = text
    }
    
}

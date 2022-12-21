//
//  UVSelected.swift
//  Sunwise
//
//  Created by Ariel Waraney on 21/12/22.
//

import UIKit

class UVSelected: UIView {

    @IBOutlet var uviSelectedText: UILabel!
    @IBOutlet var categoryUviSelectedText: UILabel!
    @IBOutlet var recommendationText: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        viewInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        viewInit()
    }
    
    func viewInit() {
        let xibView = Bundle.main.loadNibNamed("UVSelected", owner: self)![0] as! UIView
        xibView.frame = self.bounds
        addSubview(xibView)
    }
    
    func setUviSelectedText(text: String) {
        self.uviSelectedText.text = text
    }
    
    func setCategorySelectedText(text: String) {
        self.categoryUviSelectedText.text = text
    }
    
    func setRecommendationText(text: String) {
        self.recommendationText.text = text
    }

}

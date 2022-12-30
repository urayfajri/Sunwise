//
//  UVCurrent.swift
//  Sunwise
//
//  Created by Ariel Waraney on 30/12/22.
//

import UIKit

class UVCurrent: UIView {

    @IBOutlet var uvi: UILabel!
    @IBOutlet var categoryText: UILabel!
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
        let xibView = Bundle.main.loadNibNamed("UVCurrent", owner: self)![0] as! UIView
        xibView.frame = self.bounds
        addSubview(xibView)
    }
}

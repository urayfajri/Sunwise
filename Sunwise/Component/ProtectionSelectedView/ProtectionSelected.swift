//
//  ProtectionSelected.swift
//  Sunwise
//
//  Created by Ariel Waraney on 21/12/22.
//

import UIKit

class ProtectionSelected: UIView {

    @IBOutlet var sunglassesIcon: UILabel!
    @IBOutlet var sunglassesText: UILabel!
    @IBOutlet var clothesIcon: UILabel!
    @IBOutlet var clothesText: UILabel!
    @IBOutlet var sunscreenIcon: UILabel!
    @IBOutlet var sunscreenText: UILabel!
    @IBOutlet var hatIcon: UILabel!
    @IBOutlet var hatText: UILabel!
    @IBOutlet var shelterIcon: UILabel!
    @IBOutlet var shelterText: UILabel!
    @IBOutlet var indoorIcon: UILabel!
    @IBOutlet var indoorText: UILabel!
    @IBOutlet var noProtectionText: UILabel!

    override init(frame: CGRect) {
        super.init(frame: frame)
        viewInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        viewInit()
    }
    
    func viewInit() {
        let xibView = Bundle.main.loadNibNamed("ProtectionSelected", owner: self)![0] as! UIView
        xibView.frame = self.bounds
        addSubview(xibView)
    }
    
    func configureView(uvi: Int) {
        switch uvi{
        case 0...2:
            noProtectionText.alpha = 1
            sunglassesIcon.alpha = 0
            sunglassesText.alpha = 0
            clothesIcon.alpha = 0
            clothesText.alpha = 0
            sunscreenIcon.alpha = 0
            sunscreenText.alpha = 0
            hatIcon.alpha = 0
            hatText.alpha = 0
            shelterIcon.alpha = 0
            shelterText.alpha = 0
            indoorIcon.alpha = 0
            indoorText.alpha = 0
            return
        case 3...6:
            noProtectionText.alpha = 0
            sunglassesIcon.alpha = 1
            sunglassesText.alpha = 1
            clothesIcon.alpha = 1
            clothesText.alpha = 1
            sunscreenIcon.alpha = 1
            sunscreenText.alpha = 1
            hatIcon.alpha = 1
            hatText.alpha = 1
            shelterIcon.alpha = 1
            shelterText.alpha = 1
            indoorIcon.alpha = 0
            indoorText.alpha = 0
            return
        case 6...7:
            noProtectionText.alpha = 0
            sunglassesIcon.alpha = 1
            sunglassesText.alpha = 1
            clothesIcon.alpha = 1
            clothesText.alpha = 1
            sunscreenIcon.alpha = 1
            sunscreenText.alpha = 1
            hatIcon.alpha = 1
            hatText.alpha = 1
            shelterIcon.alpha = 1
            shelterText.alpha = 1
            indoorIcon.alpha = 0
            indoorText.alpha = 0
            return
        case 8...10:
            noProtectionText.alpha = 0
            sunglassesIcon.alpha = 1
            sunglassesText.alpha = 1
            clothesIcon.alpha = 1
            clothesText.alpha = 1
            sunscreenIcon.alpha = 1
            sunscreenText.alpha = 1
            hatIcon.alpha = 1
            hatText.alpha = 1
            shelterIcon.alpha = 1
            shelterText.alpha = 1
            indoorIcon.alpha = 1
            indoorText.alpha = 1
            return
        case 11...99:
            noProtectionText.alpha = 0
            sunglassesIcon.alpha = 1
            sunglassesText.alpha = 1
            clothesIcon.alpha = 1
            clothesText.alpha = 1
            sunscreenIcon.alpha = 1
            sunscreenText.alpha = 1
            hatIcon.alpha = 1
            hatText.alpha = 1
            shelterIcon.alpha = 1
            shelterText.alpha = 1
            indoorIcon.alpha = 1
            indoorText.alpha = 1
            return
        default:
            noProtectionText.alpha = 0
            return
        }
    }

}

//
//  DashboardViewController.swift
//  Sunwise
//
//  Created by Uray Muhamad Noor Fajri Widiansyah on 20/12/22.
//

import UIKit

class OnboardingViewController: UIViewController {

    
    @IBOutlet weak var onBoardingImage: UIImageView!
    @IBOutlet weak var welcomeTitleLabel: UILabel!
    @IBOutlet weak var subtitleTextView: UITextView!
    @IBOutlet weak var setSkinProfileButton: UIButton!
    @IBOutlet weak var titleDescriptionTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func setSkinProfileButtonTapped(_ sender: Any) {
        hideElementPageOne()
    }
    
    func hideElementPageOne() {
        onBoardingImage.isHidden = true
        welcomeTitleLabel.isHidden = true
        titleDescriptionTextView.isHidden = true
        subtitleTextView.isHidden = true
        // setSkinProfileButton.isHidden = true
    }
    
}

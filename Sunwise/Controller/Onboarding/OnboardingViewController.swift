//
//  DashboardViewController.swift
//  Sunwise
//
//  Created by Uray Muhamad Noor Fajri Widiansyah on 20/12/22.
//

import UIKit

class OnboardingViewController: UIViewController {

    //MARK: Elements
    @IBOutlet weak var onBoardingImage: UIImageView!
    @IBOutlet weak var welcomeTitleLabel: UILabel!
    @IBOutlet weak var subtitleTextView: UITextView!
    @IBOutlet weak var setSkinProfileButton: UIButton!
    @IBOutlet weak var titleDescriptionTextView: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    static var identifier: String {
        return String(describing: self)
    }
    
    static func instantiate() -> Self {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateViewController(identifier: identifier) as! Self
    }
    
    //MARK: Go to onboarding page two
    @IBAction func setSkinProfileButtonTapped(_ sender: Any) {
        let controller = storyboard?.instantiateViewController(identifier: "SkinCheckViewController") as! SkinCheckViewController
        controller.fromViewController = "OnboardingViewController"
        controller.modalTransitionStyle = .crossDissolve
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: true)
    }
}

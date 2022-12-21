//
//  SkinCheckViewController.swift
//  Sunwise
//
//  Created by Uray Muhamad Noor Fajri Widiansyah on 21/12/22.
//

import UIKit

class SkinCheckViewController: UIViewController {

    
    @IBOutlet weak var SetSkinTypeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func skinTypeButtonTapped(_ sender: Any) {
        let controller = storyboard?.instantiateViewController(identifier: "tabBarController") as! UITabBarController
        controller.modalTransitionStyle = .flipHorizontal
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: true)
    }
    
}

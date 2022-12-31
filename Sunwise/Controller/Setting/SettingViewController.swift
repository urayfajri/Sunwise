//
//  SettingViewController.swift
//  Sunwise
//
//  Created by Uray Muhamad Noor Fajri Widiansyah on 19/12/22.
//

import UIKit

class SettingViewController: UIViewController {

    @IBOutlet weak var dailySunbatheView: UIView!
    @IBOutlet weak var locationView: UIView!
    @IBOutlet weak var notificationView: UIView!
    @IBOutlet weak var skinProfileView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initElements()

        // Do any additional setup after loading the view.
    }
    
    func initElements() {
        dailySunbatheView.layer.cornerRadius = 10
        locationView.layer.cornerRadius = 10
        notificationView.layer.cornerRadius = 10
        skinProfileView.layer.cornerRadius = 10
    }
    
    @IBAction func EditGoalButtonTapped(_ sender: Any) {
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "GoalSettingViewController") as! GoalSettingViewController
        controller.currentGoal = 12
        present(controller, animated: true, completion: nil)
    }
    

}

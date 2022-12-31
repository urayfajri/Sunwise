//
//  GoalSettingViewController.swift
//  Sunwise
//
//  Created by Uray Muhamad Noor Fajri Widiansyah on 31/12/22.
//

import UIKit

class GoalSettingViewController: UIViewController {
    
    @IBOutlet weak var GoalLabel: UILabel!
    
    @IBOutlet weak var addDurationButton: UIButton!
    @IBOutlet weak var reduceDurationButton: UIButton!
    @IBOutlet weak var setGoalButton: UIButton!

    @IBOutlet weak var setGoalView: UIView!
    
    var currentGoal: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initElements()

    }
    
    func initElements() {
        GoalLabel.text = String(currentGoal!)
        
        // if user want to swipe
        let swipeRight = UISwipeGestureRecognizer()
        let swipeLeft = UISwipeGestureRecognizer()
        
        swipeRight.direction = .right
        swipeLeft.direction = .left
        
        setGoalView.addGestureRecognizer(swipeRight)
        setGoalView.addGestureRecognizer(swipeLeft)
        
        swipeRight.addTarget(self, action: #selector(swipe(sender:)))
        swipeLeft.addTarget(self, action: #selector(swipe(sender:)))
    }
    
    @objc func swipe(sender: UISwipeGestureRecognizer) {
        switch sender.direction {
        case .right:
            // berkurang
            var goal = Int(GoalLabel.text!)!
                goal -= 1
            GoalLabel.text = String(goal)
        case .left:
            // bertambah
            var goal = Int(GoalLabel.text!)!
                goal += 1
            GoalLabel.text = String(goal)
        default:
            // bertambah
            var goal = Int(GoalLabel.text!)!
                goal += 1
            GoalLabel.text = String(goal)
        }
    }
    
    @IBAction func addDurationButtonTapped(_ sender: Any) {
        // bertambah
        var goal = Int(GoalLabel.text!)!
            goal += 1
        GoalLabel.text = String(goal)
    }
    
    @IBAction func reduceDurationButtonTapped(_ sender: Any) {
        // berkurang
        var goal = Int(GoalLabel.text!)!
            goal -= 1
        GoalLabel.text = String(goal)
    }
    
    @IBAction func setGoalButtonTapped(_ sender: Any) {
    }
    
}

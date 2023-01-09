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
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var user: User?
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        initElements()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presentingViewController?.viewWillDisappear(true)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        presentingViewController?.viewWillAppear(true)
    }
    
    func initElements() {
        GoalLabel.text = String(user?.sunbath_goal ?? 0)
    
        let skinType = user?.skin_type ?? "-"
        
        descriptionLabel.text = "Based on your skin type (\(skinType)), it is recommended to get \(timeRecommendationBySkinType(skinType: skinType)) minutes of sun exposure, each day"
        
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
            if(goal > 0) {
                goal -= 1
            }
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
        if(goal > 0) {
            goal -= 1
        }
        GoalLabel.text = String(goal)
    }
    
    @IBAction func closeButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func setGoalButtonTapped(_ sender: Any) {
        let alertControl = UIAlertController(title: "Edit Sun Exposure Goal", message: "Are you sure want to change your daily sun exposure goal?", preferredStyle: .alert)
        alertControl.addAction(UIAlertAction(title: "No", style: .cancel, handler: {_ in
            alertControl.dismiss(animated: true, completion: nil)
        }))
        alertControl.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { [self]_ in
            // fetch object yang akan di edit
            updateGoal(user: user!)
        }))
        
        self.present(alertControl, animated: true)
    }
    
    func updateGoal(user: User)
    {
        user.sunbath_goal = Int32(Int(GoalLabel.text ?? "0") ?? 0)
 
        do{
            
            try context.save()
            
            self.dismiss(animated: true, completion: nil)
        }
        catch
        {
            
        }
    }
    
    func timeRecommendationBySkinType(skinType: String) -> String{
        switch skinType {
            case "Skin Type I":
                return "10"
            case "Skin Type II":
                return "20"
            case "Skin Type III":
                return "30"
            case "Skin Type IV":
                return "50"
            case "Skin Type V":
                return "60"
            case "Skin Type VI":
                return "60"
            default:
                return "10"
        }
    }
    
}

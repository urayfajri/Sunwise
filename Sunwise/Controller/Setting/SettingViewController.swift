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
    

    @IBOutlet weak var dailySunbatheGoalLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var skinTypeLabel: UILabel!
    @IBOutlet weak var skinTypeImage: UIImageView!
    @IBOutlet weak var skinTypeRecommendedSunExposureGoalLabel: UILabel!
    @IBOutlet weak var skinTypeBurnLabel: UILabel!
    @IBOutlet weak var skinTypeTanLabel: UILabel!
    @IBOutlet weak var skinTypePeelLabel: UILabel!
    
    @IBOutlet weak var setSkinProfileButton: UIButton!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getUserInfo()
        initElements()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getUserInfo()
        initElements()
    }
    
    func initElements() {
        dailySunbatheView.layer.cornerRadius = 10
        locationView.layer.cornerRadius = 10
        notificationView.layer.cornerRadius = 10
        skinProfileView.layer.cornerRadius = 10
        
        dailySunbatheGoalLabel.text = "\(user?.sunbath_goal ?? 0) Min / Day"
        skinTypeLabel.text = user?.skin_type ?? "-"
        initSkinTypeRespone()
    }
    
    @IBAction func EditGoalButtonTapped(_ sender: Any) {
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "GoalSettingViewController") as! GoalSettingViewController
        controller.user = user
        controller.modalPresentationStyle = .popover
        present(controller, animated: true, completion: nil)
    }
    
    @IBAction func setSkinProfileButtonTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(identifier: "skinCheck") as! UINavigationController
        controller.modalTransitionStyle = .flipHorizontal
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: true)
    }
    
    
    func getUserInfo(){
        do {
            let users = try context.fetch(User.fetchRequest())
            if(!users.isEmpty) {
                user = users[0]
            }
        }
        catch {
            
        }
    }
    
    func initSkinTypeRespone() {
        switch skinTypeLabel.text {
            case "Skin Type I":
                skinTypeImage.image = UIImage(named:"SkinType1")
                skinTypeRecommendedSunExposureGoalLabel.text = "10 Min / Day"
                skinTypeBurnLabel.text = "Easily, Severely (Painful Burn)"
                skinTypeTanLabel.text = "Little or none"
                skinTypePeelLabel.text = "Yes"
            case "Skin Type II":
                skinTypeImage.image = UIImage(named:"SkinType2")
                skinTypeRecommendedSunExposureGoalLabel.text = "20 Min / Day"
                skinTypeBurnLabel.text = "Easily, Severely (Painful Burn)"
                skinTypeTanLabel.text = "Minimally or lightly"
                skinTypePeelLabel.text = "Yes"
            case "Skin Type III":
                skinTypeImage.image = UIImage(named:"SkinType3")
                skinTypeRecommendedSunExposureGoalLabel.text = "30 Min / Day"
                skinTypeBurnLabel.text = "Burns Moderately"
                skinTypeTanLabel.text = "Easily"
                skinTypePeelLabel.text = "No"
            case "Skin Type IV":
                skinTypeImage.image = UIImage(named:"SkinType4")
                skinTypeRecommendedSunExposureGoalLabel.text = "40 Min / Day"
                skinTypeBurnLabel.text = "Burns Minimally"
                skinTypeTanLabel.text = "Easily"
                skinTypePeelLabel.text = "No"
            case "Skin Type V":
                skinTypeImage.image = UIImage(named:"SkinType5")
                skinTypeRecommendedSunExposureGoalLabel.text = "60 Min / Day"
                skinTypeBurnLabel.text = "Rarely Burns"
                skinTypeTanLabel.text = "Easily and substantially"
                skinTypePeelLabel.text = "No"
            case "Skin Type VI":
                skinTypeImage.image = UIImage(named:"SkinType6")
                skinTypeRecommendedSunExposureGoalLabel.text = "60 Min / Day"
                skinTypeBurnLabel.text = "Never Burns"
                skinTypeTanLabel.text = "Profusely"
                skinTypePeelLabel.text = "No"
            default:
                skinTypeImage.image = UIImage(named:"SkinType1")
                skinTypeRecommendedSunExposureGoalLabel.text = "10 Min / Day"
                skinTypeBurnLabel.text = "Easily, Severely (Painful Burn)"
                skinTypeTanLabel.text = "Little or none"
                skinTypePeelLabel.text = "Yes"
        }
    }

}

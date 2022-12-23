//
//  SunProtectionDetailViewController.swift
//  Sunwise
//
//  Created by Ariel Waraney on 21/12/22.
//

import UIKit

class SunProtectionDetailViewController: ViewController {

    @IBOutlet weak var closeModalButton: UIButton!
    @IBOutlet weak var protectionTitle: UILabel!
    @IBOutlet weak var indexUV: UILabel!
    
    @IBOutlet weak var viewSunglasses: UIView!
    @IBOutlet weak var iconSunglasses: UILabel!
    @IBOutlet weak var titleSunglasses: UILabel!
    @IBOutlet weak var descSunglasess: UILabel!

    @IBOutlet weak var viewClothes: UIView!
    @IBOutlet weak var iconClothes: UILabel!
    @IBOutlet weak var titleClothes: UILabel!
    @IBOutlet weak var descClothes: UILabel!
    
    @IBOutlet weak var viewSunscreen: UIView!
    @IBOutlet weak var iconSunscreen: UILabel!
    @IBOutlet weak var titleSunscreen: UILabel!
    @IBOutlet weak var descSunscreen: UILabel!
    
    @IBOutlet weak var viewHat: UIView!
    @IBOutlet weak var iconHat: UILabel!
    @IBOutlet weak var titleHat: UILabel!
    @IBOutlet weak var descHat: UILabel!
   
    @IBOutlet weak var viewShelter: UIView!
    @IBOutlet weak var iconShelter: UILabel!
    @IBOutlet weak var titleShelter: UILabel!
    @IBOutlet weak var descShelter: UILabel!
    
    @IBOutlet weak var viewIndoor: UIView!
    @IBOutlet weak var iconIndoor: UILabel!
    @IBOutlet weak var titleIndoor: UILabel!
    @IBOutlet weak var descIndoor: UILabel!
    
    var uvi: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        guard let uvi = uvi else {
            return
        }
        
        switch uvi {
        case 0...2:
            protectionTitle.text = "No Protection Needed!"
            indexUV.text = "Index UV: 0-2 (Low)"
            
            viewSunglasses.alpha = 1
            iconSunscreen.alpha = 1
            titleSunglasses.alpha = 1
            titleSunglasses.text = "Wear Your Sunglasses (Optional)"
            descSunglasess.alpha = 1
            descSunglasess.text = "If you want you can wear any sunglasses."
            
            viewClothes.alpha = 0
            iconClothes.alpha = 0
            titleClothes.alpha = 0
            descClothes.alpha = 0
            
            viewSunscreen.alpha = 0
            iconSunscreen.alpha = 0
            titleSunscreen.alpha = 0
            descSunscreen.alpha = 0
            
            viewHat.alpha = 0
            iconHat.alpha = 0
            titleHat.alpha = 0
            descHat.alpha = 0
            
            viewShelter.alpha = 0
            iconShelter.alpha = 0
            titleShelter.alpha = 0
            descShelter.alpha = 0
            
            viewIndoor.alpha = 0
            iconIndoor.alpha = 0
            titleIndoor.alpha = 0
            descIndoor.alpha = 0
            return
        case 3...5:
            protectionTitle.text = "Protection Recommended!"
            indexUV.text = "Index UV: 3-5 (Moderate)"
            
            viewSunglasses.alpha = 1
            iconSunscreen.alpha = 1
            titleSunglasses.alpha = 1
            titleSunglasses.text = "Wear Your Sunglasses"
            descSunglasess.alpha = 1
            descSunglasess.text = "Any sunglasses. Recommended sunglasses are those that have a UV radiation filter rate of 99-100%."
            
            viewClothes.alpha = 1
            iconClothes.alpha = 1
            titleClothes.alpha = 1
            titleClothes.text = "Cover Up With Protective Clothes"
            descClothes.alpha = 1
            descClothes.text = "Try to use long sleve clothes to cover up your skin surface from the direct sunlight."
            
            viewSunscreen.alpha = 1
            iconSunscreen.alpha = 1
            titleSunscreen.alpha = 1
            titleSunscreen.text = "Put your SPF 30+ Sunscreen"
            descSunscreen.alpha = 1
            descSunscreen.text = "Apply your sunscreen with SPF 30+ (or higher) for 15 minutes  before exposed to the direct sunlight. Don’t forget to reapply it according to the product’s given direction."
            
            viewHat.alpha = 1
            iconHat.alpha = 1
            titleHat.alpha = 1
            titleHat.text = "Wear Your Hat (Optional)"
            descHat.alpha = 1
            descHat.text = "Try to wear your hat to cover up your head from the intense sunlight exposure."
            
            viewShelter.alpha = 1
            iconShelter.alpha = 1
            titleShelter.alpha = 1
            titleShelter.text = "Find a Shelter (Optional)"
            descShelter.alpha = 1
            descShelter.text = "Look for the nearest shelter to avoid prolonged intense sunlight exposure on your skin."
            
            viewIndoor.alpha = 0
            iconIndoor.alpha = 0
            titleIndoor.alpha = 0
            descIndoor.alpha = 0
            
            return
        case 6...7:
            protectionTitle.text = "Need Protection!"
            indexUV.text = "Index UV: 6-7 (High)"
            
            viewSunglasses.alpha = 1
            iconSunscreen.alpha = 1
            titleSunglasses.alpha = 1
            titleSunglasses.text = "Wear Your Sunglasses"
            descSunglasess.alpha = 1
            descSunglasess.text = "Any sunglasses. Recommended sunglasses are those that have a UV radiation filter rate of 99-100%."
            
            viewClothes.alpha = 1
            iconClothes.alpha = 1
            titleClothes.alpha = 1
            titleClothes.text = "Cover Up With Protective Clothes"
            descClothes.alpha = 1
            descClothes.text = "Try to use long sleve clothes to cover up your skin surface from the direct sunlight."
            
            viewSunscreen.alpha = 1
            iconSunscreen.alpha = 1
            titleSunscreen.alpha = 1
            titleSunscreen.text = "Put your SPF 30+ Sunscreen"
            descSunscreen.alpha = 1
            descSunscreen.text = "Apply your sunscreen with SPF 30+ (or higher) for 15 minutes  before exposed to the direct sunlight. Don’t forget to reapply it according to the product’s given direction. Sunscreen is a must when going outdoor."
            
            viewHat.alpha = 1
            iconHat.alpha = 1
            titleHat.alpha = 1
            titleHat.text = "Wear Your Hat"
            descHat.alpha = 1
            descHat.text = "Try to wear your hat to cover up your head from the intense sunlight exposure."
            
            viewShelter.alpha = 1
            iconShelter.alpha = 1
            titleShelter.alpha = 1
            titleShelter.text = "Find a Shelter"
            descShelter.alpha = 1
            descShelter.text = "Look for the nearest shelter to avoid intense sunlight exposure on your skin."
            
            viewIndoor.alpha = 1
            iconIndoor.alpha = 1
            titleIndoor.alpha = 1
            titleIndoor.text = "Try To Stay Indoor (Optional)"
            descIndoor.alpha = 1
            descIndoor.text = "The sun intensity is high, try to limit your outdoor activities and just stay indoor whenever possible."
            return
        case 8...10:
            protectionTitle.text = "Must Use Protection!"
            indexUV.text = "Index UV: 8-10 (Very High)"
            
            viewSunglasses.alpha = 1
            iconSunscreen.alpha = 1
            titleSunglasses.alpha = 1
            titleSunglasses.text = "Wear Your Sunglasses"
            descSunglasess.alpha = 1
            descSunglasess.text = "Any sunglasses. Recommended sunglasses are those that have a UV radiation filter rate of 99-100%."
            
            viewClothes.alpha = 1
            iconClothes.alpha = 1
            titleClothes.alpha = 1
            titleClothes.text = "Cover Up With Protective Clothes"
            descClothes.alpha = 1
            descClothes.text = "Try to use long sleve clothes to cover up your skin surface from the direct sunlight."
            
            viewSunscreen.alpha = 1
            iconSunscreen.alpha = 1
            titleSunscreen.alpha = 1
            titleSunscreen.text = "Put your SPF 30+ Sunscreen"
            descSunscreen.alpha = 1
            descSunscreen.text = "Apply your sunscreen with SPF 30+ (or higher) for 15 minutes  before exposed to the direct sunlight. Don’t forget to reapply it according to the product’s given direction. Sunscreen is a must when going outdoor."
            
            viewHat.alpha = 1
            iconHat.alpha = 1
            titleHat.alpha = 1
            titleHat.text = "Wear Your Hat"
            descHat.alpha = 1
            descHat.text = "Try to wear your hat to cover up your head from the intense sunlight exposure. You also can use any cover such as umbrella to protect your head from direct sunlight."
            
            viewShelter.alpha = 1
            iconShelter.alpha = 1
            titleShelter.alpha = 1
            titleShelter.text = "Find a Shelter"
            descShelter.alpha = 1
            descShelter.text = "Look for the nearest shelter to avoid intense sunlight exposure on your skin. Do this as soon as possible."
            
            viewIndoor.alpha = 1
            iconIndoor.alpha = 1
            titleIndoor.alpha = 1
            titleIndoor.text = "Try To Stay Indoor"
            descIndoor.alpha = 1
            descIndoor.text = "The sun intensity is very high, try to limit your outdoor activities at all and just stay indoor whenever possible."
            return
        case 11...99:
            protectionTitle.text = "Urgent To Use Protection!"
            indexUV.text = "Index UV: 11+ (Extreme)"
            
            viewSunglasses.alpha = 1
            iconSunscreen.alpha = 1
            titleSunglasses.alpha = 1
            titleSunglasses.text = "Wear Your Sunglasses"
            descSunglasess.alpha = 1
            descSunglasess.text = "Any sunglasses. Recommended sunglasses are those that have a UV radiation filter rate of 99-100%."
            
            viewClothes.alpha = 1
            iconClothes.alpha = 1
            titleClothes.alpha = 1
            titleClothes.text = "Cover Up With Protective Clothes"
            descClothes.alpha = 1
            descClothes.text = "Try to use long sleve clothes to cover up your skin surface from the direct sunlight."
            
            viewSunscreen.alpha = 1
            iconSunscreen.alpha = 1
            titleSunscreen.alpha = 1
            titleSunscreen.text = "Put your SPF 30+ Sunscreen"
            descSunscreen.alpha = 1
            descSunscreen.text = "Apply your sunscreen with SPF 30+ (or higher) for 15 minutes  before exposed to the direct sunlight. Don’t forget to reapply it according to the product’s given direction. Sunscreen is a must when going outdoor."
            
            viewHat.alpha = 1
            iconHat.alpha = 1
            titleHat.alpha = 1
            titleHat.text = "Wear Your Hat"
            descHat.alpha = 1
            descHat.text = "Try to wear your hat to cover up your head from the intense sunlight exposure. You also can use any cover such as umbrella to protect your head from direct sunlight."
            
            viewShelter.alpha = 1
            iconShelter.alpha = 1
            titleShelter.alpha = 1
            titleShelter.text = "Find a Shelter"
            descShelter.alpha = 1
            descShelter.text = "Look for the nearest shelter to avoid intense sunlight exposure on your skin. Do this as soon as possible."
            
            viewIndoor.alpha = 1
            iconIndoor.alpha = 1
            titleIndoor.alpha = 1
            titleIndoor.text = "Try To Stay Indoor"
            descIndoor.alpha = 1
            descIndoor.text = "The sun intensity is extreme, do not do any outdoor activities and just stay indoor as long as it is possible."
            return
        default:
            return
        }
    }
    
    @IBAction func closeButtonPressed(_ sender: Any) {
        self.dismiss(animated: true)
    }
    

}

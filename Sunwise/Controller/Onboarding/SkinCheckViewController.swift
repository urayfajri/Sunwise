//
//  SkinCheckViewController.swift
//  Sunwise
//
//  Created by Uray Muhamad Noor Fajri Widiansyah on 21/12/22.
//

import UIKit
import AVFoundation

class SkinCheckViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {

    let captureSession = AVCaptureSession()
    
    var previewLayer: CALayer!
    var captureDevice: AVCaptureDevice!
    
    @IBOutlet weak var SetSkinTypeButton: UIButton!
    @IBOutlet weak var cameraView: UIView!
    
    @IBOutlet weak var skinInfoView: UIView!
    @IBOutlet weak var prevSkinButton: UIButton!
    @IBOutlet weak var nextSkinButton: UIButton!
    @IBOutlet weak var skinTypeLabel: UILabel!
    @IBOutlet weak var topView: UIView!
    
    var skinTypes = [String]()
    var fromViewController: String?
    
    var user: User?
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //addNavigationBar()
        getUserInfo()
        initSkinType()
        initElementForSkinInfo()
        prepareCamera()
        setupTopView()
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        prepareCamera()
//    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presentingViewController?.viewWillDisappear(true)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        presentingViewController?.viewWillAppear(true)
    }
    
    private func addNavigationBar() {
        let height: CGFloat = 75
        let navbar = UINavigationBar(frame: CGRect(x: 0, y: 50, width: UIScreen.main.bounds.width, height: height))
        navbar.delegate = self as? UINavigationBarDelegate

        let navItem = UINavigationItem()
        navItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: nil)

        navbar.items = [navItem]

        view.addSubview(navbar)
    }
    
    //MARK: Prepare Camera
    func prepareCamera() {
        captureSession.sessionPreset = AVCaptureSession.Preset.photo
        
        if let availableDevices = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaType.video, position: .back).devices.first {
                 captureDevice = availableDevices
                 beginSession()
             }
    }
    
    //MARK: Begin Camera Session
    func beginSession() {
        do {
            let captureDeviceInput = try AVCaptureDeviceInput(device: captureDevice)
                captureSession.addInput(captureDeviceInput)
        }catch {
                print(error.localizedDescription)
        }
        
        if let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession) as? AVCaptureVideoPreviewLayer {
            self.previewLayer = previewLayer
            previewLayer.videoGravity = .resizeAspectFill
            self.cameraView.layer.addSublayer(self.previewLayer)
            self.previewLayer.frame = self.cameraView.layer.frame
            captureSession.startRunning()
                    
            let dataOutput = AVCaptureVideoDataOutput()
            dataOutput.videoSettings = [(kCVPixelBufferPixelFormatTypeKey as String):NSNumber(value:kCVPixelFormatType_32BGRA)]
            
            dataOutput.alwaysDiscardsLateVideoFrames = true
                
            if captureSession.canAddOutput(dataOutput) {
                captureSession.addOutput(dataOutput)
            }
                    
            captureSession.commitConfiguration()
                    
                
        }
    }
    
    //MARK: Stop Camera Session
    func stopCaptureSession () {
            self.captureSession.stopRunning()
            
            if let inputs = captureSession.inputs as? [AVCaptureDeviceInput] {
                for input in inputs {
                    self.captureSession.removeInput(input)
                }
            }
            
        }
    
    @IBAction func buttonCancelTapped(_ sender: Any) {
        self.dismiss(animated: true)
    }
    @IBAction func prevSkinButtonTapped(_ sender: Any) {
        skinTypePrevChanged()
    }
    
    @IBAction func nextSkinButtonTapped(_ sender: Any) {
        skinTypeNextChanged()
    }
    
    @IBAction func skinTypeButtonTapped(_ sender: Any) {
        
        let alertControl = UIAlertController(title: "Set Skin Type", message: "Are you sure you have chosen your skin type correctly?", preferredStyle: .alert)
        alertControl.addAction(UIAlertAction(title: "No", style: .cancel, handler: {_ in
            alertControl.dismiss(animated: true, completion: nil)
        }))
        alertControl.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { [self]_ in
            let controller = storyboard?.instantiateViewController(identifier: "tabBarController") as! UITabBarController
            controller.modalTransitionStyle = .flipHorizontal
            controller.modalPresentationStyle = .fullScreen
            
            if(user == nil) {
                // create user model
                createUserInfo(skintype: skinTypeLabel.text ?? "")
                UserDefaults.standard.hasOnboarded = true
            } else {
                // update user model skin type
                updateSkinType(user: user!)
            }
            
            present(controller, animated: true, completion: {
                self.stopCaptureSession()
            })
        }))
        
        self.present(alertControl, animated: true)
        
    }
        
    func initSkinType() {
        for (index) in 1...6 {
            var skin = ""
            switch index {
                case 1:
                skin = "Skin Type I"
                case 2:
                skin = "Skin Type II"
                case 3:
                skin = "Skin Type III"
                case 4:
                skin = "Skin Type IV"
                case 5:
                skin = "Skin Type V"
                case 6:
                skin = "Skin Type VI"
                default:
                skin = "Skin Type"
            }
            skinTypes.append(skin)
        }
    }
    
    func setupTopView() {
        topView.alpha = 0.7
        topView.layer.cornerRadius = 10
    }
    
    func initElementForSkinInfo() {
        if(!skinTypes.isEmpty && user == nil) {
            skinTypeLabel.text = skinTypes[0]
            skinInfoView.backgroundColor = UIColor(named: "SkinType1")
        }
        
        // if user want to swipe
        let swipeRight = UISwipeGestureRecognizer()
        let swipeLeft = UISwipeGestureRecognizer()
        
        swipeRight.direction = .right
        swipeLeft.direction = .left
        
        skinInfoView.addGestureRecognizer(swipeRight)
        skinInfoView.addGestureRecognizer(swipeLeft)
        
        swipeRight.addTarget(self, action: #selector(swipe(sender:)))
        swipeLeft.addTarget(self, action: #selector(swipe(sender:)))
        
        prevSkinButton.setTitle("", for: .normal)
        nextSkinButton.setTitle("", for: .normal)
    }
    
    @objc func swipe(sender: UISwipeGestureRecognizer) {
        switch sender.direction {
        case .right:
            skinTypePrevChanged()
        case .left:
            skinTypeNextChanged()
        default:
            skinTypeLabel.text = "Skin Type"
        }
    }
    
    //MARK: Next State skin Type
    func skinTypeNextChanged() {
        switch skinTypeLabel.text {
            case "Skin Type I":
                skinTypeLabel.text = "Skin Type II"
                skinInfoView.backgroundColor = UIColor(named: "SkinType2")
            case "Skin Type II":
                skinTypeLabel.text = "Skin Type III"
                skinInfoView.backgroundColor = UIColor(named: "SkinType3")
            case "Skin Type III":
                skinTypeLabel.text = "Skin Type IV"
                skinInfoView.backgroundColor = UIColor(named: "SkinType4")
            case "Skin Type IV":
                skinTypeLabel.text = "Skin Type V"
                skinInfoView.backgroundColor = UIColor(named: "SkinType5")
            case "Skin Type V":
                skinTypeLabel.text = "Skin Type VI"
                skinInfoView.backgroundColor = UIColor(named: "SkinType6")
            case "Skin Type VI":
                skinTypeLabel.text = "Skin Type I"
                skinInfoView.backgroundColor = UIColor(named: "SkinType1")
            default:
                skinTypeLabel.text = "Skin Type"
                skinInfoView.backgroundColor = UIColor(named: "SkinType1")
        }
    }
    
    //MARK: Previous State skin Type
    func skinTypePrevChanged() {
        switch skinTypeLabel.text {
            case "Skin Type I":
                skinTypeLabel.text = "Skin Type VI"
                skinInfoView.backgroundColor = UIColor(named: "SkinType6")
            case "Skin Type II":
                skinTypeLabel.text = "Skin Type I"
                skinInfoView.backgroundColor = UIColor(named: "SkinType1")
            case "Skin Type III":
                skinTypeLabel.text = "Skin Type II"
                skinInfoView.backgroundColor = UIColor(named: "SkinType2")
            case "Skin Type IV":
                skinTypeLabel.text = "Skin Type III"
                skinInfoView.backgroundColor = UIColor(named: "SkinType3")
            case "Skin Type V":
                skinTypeLabel.text = "Skin Type IV"
                skinInfoView.backgroundColor = UIColor(named: "SkinType4")
            case "Skin Type VI":
                skinTypeLabel.text = "Skin Type V"
                skinInfoView.backgroundColor = UIColor(named: "SkinType5")
            default:
                skinTypeLabel.text = "Skin Type"
                skinInfoView.backgroundColor = UIColor(named: "SkinType1")
        }
    }
    
    // MARK:  create core data user model
    func createUserInfo(skintype: String) {
        let user = User(context: context)
        user.skin_type = skintype
        user.ideal_time_notif = false
        user.sun_protection_notif = false
        
        // default sunbath goal
        switch skintype {
            case "Skin Type I":
                user.sunbath_goal = 5
            case "Skin Type II":
                user.sunbath_goal = 10
            case "Skin Type III":
                user.sunbath_goal = 15
            case "Skin Type IV":
                user.sunbath_goal = 20
            case "Skin Type V":
                user.sunbath_goal = 25
            case "Skin Type VI":
                user.sunbath_goal = 30
            default:
                user.sunbath_goal = 5
        }
        
        do{
            try context.save()
        }
        catch
        {
            
        }
    }
    
    func getUserInfo(){
        do {
            let users = try context.fetch(User.fetchRequest())
            if(!users.isEmpty) {
                user = users[0]
                initSkinTypeUser(userSkinType: user?.skin_type ?? "-")
            }
        }
        catch {
            
        }
    }
    
    func initSkinTypeUser(userSkinType: String) {
        switch userSkinType {
            case "Skin Type I":
                skinTypeLabel.text = "Skin Type I"
                skinInfoView.backgroundColor = UIColor(named: "SkinType1")
            case "Skin Type II":
                skinTypeLabel.text = "Skin Type II"
                skinInfoView.backgroundColor = UIColor(named: "SkinType2")
            case "Skin Type III":
                skinTypeLabel.text = "Skin Type III"
                skinInfoView.backgroundColor = UIColor(named: "SkinType3")
            case "Skin Type IV":
                skinTypeLabel.text = "Skin Type IV"
                skinInfoView.backgroundColor = UIColor(named: "SkinType4")
            case "Skin Type V":
                skinTypeLabel.text = "Skin Type V"
                skinInfoView.backgroundColor = UIColor(named: "SkinType5")
            case "Skin Type VI":
                skinTypeLabel.text = "Skin Type VI"
                skinInfoView.backgroundColor = UIColor(named: "SkinType6")
            default:
                skinTypeLabel.text = "Skin Type"
                skinInfoView.backgroundColor = UIColor(named: "SkinType1")
        }
    }
    
    func updateSkinType(user: User)
    {
        user.skin_type = skinTypeLabel.text
 
        do{
            
            try context.save()
            
            self.dismiss(animated: true, completion: nil)
        }
        catch
        {
            
        }
    }
}

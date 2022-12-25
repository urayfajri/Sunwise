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
    @IBOutlet weak var skinTypeImage: UIImageView!
    @IBOutlet weak var skinTypeLabel: UILabel!
    
    var skinTypes = [SkinType]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initSkinType()
        initElementForSkinInfo()

        prepareCamera()
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        prepareCamera()
//    }
    
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
    
    
    @IBAction func prevSkinButtonTapped(_ sender: Any) {
        skinTypePrevChanged()
    }
    
    @IBAction func nextSkinButtonTapped(_ sender: Any) {
        skinTypeNextChanged()
    }
    
    @IBAction func skinTypeButtonTapped(_ sender: Any) {
        let controller = storyboard?.instantiateViewController(identifier: "tabBarController") as! UITabBarController
        controller.modalTransitionStyle = .flipHorizontal
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: true, completion: {
            self.stopCaptureSession()
        })
    }
        
    func initSkinType() {
        for (index) in 1...6 {
            let id = index
            let skinType = SkinType()
            skinType?.id = id
            switch id {
                case 1:
                skinType?.name = "Skin Type I"
                case 2:
                skinType?.name = "Skin Type II"
                case 3:
                skinType?.name = "Skin Type III"
                case 4:
                skinType?.name = "Skin Type IV"
                case 5:
                skinType?.name = "Skin Type V"
                case 6:
                skinType?.name = "Skin Type VI"
                default:
                skinType?.name = "Skin Type"
            }
            skinTypes.append(skinType!)
        }
    }
    
    func initElementForSkinInfo() {
        if(!skinTypes.isEmpty) {
            skinTypeLabel.text = skinTypes[0].name
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
    
    func skinTypeNextChanged() {
        switch skinTypeLabel.text {
            case "Skin Type I":
                skinTypeLabel.text = "Skin Type II"
            case "Skin Type II":
                skinTypeLabel.text = "Skin Type III"
            case "Skin Type III":
                skinTypeLabel.text = "Skin Type IV"
            case "Skin Type IV":
                skinTypeLabel.text = "Skin Type V"
            case "Skin Type V":
                skinTypeLabel.text = "Skin Type VI"
            case "Skin Type VI":
                skinTypeLabel.text = "Skin Type I"
            default:
                skinTypeLabel.text = "Skin Type"
        }
    }
    
    func skinTypePrevChanged() {
        switch skinTypeLabel.text {
            case "Skin Type I":
                skinTypeLabel.text = "Skin Type IV"
            case "Skin Type II":
                skinTypeLabel.text = "Skin Type I"
            case "Skin Type III":
                skinTypeLabel.text = "Skin Type II"
            case "Skin Type IV":
                skinTypeLabel.text = "Skin Type III"
            case "Skin Type V":
                skinTypeLabel.text = "Skin Type IV"
            case "Skin Type VI":
                skinTypeLabel.text = "Skin Type V"
            default:
                skinTypeLabel.text = "Skin Type"
        }
    }
}
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
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
            self.view.layer.addSublayer(self.previewLayer)
            self.previewLayer.frame = self.view.layer.frame
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
    
    
    @IBAction func skinTypeButtonTapped(_ sender: Any) {
        let controller = storyboard?.instantiateViewController(identifier: "tabBarController") as! UITabBarController
        controller.modalTransitionStyle = .flipHorizontal
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: true, completion: {
            self.stopCaptureSession()
        })
    }
    
}

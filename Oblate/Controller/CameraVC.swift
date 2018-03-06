//
//  ViewController.swift
//  Oblate
//
//  Created by Trevor Lyons on 2018-02-24.
//  Copyright © 2018 Trevor Lyons. All rights reserved.
//

import UIKit
import AVFoundation
import CoreML
import Vision
import LanguageTranslatorV2

class CamaraVC: UIViewController {
    
    @IBOutlet weak var camaraView: UIView!
    
    var captureSession: AVCaptureSession!
    var camaraOutput: AVCapturePhotoOutput!
    var previewLayer: AVCaptureVideoPreviewLayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let username = "e5fc2955-c10e-42e6-b759-ae63f1f0c3a6"
//        let password = "GihGLUFS1DTJ"
//        let languageTranslator = LanguageTranslator(username: username, password: password)
//
//        let failure = { (error: Error) in print(error) }
//        languageTranslator.translate("Shit", from: "en", to: "es", failure: failure) {
//            translation in
//            print(translation)
//        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        previewLayer.frame = camaraView.bounds
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        captureSession = AVCaptureSession()
        captureSession.sessionPreset = .hd1920x1080
        
        let backCam
    }
    
    
}


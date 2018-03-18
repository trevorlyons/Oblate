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
import CoreData


enum flashState {
    case off
    case on
}

class CameraVC: UIViewController {
    
    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var imagePreview: ImagePreviewCircle!
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var flashButton: UIButton!
    @IBOutlet weak var galleryButton: UIButton!
    @IBOutlet weak var translatorView: UIView!
    @IBOutlet weak var heart: UIImageView!
    @IBOutlet weak var inputName: UILabel!
    @IBOutlet weak var outputName: UILabel!
    @IBOutlet weak var outputLanguage: UILabel!
    @IBOutlet weak var outputLanguageView: UIView!
    
    var captureSession: AVCaptureSession!
    var cameraOutput: AVCapturePhotoOutput!
    var previewLayer: AVCaptureVideoPreviewLayer!
    var photoData: Data?
    var flashControlState: flashState = .off
    var settingsButtonCenter: CGPoint!
    var flashButtonCenter: CGPoint!
    var galleryButtonCenter: CGPoint!
    var imageLiked: Image?
    var controller: NSFetchedResultsController<Image>!
    var index: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        settingsButton.alpha = 0
        flashButton.alpha = 0
        galleryButton.alpha = 0
        
        settingsButton.center = menuButton.center
        flashButton.center = menuButton.center
        galleryButton.center = menuButton.center
        
        index = 52
        UserDefaults.standard.register(defaults: ["languageIndex": index])
        index = UserDefaults.standard.integer(forKey: "languageIndex")
        outputLanguage.text = (languageArray[index].code).capitalized

//        imagePreview.isHidden = true
        
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        settingsButtonCenter = settingsButton.center
        flashButtonCenter = flashButton.center
        galleryButtonCenter = galleryButton.center
        menuButton.translatesAutoresizingMaskIntoConstraints = true

    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//
//        previewLayer.frame = cameraView.bounds
//    }
//
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//
//        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapCameraView))
//        tap.numberOfTapsRequired = 1
//
//        captureSession = AVCaptureSession()
//        captureSession.sessionPreset = .hd1920x1080
//
//        let backCamera = AVCaptureDevice.default(for: .video)
//        do {
//            let input = try AVCaptureDeviceInput.init(device: backCamera!)
//            if captureSession.canAddInput(input) == true {
//                captureSession.addInput(input)
//            }
//            cameraOutput = AVCapturePhotoOutput()
//            if captureSession.canAddOutput(cameraOutput) == true {
//                captureSession.addOutput(cameraOutput!)
//
//                previewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
//                previewLayer.videoGravity = .resizeAspect
//                previewLayer.connection?.videoOrientation = .portrait
//
//                cameraView.layer.addSublayer(previewLayer)
//                cameraView.addGestureRecognizer(tap)
//                captureSession.startRunning()
//            }
//        } catch {
//            debugPrint(error)
//        }
//    }
//
//    @objc func didTapCameraView() {
////        self.cameraView.isUserInteractionEnabled = false
////        self.spinner.isHidden = false
////        self.spinner.startAnimating()
//
//        let settings = AVCapturePhotoSettings()
//        settings.previewPhotoFormat = settings.embeddedThumbnailPhotoFormat
//
////        if flashControlState == .off {
////            settings.flashMode = .off
////        } else {
////            settings.flashMode = .on
////        }
//
//        cameraOutput.capturePhoto(with: settings, delegate: self)
//    }
    
    func translate(sentence: String, outputLang: String)  {
        let username = "e5fc2955-c10e-42e6-b759-ae63f1f0c3a6"
        let password = "GihGLUFS1DTJ"
        let languageTranslator = LanguageTranslator(username: username, password: password)
        
        let failure = { (error: Error) in print(error) }
        languageTranslator.translate(sentence, from: "en", to: outputLang, failure: failure) {
            translation in
            print(translation)
        }
    }
    
    @IBAction func menuPressed(_ sender: UIButton) {
        if menuButton.currentImage == #imageLiteral(resourceName: "menuClosed") {
            UIView.animate(withDuration: 0.3, animations: {
                self.settingsButton.alpha = 1
                self.flashButton.alpha = 1
                self.galleryButton.alpha = 1
                
                self.settingsButton.center = self.settingsButtonCenter
                self.flashButton.center = self.flashButtonCenter
                self.galleryButton.center = self.galleryButtonCenter
            })
        } else {
            UIView.animate(withDuration: 0.3, animations: {
                self.settingsButton.alpha = 0
                self.flashButton.alpha = 0
                self.galleryButton.alpha = 0
                
                self.settingsButton.center = self.menuButton.center
                self.flashButton.center = self.menuButton.center
                self.galleryButton.center = self.menuButton.center
            })
        }
        toggleButton(button: sender, onImage: #imageLiteral(resourceName: "menuClosed"), offImage: #imageLiteral(resourceName: "menuOpen"))
    }
    
    @IBAction func settingsPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "toSettings", sender: self)
    }
    
    @IBAction func flashPressed(_ sender: UIButton) {
        toggleButton(button: sender, onImage: #imageLiteral(resourceName: "flashOff"), offImage: #imageLiteral(resourceName: "flashOn"))
        switch flashControlState {
        case .off:
            flashControlState = .on
        case .on:
            flashControlState = .off
        }
        
    }
    
    @IBAction func galleryPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "toGallery", sender: self)
//        imagePreview.isHidden = true
        heart.image = #imageLiteral(resourceName: "heartEmpty")
    }
    
    func toggleButton(button: UIButton, onImage: UIImage, offImage: UIImage) {
        if button.currentImage == offImage {
            button.setImage(onImage, for: .normal)
        } else {
            button.setImage(offImage, for: .normal)
        }
    }
    
    @IBAction func likePhotoPressed(_ sender: UITapGestureRecognizer) {
        
        if heart.image == #imageLiteral(resourceName: "heartEmpty") {
            heart.image = #imageLiteral(resourceName: "heartFull")
            
            let thumbImage = Image(context: context)
            thumbImage.type = imagePreview.image
            let title = Title(context: context)
            title.toImage = thumbImage
            if let input = inputName.text {
                title.inputLanguage = input
            }
            if let output = outputName.text {
                title.outputLanguage = output
            }
            if let outputOption = outputLanguage.text {
                title.outputSelector = outputOption
            }
            ad.saveContext()
            
            debugPrint("Save!")
        } else {
            heart.image = #imageLiteral(resourceName: "heartEmpty")
            
            attemptFetchOne()
            context.delete(controller.fetchedObjects![0])
            ad.saveContext()
            
            debugPrint("Delete!")
        }
    }
    
    @IBAction func outputLanguageSelectorPressed(_ sender: UITapGestureRecognizer) {
        performSegue(withIdentifier: "toPicker", sender: index)
    }
}


extension CameraVC: UIPopoverPresentationControllerDelegate, LanguageIndex {
    
    func setLanguageArrayIndex(valueSent: Int) {
        index = valueSent
        outputLanguage.text = (languageArray[index].code).capitalized
        UserDefaults.standard.set(index, forKey: "languageIndex")
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? PickerVC {
            controller.preferredContentSize = CGSize(width: 200, height: 240)
            controller.languageIndexDelegate = self
            if let x = sender {
                controller.currentLanguageIndex = x as! Int
            }
            let popoverController = controller.popoverPresentationController
            if popoverController != nil {
                popoverController?.delegate = self
                popoverController?.sourceView = outputLanguageView
                popoverController?.sourceRect = outputLanguageView.bounds
            }
        }
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }
}


extension CameraVC: NSFetchedResultsControllerDelegate {
    
    func attemptFetchOne() {
        let fetchRequest: NSFetchRequest<Image> = Image.fetchRequest()
        let sort = NSSortDescriptor(key: "created", ascending: false)
        fetchRequest.sortDescriptors = [sort]
        fetchRequest.fetchLimit = 1
        
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        controller.delegate = self
        self.controller = controller
        
        do {
            try controller.performFetch()
        } catch {
            let error = error as NSError
            debugPrint("Error: ", error)
        }
    }
}


//extension CameraVC: AVCapturePhotoCaptureDelegate {
//    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
//        if let error = error {
//            debugPrint(error)
//        } else {
//            photoData = photo.fileDataRepresentation()
//
////            do {
////                let model = try VNCoreMLModel(for: SqueezeNet().model)
////                let request = VNCoreMLRequest(model: model, completionHandler: resultsMethod)
////                let handler = VNImageRequestHandler(data: photoData!)
////                try handler.perform([request])
////            } catch {
////                debugPrint(error)
////            }
//
//            let image = UIImage(data: photoData!)
//            self.imagePreview.image = image
//            self.imagePreview.isHidden = false
//        }
//    }
//}


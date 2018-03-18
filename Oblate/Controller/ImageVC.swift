//
//  ImageVC.swift
//  Oblate
//
//  Created by Trevor Lyons on 2018-03-05.
//  Copyright © 2018 Trevor Lyons. All rights reserved.
//

import UIKit
import MessageUI
import SimplePDF

class ImageVC: UIViewController {

    @IBOutlet weak var objectImage: UIImageView!
    @IBOutlet weak var inputWord: UILabel!
    @IBOutlet weak var outputWord: UILabel!
    @IBOutlet weak var outputLanguage: UILabel!
    
    var imageToEdit: Image?
    let screenSize = UIScreen.main.bounds
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadImageData()
    }
    
    func loadImageData() {
        if let photo = imageToEdit {
            objectImage.image = photo.type as? UIImage
            inputWord.text = photo.toTitle?.inputLanguage
            outputWord.text = photo.toTitle?.outputLanguage
            outputLanguage.text = photo.toTitle?.outputSelector
        }
    }

    @IBAction func editImagePressed(_ sender: Any) {
        performSegue(withIdentifier: "toEdit", sender: self)
    }
    
    @IBAction func deleteImagePressed(_ sender: Any) {
        context.delete(imageToEdit!)
        ad.saveContext()
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func sendImagePressed(_ sender: Any) {
        createPDF(inputText: inputWord.text!, outputText: outputWord.text!, image: objectImage.image!)
        sendMail()
    }
    
    @IBAction func backPressed(_ sender: Any) {
        dismiss(animated: false, completion: nil)
    }
}


extension ImageVC: MFMailComposeViewControllerDelegate {
    
    func sendMail() {
        if MFMailComposeViewController.canSendMail() {
            let mailComposer = MFMailComposeViewController()
            mailComposer.mailComposeDelegate = self
            mailComposer.setSubject("Hey, check out what I translated!")
            
            let pathPDF = "\(NSTemporaryDirectory())imageTranslation.pdf"
            if let fileData = NSData(contentsOfFile: pathPDF)
            {
                print("File data loaded.")
                mailComposer.addAttachmentData(fileData as Data, mimeType: "application/pdf", fileName: "imageTranslation.pdf")
            }
            
            self.present(mailComposer, animated: true, completion: nil)
            
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func createPDF(inputText: String, outputText: String, image: UIImage) {
        
        
        let sizeOfPDF = CGSize(width: screenSize.width, height: screenSize.height)
        let pdf = SimplePDF(pageSize: sizeOfPDF, pageMargin: 10.0)
        let textAttributes: [NSAttributedStringKey: Any] = [
            NSAttributedStringKey.strokeColor: UIColor(red: 0, green: 0, blue: 0, alpha: 0.5),
            NSAttributedStringKey.font: UIFont(name: "Avenir Next", size: 18)!
        ]
        pdf.setContentAlignment(.center)
        pdf.addAttributedText(NSAttributedString(string: "En - \(inputText)", attributes: textAttributes))
        pdf.addLineSpace(20.0)
        pdf.addLineSeparator(height: 0.5)
        pdf.addAttributedText(NSAttributedString(string: "\(outputLanguage.text!) - \(outputText)", attributes: textAttributes))
        pdf.addLineSpace(20.0)
        pdf.addImage(image)
        let pdfData = pdf.generatePDFdata()
        
        do {
            try pdfData.write(to: URL(fileURLWithPath: "\(NSTemporaryDirectory())imageTranslation.pdf"), options: .atomicWrite)
        } catch {
            let error = error as NSError
            debugPrint("Error: ", error)
        }
    }
}


extension ImageVC: UIPopoverPresentationControllerDelegate {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? EditVC {
            controller.preferredContentSize = CGSize(width: screenSize.width * 0.9, height: 200)
            
            let popoverController = controller.popoverPresentationController
            if popoverController != nil {
                popoverController?.delegate = self
                popoverController?.sourceView = self.view
                popoverController?.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.minY, width: 0, height: 0)
                popoverController?.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)
            }
        }
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }
}








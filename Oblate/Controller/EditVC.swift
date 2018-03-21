//
//  EditVC.swift
//  Oblate
//
//  Created by Trevor Lyons on 2018-03-18.
//  Copyright © 2018 Trevor Lyons. All rights reserved.
//

import UIKit
import LanguageTranslatorV2

protocol EditObjectData {
    func EditCoreDataObject(inputText: String, outputText: String, outputLang: String)
}

class EditVC: UIViewController {

    @IBOutlet weak var outputLanguageView: UIView!
    @IBOutlet weak var outputLanguage: UILabel!
    @IBOutlet weak var outputText: UILabel!
    @IBOutlet weak var inputText: UITextField!
    
    var currentLanguageCode: String!
    var index: Int!
    var EditObjectDelegate: EditObjectData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        outputLanguage.text = currentLanguageCode
    }
    
    @IBAction func selectLanguagePressed(_ sender: UITapGestureRecognizer) {
        for (index,element) in languageArray.enumerated() {
            if outputLanguage.text == (element.code).capitalized {
                performSegue(withIdentifier: "toPicker2", sender: index)
            }
        }
    }
    
    @IBAction func savePressed(_ sender: Any) {
        guard let input = inputText.text, let output = outputText.text, let outputLang = outputLanguage.text else {
            debugPrint("Missing values")
            return
        }
        EditObjectDelegate?.EditCoreDataObject(inputText: input, outputText: output, outputLang: outputLang)
        dismiss(animated: true, completion: nil)
    }
    
}


extension EditVC: UIPopoverPresentationControllerDelegate, LanguageIndex {
    
    func setLanguageArrayIndex(valueSent: Int) {
        index = valueSent
        outputLanguage.text = (languageArray[index].code).capitalized
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

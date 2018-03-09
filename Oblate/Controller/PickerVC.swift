//
//  PickerVC.swift
//  Oblate
//
//  Created by Trevor Lyons on 2018-03-07.
//  Copyright © 2018 Trevor Lyons. All rights reserved.
//

import UIKit

protocol LanguageIndex {
    func setLanguageArrayIndex(valueSent: Int)
}

class PickerVC: UIViewController {

    @IBOutlet weak var picker: UIPickerView!
    
    var languageIndexDelegate: LanguageIndex?
    var currentLanguageIndex: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        picker.dataSource = self
        picker.delegate = self
        picker.selectRow(currentLanguageIndex, inComponent: 0, animated: false)

    }
    
    @IBAction func acceptPressed(_ sender: Any) {
        let index = picker.selectedRow(inComponent: 0)
        languageIndexDelegate?.setLanguageArrayIndex(valueSent: index)
        dismiss(animated: true, completion: nil)
    }
}


extension PickerVC: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var pickerLabel: UILabel? = (view as? UILabel)
        if pickerLabel == nil {
            pickerLabel = UILabel()
            pickerLabel?.font = UIFont(name: "Avenir Next", size: 16.0)
            pickerLabel?.textAlignment = .center
        }
        pickerLabel?.text = languageArray[row].language
        return pickerLabel!
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return languageArray.count
    }
}

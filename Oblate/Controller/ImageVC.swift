//
//  ImageVC.swift
//  Oblate
//
//  Created by Trevor Lyons on 2018-03-05.
//  Copyright © 2018 Trevor Lyons. All rights reserved.
//

import UIKit

class ImageVC: UIViewController {

    @IBOutlet weak var objectImage: UIImageView!
    @IBOutlet weak var inputWord: UILabel!
    @IBOutlet weak var outputWord: UILabel!
    @IBOutlet weak var outputLanguage: UILabel!
    
    var imageToEdit: Image?
    
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
    }
    
    @IBAction func deleteImagePressed(_ sender: Any) {
        context.delete(imageToEdit!)
        ad.saveContext()
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func sendImagePressed(_ sender: Any) {
    }
    
    @IBAction func backPressed(_ sender: Any) {
        dismiss(animated: false, completion: nil)
    }
}

//
//  GalleryVC.swift
//  Oblate
//
//  Created by Trevor Lyons on 2018-03-04.
//  Copyright © 2018 Trevor Lyons. All rights reserved.
//

import UIKit
import CoreData

class GalleryVC: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var controller: NSFetchedResultsController<Image>!
    var sectionChanges = [(type: NSFetchedResultsChangeType, sectionIndex: Int)]()
    var itemChanges = [(type: NSFetchedResultsChangeType, indexPath: IndexPath?, newIndexPath: IndexPath?)]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        attemptFetch()
    }
    
    @IBAction func backPressed(_ sender: Any) {
        dismiss(animated: false, completion: nil)
    }
}



extension GalleryVC: NSFetchedResultsControllerDelegate {
    
    func attemptFetch() {
        let fetchRequest: NSFetchRequest<Image> = Image.fetchRequest()
        let sort = NSSortDescriptor(key: "created", ascending: false)
        fetchRequest.sortDescriptors = [sort]
        
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
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        sectionChanges.append((type, sectionIndex))
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        itemChanges.append((type, indexPath, newIndexPath))
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        collectionView.performBatchUpdates({
            
            for change in self.sectionChanges {
                switch change.type {
                case .insert:
                    self.collectionView?.insertSections([change.sectionIndex])
                case .delete:
                    self.collectionView?.deleteSections([change.sectionIndex])
                default:
                    break
                }
            }
            
            for change in self.itemChanges {
                switch change.type {
                case .insert:
                    self.collectionView.insertItems(at: [change.newIndexPath!])
                case .delete:
                    self.collectionView.deleteItems(at: [change.indexPath!])
                case .update:
                    self.collectionView.reloadItems(at: [change.indexPath!])
                case .move:
                    self.collectionView.deleteItems(at: [change.indexPath!])
                    self.collectionView.insertItems(at: [change.indexPath!])
                }
            }
        }, completion: { finished in
            self.sectionChanges.removeAll()
            self.itemChanges.removeAll()
        })
    }
    
}


extension GalleryVC: UICollectionViewDataSource, UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "gallery", for: indexPath) as? GalleryCell else { return UICollectionViewCell() }
        configureCell(cell: cell, indexPath: indexPath as NSIndexPath)
        return cell
    }
    
    func configureCell(cell: GalleryCell, indexPath: NSIndexPath) {
        let imageObject = controller.object(at: indexPath as IndexPath)
        cell.configureCell(thumb: imageObject)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return controller?.sections?[section].numberOfObjects ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let objs = controller.fetchedObjects, objs.count > 0 {
            let selectedImage = objs[indexPath.row]
            performSegue(withIdentifier: "image", sender: selectedImage)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "image" {
            if let destination = segue.destination as? ImageVC {
                if let selectedImage = sender as? Image {
                    destination.imageToEdit = selectedImage
                }
            }
        }
    }
    
    
}

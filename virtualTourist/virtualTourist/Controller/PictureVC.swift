//
//  ImagesVC.swift
//  virtualTourist
//
//  Created by xXxXx on 02/07/2019.
//  Copyright © 2019 abdullah. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import CoreData

class PictureVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, NSFetchedResultsControllerDelegate  {
    
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionButton: UIBarButtonItem!
    @IBOutlet weak var msgLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    var fetchedResultsController: NSFetchedResultsController<Picture>!
    var pin: Pin!
    var pageNumber = 1
    var isDeletingEverything = false
    var context: NSManagedObjectContext {
        return DataController.shared.viewContext
    }
    var doWeHavePicture: Bool {
        return (fetchedResultsController.fetchedObjects?.count ?? 0) != 0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupFetchedResultsController()
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        fetchedResultsController = nil
    }
    
    func setupFetchedResultsController() {
        let fetchRequest: NSFetchRequest<Picture> = Picture.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "pin == %@", pin)
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "creationDate", ascending: false)
        ]
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        
        do {
            try fetchedResultsController.performFetch()
            if doWeHavePicture {
                updateUI(processing: false)
            } else {
                collectionButtonClicked(self)
            }
        } catch {
            fatalError("The fetch not performed: \(error.localizedDescription)")
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func collectionButtonClicked(_ sender: Any) {
        
        updateUI(processing: true)
        if doWeHavePicture {
            isDeletingEverything = true
            for picture in fetchedResultsController.fetchedObjects! {
                context.delete(picture)
            }
            
            try? context.save()
            isDeletingEverything = false
        }
        
        FlickrAPI.getPhotoUrls(with: pin.coordinate, pageNumber: pageNumber) { (urls, error, errorMessage) in
            DispatchQueue.main.async {
                self.updateUI(processing: false)
                
                guard (error == nil) && (errorMessage == nil) else {
                    
                    self.alert(title: "Error", message: error?.localizedDescription ?? errorMessage)
                    return
                }
                guard let urls = urls, !urls.isEmpty else {
                    self.msgLabel.isHidden = false
                    return
                }
                
                for url in urls {
                    let picture = Picture(context: self.context)
                    picture.pictureURL = url
                    picture.pin = self.pin
                    
                }
                try? self.context.save()
            }
            
        }
        pageNumber += 1
    }
    func updateUI(processing: Bool) {
        collectionView.isUserInteractionEnabled = !processing
        if processing {
            collectionButton.title = ""
            activityIndicator.startAnimating()
            
        } else {
            activityIndicator.stopAnimating()
            collectionButton.title = "New Collection"
        }
    }
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransition(to: newCollection, with: coordinator)
        collectionView.reloadData()
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fetchedResultsController.fetchedObjects?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! PictureCell
        let picture = fetchedResultsController.object(at: indexPath)
        cell.imageView.setPicture(picture)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let picture = fetchedResultsController.object(at: indexPath)
        context.delete(picture)
        try? context.save()
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section:Int) -> CGFloat {
        return 10
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section:Int) -> CGFloat {
        return 10
    }
//
//    @IBAction func selectPhoto(_ sender: UIButton) {
//        let sheet = UIAlertController(title:Translation.Shared.GetVal(Key: "selct_photo"), message: nil, preferredStyle: .actionSheet)
//
//        let cameraAction = UIAlertAction(title:Translation.Shared.GetVal(Key: "cam"), style: .default)
//        {(alert) in
//
//            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
//                let imagePicker = UIImagePickerController()
//                imagePicker.delegate = self
//                imagePicker.sourceType = UIImagePickerControllerSourceType.camera
//                imagePicker.allowsEditing = true
//
//                self.present(imagePicker, animated: true, completion: nil)
//            }
//
//        }
//
//        let GalleryAction = UIAlertAction(title:Translation.Shared.GetVal(Key: "studio"), style: .default)
//        {
//            (alert) in
//            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
//                let imagePicker = UIImagePickerController()
//                imagePicker.delegate = self
//                imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
//                // imagePicker.allowsEditing = true
//                self.present(imagePicker, animated: true, completion: nil)
//            }
//
//
//        }
//
//
//        let cancelAction = UIAlertAction(title:Translation.Shared.GetVal(Key: "cancel"), style: .cancel)
//        {
//            (alert) in
//        }
//
//        sheet.addAction(GalleryAction)
//        sheet.addAction(cameraAction)
//        //        sheet.addAction(pdff)
//
//        sheet.addAction(cancelAction)
//
//        ///// hidden the button when load more 3 photo
//        if AttachmentFromDevice.count == 3
//        {
//            selectPhotoBtn.isEnabled = false
//        }else
//        {
//
//            if let popoverController = sheet.popoverPresentationController {
//                popoverController.sourceView = self.view
//                popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
//                popoverController.permittedArrowDirections = []
//            }
//
//
//
//            self.present(sheet, animated: true, completion: nil)
//
//
//        }
//
//    }
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        if let indexPath = indexPath, type == .delete && !isDeletingEverything{
            collectionView.deleteItems(at: [indexPath])
            return
        }
        if let indexPath = indexPath, type == .insert {
            collectionView.insertItems(at: [indexPath])
            return
        }
        if let newIndexPath = newIndexPath, let oldIndexPath = indexPath,  type == .move {
            collectionView.moveItem(at: oldIndexPath, to: newIndexPath)
            return
        }
        if type != .update {
            collectionView.reloadData()
            return
        }
    }
}



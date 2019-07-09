//
//  CustImageView.swift
//  virtualTourist
//
//  Created by xXxXx on 02/07/2019.
//  Copyright © 2019 abdullah. All rights reserved.
//

import Foundation
import UIKit


protocol CustomImageViewDelegate {
    func imageDidDownload()
}

let picturesCache = NSCache<NSString, AnyObject>()

class CustImageView: UIImageView {
    var pictureURL: URL!
    
    func setPicture(_ newPicture: Picture) {
        if picture != nil {
             return
        }
        picture = newPicture
    }
    
    private var picture: Picture! {
        didSet {
            if let image = picture.getImage() {
                hideActivityIndicatorView()
                self.image = image
                return
            }
           
            
            guard let url = picture.pictureURL else {
            return
                
            }
            loadImageUsingCache(with: url)
        }
        
    }
    
    func loadImageUsingCache(with url: URL) {
        pictureURL = url
//        picture = nil
        image = nil
        showActivityIndicatorView()
        if let cachedPicture = picturesCache.object(forKey: url.absoluteString as NSString) as?
            UIImage {
            image = cachedPicture
            hideActivityIndicatorView()
            return
        }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard let DownloadedPicture = UIImage(data: data!) else { return }
            picturesCache.setObject(DownloadedPicture, forKey: url.absoluteString as NSString)
            DispatchQueue.main.async {
                
                ////
                self.image = DownloadedPicture
                self.picture.set(image: DownloadedPicture)
                try? self.picture.managedObjectContext?.save()
                self.hideActivityIndicatorView()
            }
            
        }.resume()
    }
    lazy var activityIndicatorView: UIActivityIndicatorView = {
        let activityIndicatorView = UIActivityIndicatorView(style: .whiteLarge)
        self.addSubview(activityIndicatorView)
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicatorView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        activityIndicatorView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        activityIndicatorView.color = .black
        activityIndicatorView.hidesWhenStopped = true
        return activityIndicatorView
    }()
    
    func showActivityIndicatorView() {
        DispatchQueue.main.async {
            self.activityIndicatorView.startAnimating()
        }
    }
    func hideActivityIndicatorView() {
        DispatchQueue.main.async {
            self.activityIndicatorView.stopAnimating()
        }
    }
    
}

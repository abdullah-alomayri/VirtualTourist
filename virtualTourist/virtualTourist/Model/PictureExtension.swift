//
//  ImageExtension.swift
//  virtualTourist
//
//  Created by xXxXx on 02/07/2019.
//  Copyright © 2019 abdullah. All rights reserved.
//

import Foundation
import UIKit


extension Picture {
    func set(image: UIImage) {
        ///image picture
        self.picture = image.pngData()
    }
    func getImage() -> UIImage? {
        ///image picture
        return (picture == nil) ? nil : UIImage(data: picture!)
        
    }
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        creationDate = Date()
    }
    
}

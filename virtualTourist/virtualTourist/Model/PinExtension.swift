//
//  PinExtension.swift
//  virtualTourist
//
//  Created by xXxXx on 02/07/2019.
//  Copyright © 2019 abdullah. All rights reserved.
//

import Foundation
import MapKit

extension Pin {
    
    var  coordinate: CLLocationCoordinate2D {
        set {
            latitude = newValue.latitude
            longtiude = newValue.longitude
        }
        get {
            return CLLocationCoordinate2D(latitude: latitude, longitude: longtiude)
        }
    }
    
    func compare(to coordinate: CLLocationCoordinate2D) -> Bool {
        return (latitude == coordinate.latitude && longtiude == coordinate.longitude)
    }
    
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        creationDate = Date()
    }
}

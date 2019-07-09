//
//  Const.swift
//  virtualTourist
//
//  Created by xXxXx on 02/07/2019.
//  Copyright © 2019 abdullah. All rights reserved.
//

import Foundation
import MapKit

struct Const {
    struct Flickr {
        static let APIScheme = "https"
        static let APIHost = "api.flickr.com"
        static let APIPath = "/services/rest"
        
        static let SearchBBoxHalfWidth = 1.0
         static let SearchBBoxHalfHeight = 1.0
         static let SearchLatRange = (-90.0, 90.0)
          static let SearchLonRange = (-180.0, 180.0)
    }
    
    struct FlickrParameterKeys {
        static let Method = "method"
         static let APIKey = "api_key"
        static let Extras = "extras"
        static let Format = "format"
        static let NoJSONCallback = "nojsoncallback"
        static let SafeSearch = "safe_search"
        static let Text = "text"
        static let BoundingBox = "bbox"
        static let Page = "page"
        static let PerPage = "per_page"
    }
    struct FlickrParameterValues {
        ///
        static let SearchMethod = "flickr.photos.search"
        ///
        static let APIKey = "e4fb7762930f671de418786661233c28"
        static let ResponseFormat = "json"
        //1 means yes
        static let DisableJSONCallback = "1"
        static let GalleryPhotosMethod = "flickr.galleries.getPhotos"
        static let MediumURL = "url_m"
        static let UseSafeSearch = "1"
    
    }
    
}

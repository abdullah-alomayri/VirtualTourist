//
//  FlickerAPI.swift
//  virtualTourist
//
//  Created by xXxXx on 02/07/2019.
//  Copyright © 2019 abdullah. All rights reserved.
//

import Foundation
import MapKit


struct FlickrAPI {
    
    static func getPhotoUrls(with coordinate: CLLocationCoordinate2D, pageNumber: Int, completion: @escaping ([URL]?, Error?, String?) -> ()) {
        let methodParameters = [
            Const.FlickrParameterKeys.Method: Const.FlickrParameterValues.SearchMethod,
            Const.FlickrParameterKeys.APIKey: Const.FlickrParameterValues.APIKey,
            Const.FlickrParameterKeys.BoundingBox: bboxString(for: coordinate),
            Const.FlickrParameterKeys.SafeSearch: Const.FlickrParameterValues.UseSafeSearch,
            Const.FlickrParameterKeys.Extras: Const.FlickrParameterValues.MediumURL,
            Const.FlickrParameterKeys.Format: Const.FlickrParameterValues.ResponseFormat,
            Const.FlickrParameterKeys.NoJSONCallback: Const.FlickrParameterValues.DisableJSONCallback,
            Const.FlickrParameterKeys.Page: pageNumber,
            Const.FlickrParameterKeys.PerPage: 9,
            
            ] as [String: Any]

        let request = URLRequest(url: getURL(from: methodParameters))
//        let request = URLRequest(url: getURL(from: ))
        let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
            guard (error == nil) else {
                completion(nil, error, nil)
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                completion(nil,nil, "your request returned a status code out of 200 - 299!")
                return
            }

            guard let data = data else {
                
                completion(nil, nil, "No data returned")
                return
            }
            guard let result = try? JSONSerialization.jsonObject(with: data, options: []) as! [String:Any] else {
                completion(nil, nil, "JSON data Could not be parsed")
                return
            }
            
            guard let stat = result["stat"] as? String, stat == "ok" else {
                
                completion(nil, nil, "Flickr API returned an error. see error code and message in \(result)")
                return
            }
            guard let photosDictionary = result["photos"] as? [String:Any] else {
                  completion(nil, nil, "couldn't found key 'photos' in \(result)")
                return
            }
            guard let photosArray = photosDictionary["photo"] as? [[String:Any]] else {
                completion(nil, nil, "couldn't found key 'photo' in \(photosDictionary)")
                return
            }
            let photosURLs = photosArray.compactMap { photoDictionary -> URL? in
                guard let url = photoDictionary["url_m"] as? String else { return nil }
                return URL(string: url)
            }
            completion(photosURLs, nil, nil)
            
        }
        task.resume()
    }
    
    
    static func bboxString(for coordinate: CLLocationCoordinate2D) -> String {
        let latitude = coordinate.latitude
        let longitude = coordinate.longitude

        let minimumLon = max(longitude - Const.Flickr.SearchBBoxHalfWidth, -180)
        let minimumLat = max(latitude - Const.Flickr.SearchBBoxHalfHeight, -90)
        let maximumLon = min(longitude + Const.Flickr.SearchBBoxHalfWidth, 180)
        let maximumLat = min(latitude + Const.Flickr.SearchBBoxHalfHeight, 90)
      
        return "\(minimumLon),\(minimumLat),\(maximumLon),\(maximumLat), "
    }
    static func getURL(from parameters:[String: Any]) -> URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = Const.Flickr.APIHost
        components.path = Const.Flickr.APIPath
        components.queryItems = [URLQueryItem]()
        
         let APIPath = "/services/rest"
        for (key, value) in parameters {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
            
        }
        return components.url!
    }
}

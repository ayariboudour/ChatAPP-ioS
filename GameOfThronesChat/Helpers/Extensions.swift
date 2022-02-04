//
//  Extensions.swift
//  GameOfThronesChat
//
//  Created by sarah sghair on 14/08/2018.
//  Copyright © 2018 Boudour Ayari. All rights reserved.
//

import UIKit
let imageCache = NSCache<AnyObject, AnyObject>()
extension UIImageView {
    
    func loadImageUsingCacheWithUrlString(urlString: String) {
        self.image = nil
        //check cache for image first
        if let cachedImage = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
            self.image = cachedImage
            return
        }
        //otherwise fire off a new dowload
        let url = URL(string: urlString)
        let session = URLSession.shared
        session.dataTask(with: url!) {
            (data, response, error) in
            
            //error download
            if error != nil {
                print(error!)
                return
            }
            //succecful
            DispatchQueue.main.async {
                if let downloadedImage = UIImage(data: data!) {
                    imageCache.setObject(downloadedImage, forKey: urlString as AnyObject)
                        self.image = downloadedImage
                    return
                }
            }
            }.resume()
    }
}



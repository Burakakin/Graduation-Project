//
//  extension.swift
//  GraduationProject
//
//  Created by Burak Akin on 19.10.2018.
//  Copyright © 2018 Burak Akin. All rights reserved.
//

import Foundation
import UIKit


// To Download Image from URL
//extension UIImageView {
//
//    func download(url urlString: String) {
//        guard let url = URL(string: urlString) else { return }
//
//        let task = URLSession.shared.dataTask(with: url) { (downloadedData, _, error) in
//            guard error == nil && downloadedData != nil else { return }
//            DispatchQueue.main.async{
//                self.image = UIImage(data: downloadedData!)
//            }
//        }
//        task.resume()
//    }
//
//}

class imageDownload {
    
    static let cache = NSCache<NSString, UIImage>()
    
    static func download(withUrl urlString: String, completion: @escaping (_ image: UIImage?)->()) {
        guard let url = URL(string: urlString) else { return }
        let task = URLSession.shared.dataTask(with: url) { (data, _, error) in
//            guard error == nil && data != nil else { return }
            var downloadedImage: UIImage?
            
            if let data = data {
                downloadedImage = UIImage(data: data)
            }
            
            if downloadedImage != nil {
                cache.setObject(downloadedImage!, forKey: url.absoluteString as NSString)
            }
            
            DispatchQueue.main.async {
                completion(downloadedImage)
            }
            
        }
        task.resume()
    }
    
    
    
    static func getImage(withUrl urlString: String, completion: @escaping (_ image: UIImage?)->()) {
        guard let url = URL(string: urlString) else { return }
        if let image = cache.object(forKey: url.absoluteString as NSString) {
            completion(image)
        }
        else {
            download(withUrl: urlString, completion: completion)
        }
        
    }
    
    
}

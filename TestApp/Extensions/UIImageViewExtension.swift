//
//  UIImageViewExtension.swift
//  JatAppTest
//
//  Created by Ihor Zaliskyj on 22.11.2022.
//

import UIKit
import CoreImage


extension UIImageView {
    
    func downloadImage(fromUrl url: URL) {
        let imageKey = url.absoluteURL.lastPathComponent as NSString
        print(imageKey)
        let imageCache = NSCache<NSString, UIImage>()
        if let cachedImage = imageCache.object(forKey: "imageKey") {
            self.image = cachedImage
            return
        }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            DispatchQueue.main.async() {
                guard
                    let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                    let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                    let data = data, error == nil,
                    let image = UIImage(data: data)
                else { return }
                imageCache.setObject(image, forKey: "imageKey")
                self.image = image
            }
    }.resume()
    }
}

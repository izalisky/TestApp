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
        let imageCache = NSCache<NSString, UIImage>()
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            imageCache.setObject(image, forKey: url.absoluteURL.absoluteString as NSString)
            DispatchQueue.main.async() { () -> Void in
                self.image = image
            }
        }.resume()
    }
}

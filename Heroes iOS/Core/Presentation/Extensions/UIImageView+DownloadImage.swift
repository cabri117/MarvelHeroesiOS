//
//  UITableViewCell+DownloadImage.swift
//  Heroes iOS
//
//  Created by TR64UV on 11/11/2020.
//

import UIKit
extension UIImageView {
    
    private func getData(from url: URL,
                         completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func downloadImage(from url: URL,
                       cacheImage:NSCache<NSString, UIImage>,
                       completion: @escaping () -> ()) {
        guard let cachedImage = cacheImage.object(forKey: url.absoluteString as NSString) else {
            getData(from: url) { [weak self] data, response, error in
                guard let data = data,
                      error == nil,
                      let self = self,
                      let image = UIImage(data: data) else { return }
                cacheImage.setObject(image, forKey: url.absoluteString as NSString)
                DispatchQueue.main.async {
                    self.image = UIImage(data: data)
                    completion()
                }
                
            }
            return
        }
        DispatchQueue.main.async {
            self.image = cachedImage
            completion()
        }
        
    }
}



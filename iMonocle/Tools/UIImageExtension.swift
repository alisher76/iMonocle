//
//  UIImageExtension.swift
//  iMonocle
//
//  Created by Alisher Abdukarimov on 7/21/17.
//  Copyright © 2017 MrAliGorithm. All rights reserved.
//

import UIKit


extension UIImageView {
    func downloadFrom(url: URL, contentMode mode: UIViewContentMode = .scaleAspectFill) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) {(data, responce, error) in
            guard
                let httpURLResponce = responce as? HTTPURLResponse, httpURLResponce.statusCode == 200,
                let mimeType = responce?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async {
                self.image = image
            }
        }.resume()
    }
    
    func downloadedFrom(link: String, contentMode mode: UIViewContentMode = .scaleAspectFill) {
        guard let url = URL(string: link) else { return }
        downloadFrom(url: url, contentMode: mode)
    }
    
}

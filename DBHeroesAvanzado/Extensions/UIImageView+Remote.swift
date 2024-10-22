//
//  UIImageView+Remote.swift
//  DBHeroesAvanzado
//
//  Created by Diego Herreros Parron on 22/10/24.
//

import UIKit


extension UIImageView {
    
    func setImage(url: String) {
        guard let urlString = URL(string: url) else { return }
        downloadWithURLSession(url: urlString) { [weak self] image in
            DispatchQueue.main.async {
                self?.image = image
            }
            
        }
    }
    
    
    
    private func downloadWithURLSession(url: URL, completion: @escaping (UIImage?) -> Void) {
        
        URLSession.shared.dataTask(with: URLRequest(url: url)) {data, _, _ in
            guard let data, let photo = UIImage(data: data) else {
                completion(nil)
                return
            }
            completion(photo)
        }
        .resume()
    }
    
}

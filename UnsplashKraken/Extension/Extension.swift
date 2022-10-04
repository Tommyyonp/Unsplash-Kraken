//
//  Extension.swift
//  Unsplash
//
//  Created by Tommy Yon Prakoso on 25/08/22.
//

import Foundation
import UIKit

extension UIImageView {
    func getPhoto(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }

    func downloadImage (from urlString: String) {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.frame = CGRect (x: 0, y: 0, width: 64, height: 64)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        activityIndicator.center = CGPoint (x: self.frame.size.width/2,
                                            y: self.frame.size.height/2)
        self.addSubview(activityIndicator)
        contentMode = .scaleAspectFill

        guard let url = URL(string: urlString) else { return }
        getPhoto(from: url) {data ,response, error in
            guard let httpURLResponse = response as? HTTPURLResponse,
                    httpURLResponse.statusCode == 200,
            let mimeType = response?.mimeType,
                  mimeType.hasPrefix("image"),
            let data = data, error == nil,
            let image = UIImage (data: data)
            else
            {
                return
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.image = image
                activityIndicator.stopAnimating()
            }
        }
    }
}

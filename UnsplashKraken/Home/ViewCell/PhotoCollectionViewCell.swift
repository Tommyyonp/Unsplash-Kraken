//
//  PhotoCollectionViewCell.swift
//  Unsplash
//
//  Created by Tommy Yon Prakoso on 08/07/22.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {

    static let identifier = "PhotoCollectionViewCell"

    // MARK: - Outlets

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var imageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }

    func setupUI() {
        imageView.layer.shadowRadius = 6
        imageView.layer.cornerRadius = 20
        imageView.layer.masksToBounds = true
    }

    class func nib() -> UINib {
        UINib(nibName: "PhotoCollectionViewCell", bundle: nil)
    }

}

//
//  DetailViewController.swift
//  Unsplash
//
//  Created by Tommy Yon Prakoso on 26/08/22.
//

import UIKit

class DetailViewController: UIViewController {

    //MARK: - Outlets
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var profileView: UIImageView!

    //MARK: - Variable
    var result: PhotosResult?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
            guard let result = result else { return }
            image.downloadImage(from: result.urls.regular)
            descLabel.text = result.resultDescription
            nameLabel.text = result.user.name
            usernameLabel.text = "@" + (result.user.instagramUsername ?? "-")
            likeLabel.text = "\(result.likes)"

            profileView.downloadImage(from: result.user.profileImage.large)
            profileView.layer.cornerRadius = profileView.layer.frame.width / 2
            profileView.layer.masksToBounds = true
    }
}

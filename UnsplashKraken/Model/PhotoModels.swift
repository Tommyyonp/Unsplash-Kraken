//
//  PhotoModels.swift
//  Unsplash
//
//  Created by Tommy Yon Prakoso on 23/08/22.
//

import Foundation

// MARK: - APIResponse
struct PhotosResponse: Codable {
    let totalPages: Int
    let results: [PhotosResult]

    enum CodingKeys: String, CodingKey {
        case totalPages = "total_pages"
        case results
    }
}

// MARK: - Result
struct PhotosResult: Codable, Identifiable {
    let id: String
    let urls: Urls
    let likes: Int
    let height : Int
    let resultDescription: String?
    let user: User

    enum CodingKeys: String, CodingKey {
        case id
        case likes
        case height
        case resultDescription = "description"
        case urls
        case user
    }
}

// MARK: - Urls
struct Urls: Codable {
    let regular: String
}

// MARK: - User
struct User: Codable {
    let id: String
    let name: String
    let profileImage: ProfileImage
    let instagramUsername: String?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case profileImage = "profile_image"
        case instagramUsername = "instagram_username"
    }
}

// MARK: - ProfileImage
struct ProfileImage: Codable {
    let large: String
}

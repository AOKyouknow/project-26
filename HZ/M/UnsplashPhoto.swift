//
//  UnsplashPhoto.swift
//  HZ
//
//  Created by Алик on 06.10.2025.
//

import Foundation

struct UnsplashPhoto: Codable {
    let id: String
    let urls: PhotoURLs
    let user: User
}

struct PhotoURLs: Codable { // все ли свойства нужны? может стоит от каких-то избавитья, которые не используется - в этой и в других codable моделях
    let raw: String
    let full: String
    let regular: String
    let small: String
    let thumb: String
}

struct User: Codable {
    let name: String
    let username: String
}

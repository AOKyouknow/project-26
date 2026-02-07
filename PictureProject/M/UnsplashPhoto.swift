//
//  UnsplashPhoto.swift
//  HZ
//
//  Created by Алик on 06.10.2025.
//

import Foundation

// MARK: - Модель фотографии
struct UnsplashPhoto: Codable {
    let id: String
    let urls: PhotoURLs
    let user: User
}

// MARK: - Модель URL фотографий разных размеров
// Decodable, т.к. работаем только с получением данных.
struct PhotoURLs: Decodable {
// все ли свойства нужны? может стоит от каких-то избавитья, которые не используется - в этой и в других codable моделях
    let raw: String
    let full: String
    let regular: String
    let small: String
    let thumb: String
}

struct User: Decodable {
    let name: String
    let username: String
}

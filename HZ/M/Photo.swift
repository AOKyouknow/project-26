//
//  Mode.swift
//  HZ
//
//  Created by Алик on 04.10.2025.
//

import Foundation


struct Photo: Codable {
    let id: String
    let urls: PhotoURLs
    let user: User
    let description: String?
    let createdAt: String?
    let location: Location?
    let downloads: Int?
    
    struct PhotoURLs: Codable {
        let regular: String
        let small: String
    }
    
    struct User: Codable {
        let name: String
        let username: String
    }
    
    struct Location: Codable {
        let name: String?
    }
    
    
    
}

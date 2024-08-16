//
//  Symbols.swift
//  PostList
//
//  Created by Pawan Kumar Dhawan on 14/08/24.
//

import Foundation

struct Post: Codable {
    let userId: Int
    let id: Int
    let title: String
    let body: String
    
    enum CodingKeys: String, CodingKey {
        case userId
        case id
        case title
        case body
    }
}
extension Post {
    init?(data: Data) {
        do {
            let me = try JSONDecoder().decode(Post.self, from: data)
            self = me
        }
        catch {
            return nil
        }
    }
}

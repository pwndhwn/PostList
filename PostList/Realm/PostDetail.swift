//
//  PostDetail.swift
//  PostList
//
//  Created by Pawan Kumar Dhawan on 14/08/24.
//

import Foundation
import RealmSwift

class PostDetail: Object {
    
    @Persisted var id: Int?
    @Persisted var userId: Int?
    @Persisted var title: String?
    @Persisted var body: String?
    @Persisted var isFavorite: Bool = false
}

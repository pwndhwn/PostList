//
//  CurrencyDetailsCellViewModel.swift
//  Currency
//
//  Created by Pawan Kumar Dhawan on 16/08/24.
//

import Foundation

class PostListCellViewModel {
    
    let postDetail:PostDetail!
    
    init(postDetail: PostDetail) {
        self.postDetail = postDetail
    }
    
    func getPostTitle() -> String {
        return postDetail.title ?? ""
    }
    
    func getPostDescription() -> String {
        return postDetail.body ?? ""
    }
    
}

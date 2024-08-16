//
//  FavouriteListViewModel.swift
//  PostList
//
//  Created by Pawan Kumar Dhawan on 14/08/24.
//

import Foundation
import RxSwift
import RxCocoa
import RealmSwift

class FavouriteListViewModel:BaseViewModel {
    
    public let posts : PublishSubject<[PostDetail]> = PublishSubject()
    
    func requestMyFavoritePosts(){
        
        let realm = try! Realm()
        // Access all dogs in the realm
        let posts = realm.objects(PostDetail.self)
        // Query by age
        let favPosts = posts.where {
            $0.isFavorite == true
        }
        
        let array = Array(favPosts)
        self.posts.onNext(array)
    }
}

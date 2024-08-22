//
//  HomeViewModel.swift
//  PostList
//
//  Created by Pawan Kumar Dhawan on 14/08/24.
//

import Foundation
import RxSwift
import RxCocoa
import RealmSwift


protocol HomeViewModelDelegate: AnyObject {
    func updateList(list: [PostDetail])
}

class HomeViewModel:BaseViewModel {
    
    weak var delegate: HomeViewModelDelegate?
    
    public let postDetails : PublishSubject<[PostDetail]> = PublishSubject()
    
    let apiManager:APIManager!
    
    init(apiManager:APIManager) {
        self.apiManager = apiManager
    }
    
    func requestAllPosts(){
        let realm = try! Realm()
        let posts = realm.objects(PostDetail.self)
        let array = Array(posts)
        if array.count > 0 {
            if let delegate = delegate {
                delegate.updateList(list: array)
            } else {
                self.postDetails.onNext(array)
            }
        } else {
            requestAllPostsFromServer()
        }
    }
    
    private func requestAllPostsFromServer(){
        
        self.loading.onNext(true)
        apiManager.requestData(url: APIManager.CONST_Posts, method: .get, parameters: nil, completion: { [weak self] (result) in
            guard let self = self else { return }
            self.loading.onNext(false)
            switch result {
            case .success(let returnJson) :
                if let posts = try? JSONDecoder().decode([Post].self, from: try! returnJson.rawData()) {
                    let realm = try! Realm()
                    try! realm.write {
                        for post in posts {
                            let postDetail = PostDetail()
                            postDetail.id = post.id
                            postDetail.title = post.title
                            postDetail.body = post.body
                            postDetail.userId = post.userId
                            realm.add(postDetail)
                            
                        }
                    }
                    DispatchQueue.main.async {
                        self.requestAllPosts()
                    }
                }
            case .failure(let failure) :
                self.handleErrorCase(failure, self)
            }
        })
        
    }
    
    func updateIsFavoriteStatus(_ post: ControlEvent<PostDetail>.Element) {
        let realm = try! Realm()
        let results = realm.objects(PostDetail.self).filter("id = \(post.id ?? 0)")
        if let post = results.first {
            try! realm.write {
                post.isFavorite = !post.isFavorite
            }
        }
    }
}


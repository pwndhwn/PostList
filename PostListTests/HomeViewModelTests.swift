//
//  HomeViewModelTests.swift
//  PostListTests
//
//  Created by Pawan Kumar Dhawan on 19/08/24.
//

import XCTest
@testable import PostList
import SwiftyJSON
import RxSwift
import RealmSwift

class HomeViewModelTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Use an in-memory Realm identified by the name of the current test.
        // This ensures that each test can't accidentally access or modify the data
        // from other tests or the application itself, and because they're in-memory,
        // there's nothing that needs to be cleaned up.
        Realm.Configuration.defaultConfiguration.inMemoryIdentifier = self.name
    }
    
    func testMethodRequestAllPosts() throws {
        
        let json = MockApiManager.jsonFromFile(fileName: "PostList")
        let result = MockApiManager.ApiResult.success(json!)
        let apiManager = MockApiManager(response: result)
        let bag = DisposeBag()
        
        let viewModel = HomeViewModel(apiManager: apiManager)
        viewModel
            .postDetails
            .subscribe(onNext: { posts in
                XCTAssertEqual(posts.count, 10)
                if let first = posts.first,
                    let last = posts.last  {
                    XCTAssertEqual((first.userId ?? 0), 1)
                    XCTAssertEqual((last.userId ?? 0), 10)
                    
                    viewModel.updateIsFavoriteStatus(first)
                    XCTAssertTrue(first.isFavorite)
                    
                    viewModel.updateIsFavoriteStatus(last)
                    XCTAssertTrue(last.isFavorite)
                    
                    viewModel.updateIsFavoriteStatus(first)
                    XCTAssertFalse(first.isFavorite)
                    
                    viewModel.updateIsFavoriteStatus(last)
                    XCTAssertFalse(last.isFavorite)
                }
            })
            .disposed(by: bag)
        viewModel.requestAllPosts()
    }
    
    
}

//
//  MockApiManager.swift
//  PostListTests
//
//  Created by Pawan Kumar Dhawan on 19/08/24.
//

import XCTest
@testable import PostList
import SwiftyJSON
import RxSwift

class MockApiManager:APIManager {
    
    var response:ApiResult!
    
    init(response:ApiResult) {
        self.response = response
    }
    
    override func requestData(url: String, method: APIManager.HTTPMethod, parameters: APIManager.parameters?, completion: @escaping (APIManager.ApiResult) -> Void) {
        completion(response)
    }
    
    static func jsonFromFile(fileName:String) -> JSON?
        {
            guard let path = Bundle(for: MockApiManager.self).path(forResource: fileName, ofType: "json"),
                       let data = try? NSData.init(contentsOfFile: path, options: []) else {
                           fatalError("\(fileName).json not found")
                   }
            return try? JSON(data: data as Data)
        }
    
}

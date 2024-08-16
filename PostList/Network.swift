//
//  Network.swift
//  PostList
//
//  Created by Pawan Kumar Dhawan on 14/08/24.
//

import Foundation
import RxSwift
import RxCocoa
import SwiftyJSON


class APIManager {
    
    static let CONST_BaseUrl = "https://jsonplaceholder.typicode.com/"
    static let CONST_Posts = "posts"
    
    typealias parameters = [String:Any]
    
    public enum ApiResult {
        case success(JSON)
        case failure(RequestError)
    }
    enum HTTPMethod: String {
        case options = "OPTIONS"
        case get     = "GET"
        case head    = "HEAD"
        case post    = "POST"
        case put     = "PUT"
        case patch   = "PATCH"
        case delete  = "DELETE"
        case trace   = "TRACE"
        case connect = "CONNECT"
    }
    enum RequestError: Error {
        case unknownError
        case connectionError
        case authorizationError(JSON)
        case invalidRequest
        case notFound
        case invalidResponse
        case serverError
        case serverUnavailable
        case errorWithCode(String)
    }
    
    func requestData(url:String,method:HTTPMethod,parameters:parameters?,completion: @escaping (ApiResult)->Void) {
        
        var urlRequest = URLRequest(url: URL(string: APIManager.CONST_BaseUrl+url)!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10)
        urlRequest.httpMethod = method.rawValue
        if let parameters = parameters {
            let parameterData = parameters.reduce("") { (result, param) -> String in
                return result + "&\(param.key)=\(param.value as! String)"
            }.data(using: .utf8)
            urlRequest.httpBody = parameterData
        }
        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if error != nil {
                completion(ApiResult.failure(.connectionError))
            }else if let data = data ,let responseCode = response as? HTTPURLResponse {
                do {
                    let responseJson = try JSON(data: data)
                    switch responseCode.statusCode {
                    case 200:
                        if let dict = responseJson.dictionary, let error = dict["error"] {
                            let info = error["info"]
                            let code = error["code"]
                            completion(ApiResult.failure(.errorWithCode("\(info) ERROR CODE: \(code)")))
                        } else {
                            completion(ApiResult.success(responseJson))
                        }
                    case 400...499:
                    completion(ApiResult.failure(.authorizationError(responseJson)))
                    case 500...599:
                    completion(ApiResult.failure(.serverError))
                    default:
                        completion(ApiResult.failure(.unknownError))
                        break
                    }
                }
                catch _ {
                    completion(ApiResult.failure(.invalidResponse))
                }
            }
        }.resume()
    }
}


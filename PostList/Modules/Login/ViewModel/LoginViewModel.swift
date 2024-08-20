//
//  LoginViewModel.swift
//  PostList
//
//  Created by Pawan Kumar Dhawan on 14/08/24.
//

import Foundation
import RxSwift
import UIKit

class LoginViewModel  {
    
    var email:BehaviorSubject<String> = BehaviorSubject(value: "")
    var password:BehaviorSubject<String> = BehaviorSubject(value: "")
    
    var isValidEmail:Observable<Bool> {
        email.map{$0.isValidEmail()}
    }
    
    var isValidPassword:Observable<Bool> {
        password.map { password in
            return ( password.count > 7 && password.count < 16 ) ? true : false
        }
    }
    
    var isValidInput:Observable<Bool> {
        return Observable.combineLatest(isValidEmail, isValidPassword).map({ $0 && $1 })
    }
    //Our viewModel is ready
}


extension String {
    func isValidEmail() -> Bool {
        let regex = try! NSRegularExpression(pattern: "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$", options: .caseInsensitive)
        return regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count)) != nil
    }
}

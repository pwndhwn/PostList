//
//  BaseViewModel.swift
//  PostList
//
//  Created by Pawan Kumar Dhawan on 14/08/24.
//

import Foundation
import RxSwift
import RxCocoa


class BaseViewModel {
    
    public enum HomeError {
        case internalError(String)
        case internetError(String)
        case serverMessage(String)
    }
    
    public let loading: PublishSubject<Bool> = PublishSubject()
    public let error : PublishSubject<HomeError> = PublishSubject()
    private let disposable = DisposeBag()


    func handleErrorCase(_ failure: (APIManager.RequestError), _ self: BaseViewModel) {
        switch failure {
        case .connectionError:
            self.error.onNext(.internetError(Constants.MSG_InternetError))
        case .authorizationError(let errorJson):
            self.error.onNext(.serverMessage(errorJson["message"].stringValue))
        case .errorWithCode(let message):
            self.error.onNext(.serverMessage(message))
        default:
            self.error.onNext(.serverMessage(Constants.MSG_UnknownError))
        }
    }
}

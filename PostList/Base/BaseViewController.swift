//
//  BaseViewController.swift
//  PostList
//
//  Created by Pawan Kumar Dhawan on 14/08/24.
//

import UIKit
import RxSwift
import RxCocoa


class BaseViewController: UIViewController {
    
    var bag = DisposeBag()
    var viewModel:BaseViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNecessaryBinding()
    }
    

    func setupNecessaryBinding(){
        
        //bind Necessary items
        guard let viewModel = viewModel else { return }
        
        viewModel.loading.bind(to: self.rx.isAnimating).disposed(by: bag)
        
        viewModel
            .error
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { (error) in
                switch error {
                case .internetError(let message):
                    MessageView.sharedInstance.showOnView(message: message, theme: .error)
                case .serverMessage(let message):
                    MessageView.sharedInstance.showOnView(message: message, theme: .warning)
                case .internalError(let message):
                    MessageView.sharedInstance.showOnView(message: message, theme: .warning)
                }
            })
            .disposed(by: bag)
        
        

        
    }
    
}

//
//  ReactiveExtensions.swift
//  PostList
//
//  Created by Pawan Kumar Dhawan on 14/08/24.
//

import Foundation


import UIKit
import RxSwift
import RxCocoa

extension UIViewController: loadingViewable {}

extension Reactive where Base: UIViewController {
    
    /// Bindable sink for `startAnimating()`, `stopAnimating()` methods.
    public var isAnimating: Binder<Bool> {
        return Binder(self.base, binding: { (vc, active) in
            if active {
                vc.startAnimating()
            } else {
                vc.stopAnimating()
            }
        })
    }
    
}

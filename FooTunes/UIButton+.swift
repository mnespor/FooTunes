//
//  UIButton.swift
//  FooTunes
//
//  Created by Matthew Nespor on 1/28/17.
//  Copyright © 2017 Matthew Nespor. All rights reserved.
//

import UIKit
import ReactiveCocoa
import ReactiveSwift

extension UIButton {
    @discardableResult public func observePresses(with callback: @escaping () -> Void) -> Disposable? {
        return self.reactive.controlEvents([.touchUpInside]).observeValues { _ in callback() }
    }
}

extension Reactive where Base: UIButton {
    public func bindingTargetForImage(state: UIControlState) -> BindingTarget<UIImage?> {
        return makeBindingTarget { (button, image) in
            button.setImage(image, for: state)
        }
    }
}

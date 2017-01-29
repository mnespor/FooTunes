//
//  EqualizerIndicatorView+.swift
//  FooTunes
//
//  Created by Matthew Nespor on 1/28/17.
//  Copyright © 2017 Matthew Nespor. All rights reserved.
//

import UIKit
import EqualizerIndicatorView
import ReactiveSwift

extension Reactive where Base: EqualizerIndicatorView {
    var state: BindingTarget<EqualizerIndicatorView.state> {
        return makeBindingTarget { (equalizerView, newState) in
            equalizerView.setState(newState, animated: true)
        }
    }
}

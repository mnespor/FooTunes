//
//  ViewController.swift
//  FooTunes
//
//  Created by Matthew Nespor on 1/28/17.
//  Copyright © 2017 Matthew Nespor. All rights reserved.
//

import UIKit
import EqualizerIndicatorView
import ReactiveCocoa
import ReactiveSwift

class ViewController: UIViewController {
    fileprivate let viewModel = ViewModel()

    fileprivate static let playImage = UIImage(named: "play")!.withRenderingMode(.alwaysTemplate)
    fileprivate static let pauseImage = UIImage(named: "pause")!.withRenderingMode(.alwaysTemplate)

    // This is a third-party equalizer view I wanted to use. It doesn't have
    // ReactiveCocoa binding targets
    @IBOutlet weak var equalizerView: EqualizerIndicatorView!
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var playheadLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!

    override func viewDidLoad() {
        // <~ is the "bind" operator. Any type of stream can be bound to a binding target.
        durationLabel.reactive.text <~ viewModel.duration.map { $0.format() }
        playheadLabel.reactive.text <~ viewModel.playHead.map { $0.format() }
        progressView.reactive.progress <~ viewModel.progress
        equalizerView.reactive.state <~ viewModel.status.map { status in
            switch status {
            case .paused:
                return EqualizerIndicatorView.state.stop
            case .playing:
                return EqualizerIndicatorView.state.play
            }
        }

        // ReactiveCocoa has a built-in binding target for its title. I had to
        // add one for the button image.
        playPauseButton.reactive.bindingTargetForImage(state: .normal) <~ viewModel.status.map { status in
            switch status {
            case .paused:
                return ViewController.playImage
            case .playing:
                return ViewController.pauseImage
            }
        }

        // This is one way to handle UIControl events. Alternatively, you could
        // define an Action in the view model, then:
        // playPauseButton.reactive.pressed = CocoaAction(viewModel.toggle)
        // 
        // Actions start a SignalProducer that terminates when the work is done.
        // Great for modeling a long-running operation but perhaps overkill here.
        playPauseButton.observePresses { [weak self] in
            self?.viewModel.toggle()
        }
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

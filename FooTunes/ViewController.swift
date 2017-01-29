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

    @IBOutlet weak var equalizerView: EqualizerIndicatorView!
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var playheadLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!

    override func viewDidLoad() {
        durationLabel.reactive.text <~ viewModel.duration.map { $0.format() }
        playheadLabel.reactive.text <~ viewModel.playHead.map { $0.format() }
        progressView.reactive.progress <~ viewModel.progress
        equalizerView.reactive.state <~ viewModel.status.map { timeControlStatus in
            switch timeControlStatus {
            case .paused:
                return EqualizerIndicatorView.state.stop
            case .playing:
                return EqualizerIndicatorView.state.play
            }
        }

        playPauseButton.reactive.bindingTargetForImage(state: .normal) <~ viewModel.status.map { timeControlStatus in
            switch timeControlStatus {
            case .paused:
                return ViewController.playImage
            case .playing:
                return ViewController.pauseImage
            }
        }

        playPauseButton.observePresses { [weak self] in
            self?.viewModel.toggle()
        }
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

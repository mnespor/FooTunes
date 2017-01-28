//
//  ViewController.swift
//  FooTunes
//
//  Created by Matthew Nespor on 1/28/17.
//  Copyright © 2017 Matthew Nespor. All rights reserved.
//

import UIKit
import EqualizerIndicatorView

class ViewController: UIViewController {
    fileprivate let viewModel = ViewModel()

    @IBOutlet weak var equalizerView: EqualizerIndicatorView!
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var playheadLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        equalizerView.setState(.play, animated: true)
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}


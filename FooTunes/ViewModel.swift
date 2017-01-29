//
//  AudioPlayer.swift
//  FooTunes
//
//  Created by Matthew Nespor on 1/28/17.
//  Copyright © 2017 Matthew Nespor. All rights reserved.
//

import Foundation
import AVFoundation
import ReactiveCocoa
import ReactiveSwift
import Result

class ViewModel {
    enum Status {
        case playing
        case paused
    }

    let player = AVPlayer()
    let status: Property<Status>
    let playHead: Property<CMTime>
    let duration: Property<CMTime>
    let progress: Property<Float>

    init() {
        loadMedia(into: player)
        self.status = statusProperty(for: player)
        self.playHead = playHeadProperty(for: player)
        self.duration = durationProperty(for: player)
        self.progress = Property(initial: 0.0,
                                 then: playHead.signal.combineLatest(with: duration.signal)
                                    .map({ (current, total) -> Float in
                                        Float(current.seconds / max(total.seconds, 1))
                                    }))

        try? AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
    }

    func toggle() {
        switch player.timeControlStatus {
        case .paused:
            player.play()
        case .playing:
            player.pause()
        case .waitingToPlayAtSpecifiedRate:
            break;
        }
    }
}

fileprivate func loadMedia(into player: AVPlayer) {
    if let url = Bundle.main.url(forResource: "bustin", withExtension: "mp3") {
        player.replaceCurrentItem(with: AVPlayerItem(url: url))
    } else {
        print("add a media item to the bundle")
    }
}

fileprivate func durationProperty(for player: AVPlayer) -> Property<CMTime> {
    return Property(initial: player.currentItem?.duration ?? kCMTimeZero,
                    then: player.reactive.values(forKeyPath: "currentItem.duration")
                        .map { ($0 as? CMTime) ?? kCMTimeZero })
}

fileprivate func playHeadProperty(for player: AVPlayer) -> Property<CMTime> {
    let oneSecond = CMTime(value: 1, timescale: 1)
    let (timeSignal, timeObserver) = Signal<CMTime, NoError>.pipe()
    player.addPeriodicTimeObserver(forInterval: oneSecond, queue: DispatchQueue.main) { time in
        timeObserver.send(value: time)
    }

    return Property(initial: player.currentTime(),
                    then: timeSignal)
}

fileprivate func statusProperty(for player: AVPlayer) -> Property<ViewModel.Status> {
    return Property(initial: .paused,
                    then: player.reactive.values(forKeyPath: "rate")
                        .map { rate in
                            let rate = (rate as? Float) ?? 0.0
                            return rate > 0.0 ? .playing : .paused
    })
}


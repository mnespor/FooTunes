//
//  CMTime+.swift
//  FooTunes
//
//  Created by Matthew Nespor on 1/28/17.
//  Copyright © 2017 Matthew Nespor. All rights reserved.
//

import AVFoundation
import Foundation

class TimeFormatter {
    fileprivate static let forMedia: DateFormatter = {
        var formatter = DateFormatter()
        formatter.timeZone = TimeZone(identifier: "UTC")
        formatter.dateFormat = "mm:ss"
        return formatter
    }()
}

extension CMTime {
    func format() -> String {
        let date = Date(timeIntervalSince1970: CMTimeGetSeconds(self))
        return TimeFormatter.forMedia.string(from: date)
    }
}

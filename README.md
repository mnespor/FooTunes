# FooTunes

ReactiveSwift is one of several functional reactive programming libraries available for iOS.

This small app uses ReactiveCocoa to make it easier to reason about AVPlayer. AVPlayer's API makes use of three different asynchrony patterns in Cocoa:
- NotificationCenter for AVPlayerItemDidPlayToEndTimeNotification, AVPlayerItemTimeJumpedNotification, and other infrequent events
- Key-value observing for playback rate and current item
- AVPlayer-specific, block-based observables for the player's time

ReactiveCocoa allows these all to be modeled the same way: as streams of values.
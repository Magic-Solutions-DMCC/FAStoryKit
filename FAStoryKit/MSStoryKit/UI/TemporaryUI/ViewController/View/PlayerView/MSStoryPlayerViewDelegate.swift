// Copyright (c) 2024 Magic Solutions. All rights reserved.

import Foundation

protocol MSStoryPlayerViewDelegate: AnyObject {
    func didStartPlaying(from url: URL)
    func didCompletePlay(from url: URL)
    func didTrack(from url: URL, progress: Float)
    func didFailed(withError error: String, for url: URL?)
}


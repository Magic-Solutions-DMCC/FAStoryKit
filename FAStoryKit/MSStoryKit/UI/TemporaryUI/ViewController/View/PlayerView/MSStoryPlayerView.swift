// Copyright (c) 2024 Magic Solutions. All rights reserved.

import AVFoundation
import UIKit

final class MSStoryPlayerView: UIView {

    // MARK: - Properties
    private var playerLayer: AVPlayerLayer?
    private var currentPlayerLayer: AVPlayerLayer?
    private var playerItemStatusObserver: NSKeyValueObservation?
    private var playerTimeControlStatusObserver: NSKeyValueObservation?
    private var playerTimeObserverToken: AnyObject?
    weak var delegate: MSStoryPlayerViewDelegate?
    private var currentURL: URL?

    // MARK: - Subviews

    // MARK: - Computed properies
    var playerStatus: PlayerStatus {
        guard let player else {
            return .unknown
        }
        switch player.status {
        case .unknown:
            return .unknown
        case .readyToPlay:
            return .readyToPlay
        case .failed:
            return .failed
        @unknown default:
            return .unknown
        }
    }

    // MARK: - Observable properties
    private var playerItem: AVPlayerItem? = nil {
        willSet {
            guard let playerItemStatusObserver else {
                return
            }
            playerItemStatusObserver.invalidate()
        }
        didSet {
            player?.replaceCurrentItem(with: playerItem)
            playerItemStatusObserver = playerItem?.observe(
                \AVPlayerItem.status,
                 options: [.new, .initial],
                 changeHandler: { [weak self] (item, _) in
                     guard let self = self else { return }
                     if item.status == .failed {
                         if let item = self.player?.currentItem, let error = item.error, let url = (item.asset as? AVURLAsset)?.url {
                             self.delegate?.didFailed(withError: error.localizedDescription, for: url)
                         } else {
                             self.delegate?.didFailed(withError: "Unknown error", for: nil)
                         }
                     }
                 }
            )
        }
    }

    var player: AVPlayer? {
        willSet {
            guard let playerTimeControlStatusObserver else {
                return
            }
            playerTimeControlStatusObserver.invalidate()
        }
        didSet {
            playerTimeControlStatusObserver = player?.observe(
                \AVPlayer.timeControlStatus,
                 options: [.new, .initial],
                 changeHandler: { [weak self] (player, _) in
                     guard let self = self else { return }
                     guard player.timeControlStatus == .playing,  let url = (player.currentItem?.asset as? AVURLAsset)?.url  else {
                         return
                     }
                     self.delegate?.didStartPlaying(from: url)
                 }
            )
        }
    }

    // MARK: - Init/Denit
    override init(frame: CGRect) {
        super.init(frame: frame)

        configure()
    }

    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        guard let player, player.observationInfo != nil else {
            return
        }
        removeObserver()
    }

    // MARK: - LifeCycle
    override func layoutSubviews() {
        super.layoutSubviews()

        playerLayer?.frame = bounds
    }

    // MARK: - Private methods
    private func configure() {
        backgroundColor = .black
    }

    private func unload() {
        playerLayer?.removeFromSuperlayer()
        playerLayer = nil
        player = nil
    }

    private func prepareVideo(_ videoURL: URL) {
        currentURL = videoURL
        let asset = AVAsset(url: videoURL)
        playerItem = AVPlayerItem(asset: asset)
        if let player {
            player.replaceCurrentItem(with: playerItem)
        } else {
            player = AVPlayer(playerItem: playerItem)
            player?.automaticallyWaitsToMinimizeStalling = false
            playerLayer = AVPlayerLayer(player: player)
        }

        guard
            let playerLayer = self.playerLayer,
            let playerItem = self.playerItem
        else { return }

        playerLayer.videoGravity = .resizeAspectFill
        playerItem.seek(to: .zero, completionHandler: nil)
        playerLayer.frame = bounds
        layer.addSublayer(playerLayer)
    }

    private func removeObserver() {
        guard let playerTimeObserverToken, let player else {
            return
        }
        player.removeTimeObserver(playerTimeObserverToken)
        self.playerTimeObserverToken = nil
    }

    private func setupObserver(_ videoURL: URL) {
        guard playerTimeObserverToken == nil else { return }

        playerTimeObserverToken = player?.addPeriodicTimeObserver(
            forInterval: CMTimeMake(value: 1, timescale: 100),
            queue: DispatchQueue.main
        ) { [weak self] time in
            let timeString = String(format: "%02.2f", CMTimeGetSeconds(time))
            if let currentItem = self?.player?.currentItem {
                let totalTimeString =  String(format: "%02.2f", CMTimeGetSeconds(currentItem.asset.duration))
                if timeString == totalTimeString {
                    self?.delegate?.didCompletePlay(from: videoURL)
                }
                let progress = time.seconds / currentItem.asset.duration.seconds
                self?.delegate?.didTrack(from: videoURL, progress: Float(progress))
            }

        } as AnyObject
    }

    // MARK: - Public methods
    func play(_ videoURL: URL) {
        prepareVideo(videoURL)
        setupObserver(videoURL)
        player?.play()
    }

    func playCurrent() {
        guard let player, let currentURL else {
            return
        }
        setupObserver(currentURL)
        player.play()
    }

    func pause() {
        removeObserver()
        guard let player else {
            return
        }
        player.pause()
    }

    func stop() {
        guard let player else {
            return
        }
        DispatchQueue.main.async { [weak self] in
            player.pause()

            if player.observationInfo != nil {
                self?.removeObserver()
            }
            self?.playerItem = nil
            self?.player = nil
            self?.playerLayer?.removeFromSuperlayer()
        }
    }
}

extension MSStoryPlayerView {

    enum PlayerStatus {
        case unknown
        case playing
        case failed
        case paused
        case readyToPlay
    }

}

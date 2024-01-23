// Copyright (c) 2024 Magic Solutions. All rights reserved.

import AVFoundation
import Combine
import SafariServices
import UIKit

final public class MSStoryViewController: UIViewController {

    // MARK: - Override properties
    public override var prefersStatusBarHidden: Bool {
        return false
    }

    public override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    public override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .fade
    }

    // MARK: - Properties
    public let storyIndex: Int
    public weak var delegate: FAStoryViewControllerDelegate?
    public var dismissInteractionController: SwipeInteractionController?
    private let viewModel: MSStoryViewModel
    private var subscription: AnyCancellable?

    // MARK: - Subviews
    private var contentView: UIView!
    private var containerView: UIView!
    private var headerView: UIView!
    private var imgViewPreview: UIImageView!
    private var btnDismiss: UIButton!
    private var lblTitle: FABadgeView!
    private var currentStoryIndicator: StoryIndicatorContainerView!
    private var imgView: UIImageView!
    private var longPressRecognizer: UILongPressGestureRecognizer!
    private var rightEdgeTap: UITapGestureRecognizer!
    private var leftEdgeTap: UITapGestureRecognizer!
    private var rightEdgeView: UIView!
    private var leftEdgeView: UIView!
    private var playerView: MSStoryPlayerView!
    private var activityView: UIActivityIndicatorView!
    private var lblError: UILabel!
    private var errorContainerView: UIView!
    private var externUrlView: ExternalLinkControllerView!
    private var safariVc: SFSafariViewController!
    private let headerGradientLayer = CAGradientLayer()
    private var overlayView: UIView!


    // MARK: - Init/Deinit
    public init(storyIndex: Int) {
        self.storyIndex = storyIndex
        self.viewModel = MSStoryViewModel(storyIndex: storyIndex)
        super.init(nibName: nil, bundle: nil)

    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: VC lifecycle
    public override func viewDidLoad() {
        super.viewDidLoad()

        _init()
        _configUI()
        binding()

        if navigationController == nil {
            dismissInteractionController = SwipeInteractionController(viewController: self)
        }
    }

    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        containerView.layoutIfNeeded()
        if let iv = imgViewPreview {
            iv.layer.cornerRadius = iv.frame.height / 2
        }
    }

    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        playerView.playCurrent()
    }

    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        playerView.pause()
    }

    public override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        playerView.stop()
    }

    private func _init() {
        view.backgroundColor = .clear

        // container view
        _containerView()

        // indicators
        _indicators()

        // contentView
        _contentView()

        // header
        _header()

        // gestureRecgonizer
        _configureGestures()

        view.bringSubviewToFront(containerView)
        view.bringSubviewToFront(leftEdgeView)
        view.bringSubviewToFront(rightEdgeView)
        headerView.sendSubviewToBack(overlayView)
        containerView.bringSubviewToFront(currentStoryIndicator)
    }

    public func start() {
        playerView.playCurrent()
    }

    public func pause() {
        playerView?.pause()
    }

    public func stop() {
        playerView?.stop()
    }

    private func binding() {
        subscription = viewModel.urlPublisher
            .sink(receiveCompletion: { [weak self] completion in
                guard case .failure = completion else {
                    return
                }
                self?._displayError()

            }, receiveValue: { [weak self] url in
                self?.errorContainerView?.isHidden = true
                self?.contentView.isHidden = false
                self?.imgView?.isHidden = true
                self?.playerView?.isHidden = false
                self?.playerView?.play(url)
            })
    }

    private func _configUI() {
        imgViewPreview.image = UIImage(named: viewModel.story.previewAssetID)
        lblTitle.title = viewModel.story.name

        currentStoryIndicator.setCount(viewModel.story.contents.count)

        imgView = UIImageView()
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.contentMode = (traitCollection.horizontalSizeClass == .regular && traitCollection.verticalSizeClass == .regular) ?  .scaleAspectFit :
            .scaleAspectFill
        imgView.isHidden = false

        contentView.addSubview(imgView)

        imgView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        imgView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        imgView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        imgView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true

        playerView = MSStoryPlayerView()
        playerView.delegate = self

        contentView.addSubview(playerView)

        playerView.layout.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    private func _containerView() {
        containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = .clear

        view.addSubview(containerView)

        containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        if #available(iOS 11, *) {
            containerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
            containerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        } else {
            containerView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor).isActive = true
            containerView.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor).isActive = true
        }
    }

    private func _contentView() {
        contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.backgroundColor = .black
        contentView.layer.cornerRadius = 8
        contentView.clipsToBounds = true
        contentView.layer.masksToBounds = true

        view.addSubview(contentView)

        if #available(iOS 11, *) {
            contentView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
            contentView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant:  -Constants.kContentBottomOffset).isActive = true
        } else {
            contentView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor).isActive = true
            contentView.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor, constant: -Constants.kContentBottomOffset).isActive = true
        }
        contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }

    private func _indicators() {
        currentStoryIndicator = StoryIndicatorContainerView()
        containerView.addSubview(currentStoryIndicator)
        currentStoryIndicator.heightAnchor.constraint(equalToConstant: 4).isActive = true
        currentStoryIndicator.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12).isActive = true
        currentStoryIndicator.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12).isActive = true
        currentStoryIndicator.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 15).isActive = true
    }

    /// Colors for the gradients
    private func _getColors() -> [CGColor] {
        return [UIColor.black.withAlphaComponent(0.5).cgColor, UIColor.clear.cgColor]
    }

    /// Gradient locations
    private func _getLocations() -> [CGFloat] {
        return [0.4,  0.9]
    }

    private func _header() {
        headerView = UIView()
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.backgroundColor = .clear

        containerView.addSubview(headerView)

        headerView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 15).isActive = true
        headerView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -15).isActive = true
        headerView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 30).isActive = true
        headerView.heightAnchor.constraint(equalToConstant: Constants.headerHeight).isActive = true

        imgViewPreview = UIImageView()
        imgViewPreview.translatesAutoresizingMaskIntoConstraints = false
        imgViewPreview.backgroundColor = .clear
        imgViewPreview.contentMode = .scaleAspectFill
        imgViewPreview.clipsToBounds = true
        imgViewPreview.layer.masksToBounds = true
        imgViewPreview.layer.borderColor = UIColor.white.cgColor
        imgViewPreview.layer.borderWidth = 2

        headerView.addSubview(imgViewPreview)

        imgViewPreview.topAnchor.constraint(equalTo: currentStoryIndicator.bottomAnchor, constant: 8).isActive = true
        imgViewPreview.leadingAnchor.constraint(equalTo: headerView.leadingAnchor).isActive = true
        imgViewPreview.widthAnchor.constraint(equalToConstant: 40).isActive = true
        imgViewPreview.heightAnchor.constraint(equalTo: imgViewPreview.widthAnchor).isActive = true

        // title label
        lblTitle = FABadgeView()
        lblTitle.translatesAutoresizingMaskIntoConstraints = false

        headerView.addSubview(lblTitle)

        lblTitle.leadingAnchor.constraint(equalTo: imgViewPreview.trailingAnchor, constant: 9).isActive = true
        lblTitle.centerYAnchor.constraint(equalTo: imgViewPreview.centerYAnchor).isActive = true

        // dismiss button
        btnDismiss = UIButton()
        btnDismiss.translatesAutoresizingMaskIntoConstraints = false
        btnDismiss.backgroundColor = .clear
        btnDismiss.tintColor = .white
        btnDismiss.contentMode = .scaleAspectFit
        btnDismiss.setImage(delegate?.dismissButtonImage(), for: .normal)

        headerView.addSubview(btnDismiss)

        btnDismiss.widthAnchor.constraint(equalToConstant: 40).isActive = true
        btnDismiss.heightAnchor.constraint(equalToConstant: 40).isActive = true
        btnDismiss.trailingAnchor.constraint(equalTo: headerView.trailingAnchor).isActive = true
        btnDismiss.centerYAnchor.constraint(equalTo: imgViewPreview.centerYAnchor).isActive = true
        btnDismiss.addTarget(self, action: #selector(_dismiss), for: .touchUpInside)

        overlayView = UIView()
        overlayView.translatesAutoresizingMaskIntoConstraints = false
        overlayView.backgroundColor = .clear

        headerView.addSubview(overlayView)

        overlayView.leadingAnchor.constraint(equalTo: headerView.leadingAnchor).isActive = true
        overlayView.trailingAnchor.constraint(equalTo: headerView.trailingAnchor).isActive = true
        overlayView.topAnchor.constraint(equalTo: headerView.topAnchor).isActive = true
        overlayView.bottomAnchor.constraint(equalTo: headerView.bottomAnchor).isActive = true
    }

    private func _configureGestures() {
        longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(_longPress(_:)))
        longPressRecognizer.minimumPressDuration = 0.2
        view.addGestureRecognizer(longPressRecognizer)

        rightEdgeTap = UITapGestureRecognizer(target: self, action: #selector(_nextTap(_:)))
        rightEdgeTap.delegate = self
        rightEdgeView = _createEdgeView(rigtEdge: true)
        rightEdgeView.addGestureRecognizer(rightEdgeTap)

        leftEdgeTap = UITapGestureRecognizer(target: self, action: #selector(_prevTap(_:)))
        leftEdgeTap.delegate = self
        leftEdgeView = _createEdgeView(rigtEdge: false)
        leftEdgeView.addGestureRecognizer(leftEdgeTap)
    }

    private func _createEdgeView(rigtEdge: Bool) -> UIView {
        let _view = UIView()
        _view.backgroundColor = .clear
        _view.translatesAutoresizingMaskIntoConstraints = false

        containerView.insertSubview(_view, at: 0)

        _view.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.4).isActive = true
        _view.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        _view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true

        if rigtEdge {
            _view.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        } else {
            _view.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        }

        return _view
    }

    private func _externUrlView(url: URL?) {
        guard let _url = url else {
            externUrlView?.removeFromSuperview()
            if externUrlView != nil {
                externUrlView = nil
            }
            return
        }

        if externUrlView == nil {
            externUrlView = ExternalLinkControllerView(with: _url)
            externUrlView.title = "More"
            externUrlView.color = .white
            externUrlView.font = UIFont(name: "Brown-Regular", size: 14)
            externUrlView.delegate = self

            containerView.addSubview(externUrlView)
            containerView.bringSubviewToFront(externUrlView)

            externUrlView.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
            externUrlView.heightAnchor.constraint(equalToConstant: Constants.kContentBottomOffset).isActive = true
            externUrlView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true

            if #available(iOS 11, *) {
                externUrlView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
            } else {
                externUrlView.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor).isActive = true
            }
        } else {
            externUrlView.replaceUrl(_url)
        }

    }

    @objc
    private func _longPress(_ sender: UILongPressGestureRecognizer) {
        switch sender.state {
        case .began, .changed:
            UIView.animate(withDuration: 0.2) {
                self.containerView.alpha = 0
            }
            playerView?.pause()
        default:
            UIView.animate(withDuration: 0.2) {
                self.containerView.alpha = 1
            }
            playerView?.playCurrent()
        }
    }

    @objc
    private func _nextTap(_ sender: UITapGestureRecognizer) {
        showNext()
    }

    @objc
    private func _prevTap(_ sender: UITapGestureRecognizer) {
        showPrevious()
    }

    @objc
    private func _dismiss() {
        if let _presenting = presentingViewController {
            _presenting.dismiss(animated: true)
        } else {
            dismiss(animated: true)
        }
    }

    private func _displayError() {
        errorContainerView?.removeFromSuperview()
        errorContainerView = UIView()
        errorContainerView.translatesAutoresizingMaskIntoConstraints = false
        errorContainerView.backgroundColor = .black

        view.addSubview(errorContainerView)

        errorContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        errorContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        errorContainerView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        errorContainerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true

        view.insertSubview(errorContainerView, belowSubview: containerView)

        lblError?.removeFromSuperview()
        lblError = UILabel()
        lblError.backgroundColor = .clear
        lblError.alpha = 0
        lblError.translatesAutoresizingMaskIntoConstraints = false
        lblError.numberOfLines = 0
        lblError.font = UIFont.systemFont(ofSize: 16)
        lblError.textColor = .white
        lblError.text = "This content is not available now. Please try again later"
        lblError.textAlignment = .center


        errorContainerView.addSubview(lblError)

        lblError.widthAnchor.constraint(equalTo: errorContainerView.widthAnchor, multiplier: 0.8).isActive = true
        lblError.centerXAnchor.constraint(equalTo: errorContainerView.centerXAnchor).isActive = true
        lblError.centerYAnchor.constraint(equalTo: errorContainerView.centerYAnchor).isActive = true
        lblError.heightAnchor.constraint(lessThanOrEqualTo: errorContainerView.heightAnchor, multiplier: 0.5).isActive = true

        view.layoutIfNeeded()

        contentView.isHidden = true

        UIView.animate(withDuration: 0.2) { [weak self] in
            guard let self = self else {return}
            self.lblError.alpha = 1
        }
    }

    /// Show the activity view
    private func displayActivity() {
        activityView?.removeFromSuperview()
        activityView = UIActivityIndicatorView(style: .whiteLarge)
        activityView.translatesAutoresizingMaskIntoConstraints = false
        contentView.insertSubview(activityView, at: 0)
        activityView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        activityView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        activityView.startAnimating()
    }

    private func hideActivity() {
        activityView?.stopAnimating()
        activityView?.removeFromSuperview()
    }

    private func showNext() {
        playerView.pause()
        if viewModel.shouldShowNext() {
            viewModel.showNext()
            _ = currentStoryIndicator.next()
        } else if let containerVC = parent as? MSStoryContainerViewController, containerVC.canShowNext {
            containerVC.jumpForward()
        }
    }

    private func showPrevious() {
        playerView.pause()
        if viewModel.shouldShowPrevious() {
            viewModel.showPrevious()
            _ = currentStoryIndicator.previous()
        } else if let containerVC = parent as? MSStoryContainerViewController, containerVC.canShowPrevious {
            containerVC.jumpBackward()
        }
    }

}

// MARK: - ExternalLinkControllerDelegate
extension MSStoryViewController: ExternalLinkControllerDelegate, SFSafariViewControllerDelegate {

    func openLink(_ url: URL) {
        safariVc = SFSafariViewController(url: url)
        safariVc.delegate = self
        playerView.pause()
        present(safariVc, animated: true)
    }

    public func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        playerView.playCurrent()
    }
}


// MARK: - UIGestureRecognizerDelegate
extension MSStoryViewController: UIGestureRecognizerDelegate {

    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {

        if gestureRecognizer === rightEdgeTap {
            return !btnDismiss.frame.contains(gestureRecognizer.location(in: headerView))
        }
        return true
    }

}

extension MSStoryViewController: MSStoryPlayerViewDelegate {

    func didStartPlaying(from url: URL) {
        hideActivity()
    }
    
    func didCompletePlay(from url: URL) {
        showNext()
    }

    func didTrack(from url: URL, progress: Float) {
        print("progress", progress)
        currentStoryIndicator?.setProgress(CGFloat(progress))
    }
    
    func didFailed(withError error: String, for url: URL?) {
        _displayError()
    }

}

extension MSStoryViewController: SwipeDismissInteractible {

    public var gestureView: UIView {
        return view
    }

}

private enum Constants {
    static let headerHeight: CGFloat = 40
    static let kContentBottomOffset: CGFloat = 60
}

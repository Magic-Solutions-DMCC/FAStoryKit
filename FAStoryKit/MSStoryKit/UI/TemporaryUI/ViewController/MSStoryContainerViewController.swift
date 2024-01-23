// Copyright (c) 2024 Magic Solutions. All rights reserved.

import UIKit

public class MSStoryContainerViewController: UINavigationController, SwipeDismissInteractibleNavigationController {

    public var gestureView: UIView {
        return view
    }

    public var canShowNext: Bool {
        return viewControllerStack.viewController(forKey: .next) != nil
    }

    public var canShowPrevious: Bool {
        return viewControllerStack.viewController(forKey: .prev) != nil
    }

    public var dismissInteractionController: SwipeInteractionController?
    internal var presentationDirection: TransitionDirection = .left
    internal var transitionGestureRecognizer: UIPanGestureRecognizer!
    internal var _isPushing = false
    internal var oldPanPoint: CGPoint = .zero
    private var panCalculator = TouchProgressCalculator(origin: .zero)
    private var transitionDecided = false
    private var dismissDecided = false
    private var gestureBegan = false
    private var viewControllerStack = MSStoryVcStack()


    public init(storyController vc: MSStoryViewController) {
        viewControllerStack.set(currentViewController: vc)
        super.init(rootViewController: vc)
    }

    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        viewControllerStack.clear()
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBarHidden(true, animated: false)
        addCustomTransitioning()
        dismissInteractionController = SwipeInteractionController(navigationController: self)
    }

    public func jumpForward() {
        guard let next = viewControllerStack.viewController(forKey: .next),
            let current = viewControllerStack.viewController(forKey: .current) else { return }

        current.pause()

        presentationDirection = .left
        transitionCoordinatorHelper?.presentationDirection = presentationDirection
        pushViewController(next, animated: true)
        viewControllerStack.set(currentViewController: next)
    }

    public func jumpBackward() {
        guard let prev = viewControllerStack.viewController(forKey: .prev),
            let current = viewControllerStack.viewController(forKey: .current) else { return }

        current.pause()

        presentationDirection = .right
        transitionCoordinatorHelper?.presentationDirection = presentationDirection
        pushViewController(prev, animated: true)
        viewControllerStack.set(currentViewController: prev)
    }

    public func gestureToBeFailedByDismiss(gesture: UIGestureRecognizer) -> UIGestureRecognizer? {
        return transitionGestureRecognizer
    }

    public func gestureToUse() -> UIPanGestureRecognizer? {
        return transitionGestureRecognizer
    }

    @objc
    internal func _handleTransition(_ gestureRecognizer: UIPanGestureRecognizer) {
        let location = gestureRecognizer.translation(in: view)

        switch gestureRecognizer.state {
        case .began:
            transitionDecided = false
            dismissDecided = false
            let origin = location
            panCalculator = TouchProgressCalculator(origin: origin)
            gestureBegan = true

        case .changed:
            if !transitionDecided && !dismissDecided {
                decideAction(panCalculator.getAngleToOrigin(location).toDegrees)
            } else if transitionDecided {
                presentationDirection = location.x >= panCalculator.origin.x ? .right : .left
                handleSwipeTransition(gestureRecognizer, isBegun: gestureBegan)
                gestureBegan = false
            } else if dismissDecided {
                dismissInteractionController?.handleGesture(gestureRecognizer, isBegun: gestureBegan)
                gestureBegan = false
            }

        case .ended:
            if transitionDecided {
                handleSwipeTransition(gestureRecognizer, isBegun: false)
            } else if dismissDecided {
                dismissInteractionController?.handleGesture(gestureRecognizer, isBegun: false)
            }

            transitionDecided = false
            dismissDecided = false

        default:
            break
        }

    }


    private func decideAction(_ angle: Double) {
        if angle >= -45 && angle <= 45 {
            dismissDecided = true
        } else {
            transitionDecided = true
        }
    }

    public override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
        guard !viewControllers.contains(viewControllerToPresent) else { return }
        super.present(viewControllerToPresent, animated: flag, completion: completion)
    }

    public override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        guard !viewControllers.contains(viewController) else { return }
        super.pushViewController(viewController, animated: animated)
    }

}

// MARK: - UIGestureRecognizerDelegate
extension MSStoryContainerViewController: UIGestureRecognizerDelegate {

    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return otherGestureRecognizer is UISwipeGestureRecognizer
    }

    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer === transitionGestureRecognizer {
            return !(transitionCoordinatorHelper?.isPushing ?? false)
        } else {
            return true
        }
    }

    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return !(otherGestureRecognizer is UISwipeGestureRecognizer)
    }
}


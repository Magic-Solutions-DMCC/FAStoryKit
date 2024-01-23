// Copyright (c) 2024 Magic Solutions. All rights reserved.

import UIKit

internal extension MSStoryContainerViewController {

    static private var coordinatorHelperKey = "UINavigationController.TransitionCoordinatorHelper"

    var transitionCoordinatorHelper: TransitionCoordinator? {
        guard let coordinator =  objc_getAssociatedObject(self, &MSStoryContainerViewController.coordinatorHelperKey) as? TransitionCoordinator else {return nil}

        coordinator.presentationDirection = presentationDirection

        return coordinator
    }

    func addCustomTransitioning() {

        var object = objc_getAssociatedObject(self, &MSStoryContainerViewController.coordinatorHelperKey)

        guard object == nil else {
            return
        }

        object = TransitionCoordinator()
        let nonatomic = objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC
        objc_setAssociatedObject(self, &MSStoryContainerViewController.coordinatorHelperKey, object, nonatomic)


        delegate = object as? TransitionCoordinator


        let swipeGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(_handleTransition(_:)))
        transitionGestureRecognizer = swipeGestureRecognizer
        transitionGestureRecognizer.delegate = self
        view.addGestureRecognizer(transitionGestureRecognizer)
    }


    @objc func handleSwipeTransition(_ gestureRecognizer: UIPanGestureRecognizer, isBegun: Bool) {
        guard let gestureRecognizerView = gestureRecognizer.view else {
            transitionCoordinatorHelper?.interactionController = nil
            return
        }

        let location = gestureRecognizer.translation(in: gestureRecognizerView)

        let percent = abs(location.x) / gestureRecognizerView.bounds.size.width

        let direction = transitionCoordinatorHelper?.presentationDirection

        if isBegun && gestureRecognizer.state != .began {
            transitionCoordinatorHelper?.interactionController = UIPercentDrivenInteractiveTransition()

            switch direction {
            case .left:
                jumpForward()
            case .right:
                jumpBackward()

            default:
                break
            }
        }

        if gestureRecognizer.state == .began {
            transitionCoordinatorHelper?.interactionController = UIPercentDrivenInteractiveTransition()

            switch direction {
            case .left:
                jumpForward()
            case .right:
                jumpBackward()

            default:
                break
            }

        } else if gestureRecognizer.state == .changed {
            transitionCoordinatorHelper?.interactionController?.update(percent)
        } else if gestureRecognizer.state == .ended {
            if percent > 0.4 || ((oldPanPoint.x) <= (location.x)) {
                transitionCoordinatorHelper?.interactionController?.finish()
            } else {
                transitionCoordinatorHelper?.interactionController?.cancel()
                if let c = transitionCoordinatorHelper {
                    c.isPushing = false
                }
            }
            transitionCoordinatorHelper?.interactionController = nil
        }

        oldPanPoint = location
    }
}

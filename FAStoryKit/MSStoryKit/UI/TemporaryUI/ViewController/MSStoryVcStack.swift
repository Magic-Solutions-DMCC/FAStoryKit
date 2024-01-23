// Copyright (c) 2024 Magic Solutions. All rights reserved.

import Foundation

public class MSStoryVcStack  {

    private var nextVc: MSStoryViewController?
    private var currentVc: MSStoryViewController?
    private var previousVc: MSStoryViewController?

    public func set(currentViewController vc: MSStoryViewController) {
        let idx = vc.storyIndex

        @MSRepositoryDependency var storyRepository: MSStoryRepository
        let max = storyRepository.stories.value.stories.endIndex - 1

        previousVc = nil
        nextVc = nil

        // set the currentVc
        currentVc = vc

        // set the previousVc
        if idx > 0 {
            previousVc = MSStoryViewController(storyIndex: idx - 1)
            previousVc?.delegate = vc.delegate
        }

        // set the next vc
        if idx < max {
            nextVc = MSStoryViewController(storyIndex: idx + 1)
            nextVc?.delegate = vc.delegate
        }

    }

    /// Returns the viewController related with the requested key
    /// - Parameter key: Key for the request
    public func viewController(forKey key: StackVcKeys) -> MSStoryViewController?  {
        switch key {
        case .current:
            return currentVc
        case .next:
            return nextVc
        case .prev:
            return previousVc
        default:
            return nil
        }
    }

    internal func clear() {
        print("MSStoryVcStack clear")
        previousVc = nil
        currentVc = nil
        nextVc = nil
    }
}

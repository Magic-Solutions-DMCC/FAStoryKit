// Copyright (c) 2024 Magic Solutions. All rights reserved.

import Combine
import Foundation
import UIKit

final class MSStoryViewModel {

    private let storyIndex: Int
    private var storyContentIndex: Int
    private let urlSubject = PassthroughSubject<URL, MSStoryError>()
    @Published private(set) var url: URL?
    private var subscription: AnyCancellable?

    var urlPublisher: AnyPublisher<URL, MSStoryError> {
        urlSubject.eraseToAnyPublisher()
    }

    private(set) lazy var story: MSStory = {
        return provider.fetchStory(storyIndex)
    }()

    @MSProviderDependency private var provider: MSStoryProviderProtocol

    init(storyIndex: Int) {
        self.storyIndex = storyIndex
        self.storyContentIndex = 0
        self.fetchStoryContent()
    }

    func shouldShowNext() -> Bool {
        let max = story.contents.endIndex - 1

        if storyContentIndex < max {
            return true
        }

        return false
    }

    func shouldShowPrevious() -> Bool {
        if storyContentIndex > 0 {
            return true
        }
        return false
    }

    func showNext() {
        let max = story.contents.endIndex - 1

        if storyContentIndex < max {
            storyContentIndex += 1
            fetchStoryContent()
        }
    }

    func showPrevious() {
        if storyContentIndex > 0 {
            storyContentIndex -= 1
            fetchStoryContent()
        }
    }

    private func fetchStoryContent() {
        subscription = provider.prepareStoryContent(story, contentIndex: storyContentIndex)
            .receive(on: DispatchQueue.main)
            .subscribe(urlSubject)
    }
}

// Copyright (c) 2024 Magic Solutions. All rights reserved.

import Combine
import Foundation

protocol MSStoryProviderProtocol {

    func prepareStoryContent(_ story: MSStory, contentIndex: Int) -> AnyPublisher<URL, MSStoryError>

    func fetchStory(_ storyIndex: Int) -> MSStory
}


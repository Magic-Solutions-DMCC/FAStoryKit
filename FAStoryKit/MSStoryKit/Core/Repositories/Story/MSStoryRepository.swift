// Copyright (c) 2023 Magic Solutions. All rights reserved.

import Combine
import Foundation

final class MSStoryRepository {

    // MARK: - Static properties
    static let shared = MSStoryRepository()

    // MARK: - Properties
    var stories = CurrentValueSubject<MSStories, Never>(MSStories(stories: []))
}

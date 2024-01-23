// Copyright (c) 2024 Magic Solutions. All rights reserved.

import UIKit
import Foundation

class MSPreviewStoryViewModel {

    @MSRepositoryDependency private var storyRepository: MSStoryRepository

    private var stories: [MSStory] {
        return storyRepository.stories.value.stories
    }

    func numberOfStories() -> Int {
        return stories.count
    }

    func previewImage(for indexPath: IndexPath) -> UIImage {
        let previewAssetName = stories[indexPath.row].previewAssetID
       return UIImage(named: previewAssetName) ?? UIImage()
    }

    /// did select
    func didSelect(row: Int) {
        
    }

}

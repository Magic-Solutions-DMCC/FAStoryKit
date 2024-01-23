// Copyright (c) 2024 Magic Solutions. All rights reserved.

import Combine
import Foundation

class MSStoryProvider {

    @MSServiceDependency private var downloadService: MSDownloadServiceProtocol
    @MSServiceDependency private var cacheService: MSCacheStoryServiceProtocol
    @MSServiceDependency private var projectFileService: MSProjectFileServiceProtocol
    @MSRepositoryDependency private var storyRepository: MSStoryRepository

    func downloadStoryContent(content: MSStoryContent, storyName: String) -> AnyPublisher<URL, DecodingError> {
        if let cacheURL = self.cacheService.fileInCache(
            folderName: storyName,
            filename: content.fileName,
            fileformat: content.fileFormat
        ) {
            return Just(cacheURL)
                .setFailureType(to: DecodingError.self)
                .eraseToAnyPublisher()
        } else {
            return downloadService.downloadFile(from: content.externalURL)
                .mapError { _ in DecodingError.decodingFailed }
                .flatMap { [unowned self] temporaryURL in
                    let item = MSCacheFileItem(
                        folderName: storyName,
                        fileFormat: content.fileFormat,
                        fileName: content.fileName,
                        temporaryURL: temporaryURL
                    )
                    return self.cacheService.save(item: item)
                }
                .eraseToAnyPublisher()
        }
    }
}


extension MSStoryProvider: MSStoryProviderProtocol {

    func prepareStoryContent(_ story: MSStory, contentIndex: Int) -> AnyPublisher<URL, MSStoryError> {
        let content = story.contents[contentIndex]
        return downloadStoryContent(content: content, storyName: story.name)
            .mapError { _ in MSStoryError.failedDownload }
            .eraseToAnyPublisher()

    }

    func fetchStory(_ storyIndex: Int) -> MSStory {
        return storyRepository.stories.value.stories[storyIndex]
    }
}


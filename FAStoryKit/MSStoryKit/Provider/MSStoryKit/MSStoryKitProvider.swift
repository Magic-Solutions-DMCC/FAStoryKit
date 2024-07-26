// Copyright (c) 2024 Magic Solutions. All rights reserved.

import Combine
import Foundation

class MSStoryKitProvider {

    @MSServiceDependency private var downloadService: MSDownloadServiceProtocol
    @MSServiceDependency private var cacheService: MSCacheStoryServiceProtocol
    @MSServiceDependency private var projectFileService: MSProjectFileServiceProtocol
    @MSRepositoryDependency private var storyRepository: MSStoryRepository
    private let decoder = JSONDecoder() 
    private var cancellables = Set<AnyCancellable>()


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

        func downloadStories(_ stories: MSStories) -> AnyPublisher<Void, Never> {
            let storiesContent = stories.stories.flatMap { story in
                return story.contents.compactMap { content in
                    return (content, story.name)
                }
            }
            return Publishers.Sequence(sequence: storiesContent.map { downloadStoryContent(content: $0.0, storyName: $0.1) })
                   .flatMap(maxPublishers: .max(6)) { $0 }
                   .map { _ in }
                   .replaceError(with: ())
                   .eraseToAnyPublisher()
    }

    private func preloadStories(_ stories: MSStories) {
        downloadStories(stories)
            .sink(receiveValue: { _ in })
            .store(in: &cancellables)
    }

}

extension MSStoryKitProvider: MSStoryKitProviderProtocol {

    func prepareStories(storiesJSONFileName: String, shouldPreload: Bool) {
        projectFileService.extractData(from: storiesJSONFileName, type: .json)
            .mapError({ _ in DecodingError.decodingFailed })
            .decode(to: MSStories.self, with: decoder)
            .replaceError(with: MSStories(stories: []))
            .handleEvents(receiveOutput: { [weak self] stories in
                guard let self, shouldPreload else {
                    return
                }
                self.preloadStories(stories)
            })
            .sink(receiveValue: { [unowned self] in
                self.storyRepository.stories.value = $0
            })
            .store(in: &cancellables)
    }

}

// Copyright (c) 2024 Magic Solutions. All rights reserved.

import Combine
import Foundation

class MSCacheStoryService {

    private var cacheDirectoryURL: URL?

    init() {
        self.cacheDirectoryURL = nil
        cacheDirectoryURL = createCacheDirectoryURL()
    }

    func createCacheDirectoryURL() -> URL? {
        guard
            let directoryURL = try?  FileManager.default
                .url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                .appendingPathComponent(Constants.caches)
                .appendingPathComponent(Constants.stories)
        else { return nil }

        return createDirectory(directoryURL)
    }

    func createFolderDirectoryURLIfNeeded(folderName: String) -> URL? {
        guard let cacheDirectoryURL = cacheDirectoryURL else {
            return nil
        }
        let folderDirectoryURL = cacheDirectoryURL.appendingPathComponent(folderName)
        return createDirectory(folderDirectoryURL)
    }

    func createDirectory(_ directoryURL: URL) -> URL? {
        let manager = FileManager.default

        guard !manager.fileExists(atPath: directoryURL.path) else {
            return directoryURL
        }

        do {
            try manager.createDirectory (at: directoryURL, withIntermediateDirectories: true, attributes: nil)
            return directoryURL
        }
        catch {
            print("Error: Unable to create directory: \(error)")
            return nil
        }
    }

    func save(item: MSCacheFileItem) -> AnyPublisher<URL, DecodingError> {
        return Future<URL, DecodingError> { [unowned self] resolve in
            guard let folderDirectoryURL = createFolderDirectoryURLIfNeeded(folderName: item.folderName) else {
                        return resolve(.failure(.decodingFailed))
                    }
            
                    do {
                        let destinationURL = folderDirectoryURL
                            .appendingPathComponent(item.fileName)
                            .appendingPathExtension(item.fileFormat.rawValue)

                        try? FileManager.default.removeItem(at: destinationURL)
                        try FileManager.default.moveItem(at: item.temporaryURL, to: destinationURL)
                        return resolve(.success(destinationURL))
                    } catch {
                        print(error)
                        return resolve(.failure(.decodingFailed))
                    }
            }
        .eraseToAnyPublisher()
    }

    func fileInCache(folderName: String, filename: String, fileformat: MSSFileFormat) -> URL? {

        guard let folderDirectoryURL = createFolderDirectoryURLIfNeeded(folderName: folderName) else {
            return nil
        }
        let fileURL = folderDirectoryURL
            .appendingPathComponent(filename)
            .appendingPathExtension(fileformat.rawValue)

        guard FileManager.default.fileExists(atPath: fileURL.path) else {
            return nil
        }

        return fileURL
    }

}

extension MSCacheStoryService: MSCacheStoryServiceProtocol {

}

private enum Constants {
    static let stories = "Stories"
    static let caches = "Caches"
}

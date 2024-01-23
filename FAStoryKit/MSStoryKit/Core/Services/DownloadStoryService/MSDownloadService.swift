// Copyright (c) 2024 Magic Solutions. All rights reserved.

import Combine
import Foundation

class MSDownloadService: NSObject {

    func downloadFile(from url: URL) -> AnyPublisher<URL, URLError> {
        URLSession.shared.downloadTaskPublisher(for: url)
            .compactMap { $0.location }
            .eraseToAnyPublisher()
    }
}



extension MSDownloadService: MSDownloadServiceProtocol { }

// Copyright (c) 2024 Magic Solutions. All rights reserved.

import Combine
import Foundation

protocol MSDownloadServiceProtocol { 

    /// Meтод для загрузки файла
    /// - Parameters url: Адрес для загрузки файла
    /// - Returns Паблишер с временным адресом файла
    func downloadFile(from url: URL) -> AnyPublisher<URL, URLError>
}

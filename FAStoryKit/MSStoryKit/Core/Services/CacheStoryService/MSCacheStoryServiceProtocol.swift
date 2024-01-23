// Copyright (c) 2024 Magic Solutions. All rights reserved.

import Combine
import Foundation

protocol MSCacheStoryServiceProtocol { 

    /// Метод для проверки сущетсвует ли файл в кэше
    func fileInCache(folderName: String, filename: String, fileformat: MSSFileFormat) -> URL? 

    /// Метод для для сохранения файла в кэш
    func save(item: MSCacheFileItem) -> AnyPublisher<URL, DecodingError>
}

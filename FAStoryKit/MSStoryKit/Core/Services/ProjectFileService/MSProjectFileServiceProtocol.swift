// Copyright (c) 2024 Magic Solutions. All rights reserved.

import Combine
import Foundation

protocol MSProjectFileServiceProtocol {

     /// Метод для извлечения данные из файла в проекте
     /// - Parameters fileName: Имя фалф
     /// - Parameters fileType: Тип файла
     /// - Returns: В случае успеха Data, NetworkError в случае ошибки
    func extractData(
        from fileName: String,
        type: MSProjectFileExtensionType
    ) -> AnyPublisher<Data, MSExtractFileError>
}

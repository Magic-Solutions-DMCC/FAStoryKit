// Copyright (c) 2024 Magic Solutions. All rights reserved.

import Combine
import Foundation

final class MSProjectFileService { }

// MARK: - ProjectFileServiceProtocol
extension MSProjectFileService: MSProjectFileServiceProtocol {

    func extractData(from fileName: String, type: MSProjectFileExtensionType) -> AnyPublisher<Data, MSExtractFileError> {
        return Future<Data, MSExtractFileError> { resolve in
            guard let path = Bundle.main.path(forResource: fileName, ofType: type.rawValue) else {
                return resolve(.failure(.invalidURL))
            }
            do {
                let url = URL(fileURLWithPath: path)
                let data = try Data(contentsOf: url)
                resolve(.success(data))
            } catch {
                return resolve(.failure(.decodingFailed))
            }
        }
        .eraseToAnyPublisher()
    }

}

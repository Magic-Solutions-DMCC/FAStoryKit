// Copyright (c) 2024 Magic Solutions. All rights reserved.

import Combine
import Foundation

extension Publisher {

    /**
     Convert Data to Decodable type models
     - type: - Type of Decodable model
     - jsonDecoder: - Decoder for JSON
     */
    func decode<Output: Decodable>(
        to type: Output.Type,
        with jsonDecoder: JSONDecoder = JSONDecoder()
    ) -> AnyPublisher<Output, Failure> where Self.Output == Data, Failure == DecodingError {
        flatMap { result -> AnyPublisher<Output, Failure> in
            do {
                return Just(try jsonDecoder.decode(Output.self, from: result))
                    .setFailureType(to: Failure.self)
                    .eraseToAnyPublisher()
            } catch {
                return Fail(error: .decodingFailed)
                    .eraseToAnyPublisher()
            }
        }
        .eraseToAnyPublisher()
    }

}

enum DecodingError: Error {
    case decodingFailed
}

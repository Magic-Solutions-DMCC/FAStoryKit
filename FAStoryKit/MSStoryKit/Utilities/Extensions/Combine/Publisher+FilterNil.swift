// Copyright (c) 2024 Magic Solutions. All rights reserved.

import Combine

extension Publisher where Self.Output: OptionalType {

    func filterNil() -> AnyPublisher<Self.Output.Wrapped, Self.Failure> {
        return flatMap { element -> AnyPublisher<Self.Output.Wrapped, Self.Failure> in
            guard let value = element.value else {
                return Empty(completeImmediately: false)
                    .setFailureType(to: Self.Failure.self)
                    .eraseToAnyPublisher()
            }
            return Just(value)
                .setFailureType(to: Self.Failure.self)
                .eraseToAnyPublisher()
        }
        .eraseToAnyPublisher()
    }

}

// MARK: - OptionalType
public protocol OptionalType {
    associatedtype Wrapped
    var value: Wrapped? { get }
}

extension Optional: OptionalType {
    public var value: Wrapped? { self }
}

// Copyright (c) 2024 Magic Solutions. All rights reserved.

import Foundation

final class MSAnyServiceFactory {

    // MARK: - Properties
    private let wrappedResolve: (MSResolver) -> Any
    private let wrappedSupports: (Any.Type) -> Bool

    // MARK: - Init/Deinit
    init<T: MSServiceFactory>(_ factory: T) {
        wrappedResolve = { factory.resolve(from: $0) }
        wrappedSupports = { $0 == T.Service.self }
    }

    // MARK: - Public methods
    func resolve<Service>(from resolver: MSResolver) -> Service {
        guard let type = wrappedResolve(resolver) as? Service else {
            fatalError("resolver resolved to the wrong type")
        }
        return type
    }

    func supports<ServiceType>(_ type: ServiceType.Type) -> Bool {
        wrappedSupports(type)
    }

}

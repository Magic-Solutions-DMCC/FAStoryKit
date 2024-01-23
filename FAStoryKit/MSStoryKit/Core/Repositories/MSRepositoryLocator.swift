// Copyright (c) 2024 Magic Solutions. All rights reserved.

import Foundation

enum MSRepositoryLocator: MSServiceLocatorProtocol {

    // MARK: - Properties
    private static let locator: MSResolver = makeLocator()

    // MARK: - Public methods
    static func resolve<Service>(_ type: Service.Type) -> Service {
        locator.resolve(type)
    }

}

private extension MSRepositoryLocator {

    static func makeLocator() -> MSResolver {
        guard NSClassFromString("Dummy") == nil else {
            return MSServiceResolver()
        }
        return MSServiceResolver()
            .register(MSStoryRepository.self) { _ in MSStoryRepository.shared }
    }

}

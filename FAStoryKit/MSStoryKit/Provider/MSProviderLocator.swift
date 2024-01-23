// Copyright (c) 2024 Magic Solutions. All rights reserved.

import Foundation

public enum MSProviderLocator: MSServiceLocatorProtocol {

    // MARK: - Properties
    private static let locator: MSResolver = makeLocator()

    // MARK: - Public methods
    public static func resolve<Service>(_ type: Service.Type) -> Service {
        locator.resolve(type)
    }

}

private extension MSProviderLocator {

    static func makeLocator() -> MSResolver {
        guard NSClassFromString("Dummy") == nil else {
            return MSServiceResolver()
        }
        return MSServiceResolver()
            .register(MSStoryKitProviderProtocol.self) { _ in MSStoryKitProvider() }
            .register(MSStoryProviderProtocol.self) { _ in MSStoryProvider() }
    }

}

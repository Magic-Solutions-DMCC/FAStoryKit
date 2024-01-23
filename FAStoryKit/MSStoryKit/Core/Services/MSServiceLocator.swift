// Copyright (c) 2024 Magic Solutions. All rights reserved.

import Foundation

public enum MSServiceLocator: MSServiceLocatorProtocol {

    // MARK: - Properties
    private static let locator: MSResolver = makeLocator()

    // MARK: - Static func
    public static func resolve<Service>(_ type: Service.Type) -> Service {
        locator.resolve(type)
    }

}

private extension MSServiceLocator {

    static func makeLocator() -> MSResolver {
        guard NSClassFromString("Dummy") == nil else {
            return MSServiceResolver()
        }
        return MSServiceResolver()
            .register(MSDownloadServiceProtocol.self) { _ in MSDownloadService() }
            .register(MSProjectFileServiceProtocol.self) { _ in MSProjectFileService() }
            .register(MSCacheStoryServiceProtocol.self) { _ in MSCacheStoryService() }
    }

}

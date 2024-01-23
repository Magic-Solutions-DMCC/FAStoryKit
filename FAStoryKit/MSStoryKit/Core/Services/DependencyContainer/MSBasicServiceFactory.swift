// Copyright (c) 2024 Magic Solutions. All rights reserved.

import Foundation

struct MSBasicServiceFactory<Service> {

    // MARK: - Properties
    private let factory: (MSResolver) -> Service

    // MARK: - Init/Deinit
    init(_: Service.Type, factory: @escaping (MSResolver) -> Service) {
        self.factory = factory
    }

}

// MARK: - ServiceFactory
extension MSBasicServiceFactory: MSServiceFactory {

    func resolve(from resolver: MSResolver) -> Service {
        factory(resolver)
    }
}

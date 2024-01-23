// Copyright (c) 2024 Magic Solutions. All rights reserved.

import Foundation

public struct MSServiceResolver {

    // MARK: - Properties
    private let factories: [MSAnyServiceFactory]

    // MARK: - Init/Deinit
    public init() {
        factories = []
    }

    private init(factories: [MSAnyServiceFactory]) {
        self.factories = factories
    }

    // MARK: Register
    public func register<T>(_ interface: T.Type, instance: T) -> Self {
        registerFactory(interface) { _ in instance }
    }

    public func register<T>(_ interface: T.Type, instanceBuilder: (MSResolver) -> T) -> Self {
        register(interface, instance: instanceBuilder(self))
    }

    public func registerFactory<Service>(_ type: Service.Type, _ factory: @escaping (MSResolver) -> Service) -> Self {
        assert(!factories.contains { $0.supports(type) })
        let newFactory = MSBasicServiceFactory<Service>(type, factory: factory)
        return MSServiceResolver(factories: factories + [MSAnyServiceFactory(newFactory)])
    }

}

// MARK: Resolver
extension MSServiceResolver: MSResolver {

    public func resolve<Service>(_ type: Service.Type) -> Service {
        guard let factory = factories.first(where: { $0.supports(type) }) else {
            fatalError("No suitable factory found (\(type.self)")
        }
        return factory.resolve(from: self)
    }
}

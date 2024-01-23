// Copyright (c) 2042 Magic Solutions. All rights reserved.

import Foundation

@propertyWrapper
public struct MSProviderDependency<T> {

    // MARK: - Properties
    public var wrappedValue: T {
        MSProviderLocator.resolve(T.self)
    }

    // MARK: - Init/Deinit
    public init() {}

}

// Copyright (c) 2024 Magic Solutions. All rights reserved.

@propertyWrapper
struct MSServiceDependency<T> {

    // MARK: - Properties
    var wrappedValue: T {
        MSServiceLocator.resolve(T.self)
    }

    // MARK: - Init/Deinit
    init() {}

}

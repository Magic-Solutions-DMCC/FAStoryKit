// Copyright (c) 2024 Magic Solutions. All rights reserved.

@propertyWrapper
struct MSRepositoryDependency<T> {

    // MARK: - Properties
    var wrappedValue: T {
        MSRepositoryLocator.resolve(T.self)
    }

    // MARK: - Init/Deinit
    init() {}

}

// Copyright (c) 2024 Magic Solutions. All rights reserved.

import Foundation

public protocol MSServiceFactory {
    associatedtype Service
    /**
     Метод взятия инстанса фактори по его типу
     - Parameters: type - Тип фактори
     - Returns: - Фактори
     */
    func resolve(from resolver: MSResolver) -> Service
}

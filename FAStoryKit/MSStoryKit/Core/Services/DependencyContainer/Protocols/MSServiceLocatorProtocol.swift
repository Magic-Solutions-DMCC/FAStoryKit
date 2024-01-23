// Copyright (c) 2024 Magic Solutions. All rights reserved.

import Foundation

public protocol MSServiceLocatorProtocol {
    /**
     Метод взятия инстанса объекта по его типу
     - Parameters: type - Тип объекта
     - Returns: - Объект
     */
    static func resolve<Service>(_ type: Service.Type) -> Service
}

// Copyright (c) 2024 Magic Solutions. All rights reserved.

import Foundation

public protocol MSResolver {
    /**
     Метод взятия инстанса объекта по его типу
     - Parameters: type - Тип объекта
     - Returns: - Объект
     */
    func resolve<Service>(_ type: Service.Type) -> Service
}

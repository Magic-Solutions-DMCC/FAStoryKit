// Copyright (c) 2024 Magic Solutions. All rights reserved.

import Foundation

public protocol MSStoryKitProviderProtocol {

    /// Метод для подготовки сторисов
    /// - Parameters storiesJSONFileName: Имя файла
    /// - Parameters shouldPreload: Следует ли предварительно загрузить файлы
    func prepareStories(storiesJSONFileName: String, shouldPreload: Bool)
}

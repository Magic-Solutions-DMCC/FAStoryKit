// Copyright (c) 2024 Magic Solutions. All rights reserved.

import Foundation

enum MSSFileFormat: String {
    case mp4
    case jpg
}

// MARK: - Decodable
extension MSSFileFormat: Decodable { }

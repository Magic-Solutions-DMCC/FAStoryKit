// Copyright (c) 2024 Magic Solutions. All rights reserved.

import Foundation

extension URL {

    var fileName: String {
        return self.deletingPathExtension().lastPathComponent
    }

    var fileExtension: String {
        return self.pathExtension
    }

}

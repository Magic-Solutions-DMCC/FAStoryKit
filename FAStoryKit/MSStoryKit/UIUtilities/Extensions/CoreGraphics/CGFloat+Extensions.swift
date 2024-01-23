// Copyright (c) 2024 Magic Solutions. All rights reserved.

import CoreGraphics

public extension CGFloat {

    static let whole: CGFloat = 1
    static var half = 0.5
    static var quarter = 0.25

    func half() -> CGFloat {
        self * 0.5
    }

}

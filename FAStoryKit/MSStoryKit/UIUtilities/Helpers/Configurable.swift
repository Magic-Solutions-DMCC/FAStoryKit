// Copyright (c) 2024 Magic Solutions. All rights reserved.

import Foundation
import UIKit

public protocol Configurable {
    init()
}

extension Configurable {

    // MARK: - Init/Deinit
    public init(with config: (inout Self) -> Void) {
        self.init()
        config(&self)
    }

}

// MARK: - UIView
extension UIView: Configurable {}

// MARK: - CALayer
extension CALayer: Configurable {}

// MARK: - UIBezierPath
extension UIBezierPath: Configurable {}

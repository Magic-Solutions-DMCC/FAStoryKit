// Copyright (c) 2024 Magic Solutions. All rights reserved.

import SnapKit
import UIKit

extension UILayoutGuide {

    // MARK: - Typealias
    typealias Constraint = SnapKit.Constraint
    typealias Layout = SnapKit.ConstraintLayoutGuideDSL

    // MARK: - Computed properties
    var layout: Layout {
       return snp
    }

}

// Copyright (c) 2024 Magic Solutions. All rights reserved.

import SnapKit
import UIKit

extension UIView {

    // MARK: - Typealias
    typealias Constraint = SnapKit.Constraint
    typealias Layout = SnapKit.ConstraintViewDSL

    // MARK: - Computed properties
    var layout: Layout {
       return snp
    }

}

// Copyright (c) 2024 Magic Solutions. All rights reserved.

import UIKit

public protocol MSPreviewStoryViewDelegate: AnyObject {
    /// cell horizontal spacing
    var cellHorizontalSpacing: CGFloat {get}

    /// cell height
    var cellHeight: CGFloat {get}

    /// cell width
    var cellWidth: CGFloat {get}

    /// cell aspect ratio
    var cellAspectRatio: CGFloat {get}

    /// cornerRadius
    var cornerRadius: CGFloat {get}

    /// vertical cell padding
    func verticalCellPadding() -> CGFloat

    /// frame image
    var frameImage: UIImage? { get }

    /// did select
    func didSelect(row: Int) -> Void

}

public extension MSPreviewStoryViewDelegate {
    /// cell horizontal spacing
    var cellHorizontalSpacing: CGFloat {
        return DefaultValues.shared.cellHorizontalSpacing
    }

    /// cell width
    var cellHeight: CGFloat {
        return DefaultValues.shared.cellHeight
    }

    /// cell width
    var cellWidth: CGFloat {
        return DefaultValues.shared.cellWidth
    }

    /// cell aspect ratio
    var cellAspectRatio: CGFloat {
        return DefaultValues.shared.cellAspectRatio
    }

    /// cornerRadius
    var cornerRadius: CGFloat {
        return DefaultValues.shared.cornerRadius
    }

    /// vertical cell padding
    func verticalCellPadding() -> CGFloat { return DefaultValues.shared.verticalCellPadding() }


    var frameImage: UIImage? {
        return nil
    }
}

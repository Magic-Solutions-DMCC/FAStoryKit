//
//  FAStoryDelegate.swift
//  FAStoryKit
//
//  Created by Ferhat Abdullahoglu on 6.07.2019.
//  Copyright © 2019 Ferhat Abdullahoglu. All rights reserved.
//

import UIKit

public protocol FAStoryDelegate: AnyObject {
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
    
    /// frame image
    var frameImage: UIImage? { get }
    
    /// vertical cell padding
    func verticalCellPadding() -> CGFloat
    
    /// did select
    func didSelect(row: Int) -> Void 
    
}

public extension FAStoryDelegate {
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
    
    var frameImage: UIImage? {
        return nil
    }
    
    /// vertical cell padding
    func verticalCellPadding() -> CGFloat { return DefaultValues.shared.verticalCellPadding() }
}

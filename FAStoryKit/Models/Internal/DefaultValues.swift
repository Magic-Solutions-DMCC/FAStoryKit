//
//  DefaultValues.swift
//  FAStoryKit
//
//  Created by Ferhat Abdullahoglu on 7.07.2019.
//  Copyright © 2019 Ferhat Abdullahoglu. All rights reserved.
//

import UIKit

internal class DefaultValues: FAStoryDelegate {
    
    /// internally shared singleton
    static var shared = DefaultValues()
    
    /// cell horizontal spacing
    var cellHorizontalSpacing: CGFloat {
        return cellWidth
    }
    
    /// cell width
    var cellWidth: CGFloat {
        return UIScreen.main.bounds.width * 0.25
    }
    
    var cellHeight: CGFloat {
        return UIScreen.main.bounds.width * 0.38
    }
    
    /// cell aspect ratio
    var cellAspectRatio: CGFloat {
        return 1
    }
    
    var cornerRadius: CGFloat {
        return cellWidth * 0.16
    }
    
    var closeImage: UIImage? {
        return UIImage()
    }
    
    func didSelect(row: Int) {  }
    
    func verticalCellPadding() -> CGFloat {
        return .zero
    }
}

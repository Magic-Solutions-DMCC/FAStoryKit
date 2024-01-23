// Copyright (c) 2024 Magic Solutions. All rights reserved.

import UIKit

extension UIView {

    func addSubviews(_ views: UIView..., translatesAutoresizingMaskIntoConstraints: Bool = false) {
        views.forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = translatesAutoresizingMaskIntoConstraints
        }
    }

    func removeSubviews() {
        subviews.forEach { $0.removeFromSuperview() }
    }

}

extension UIView {

    var snapshot: UIImage? {
        let renderer = UIGraphicsImageRenderer(size: bounds.size)
        let image = renderer.image { context in
            layer.render(in: context.cgContext)
        }
        return image
    }

}

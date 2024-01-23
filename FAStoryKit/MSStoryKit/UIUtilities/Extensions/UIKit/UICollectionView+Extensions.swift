// Copyright (c) 2024 Magic Solutions. All rights reserved.

import UIKit

extension UICollectionView {

    func register<T: UICollectionViewCell>(_ type: T.Type) {
        register(T.self, forCellWithReuseIdentifier: T.reuseIdentifier)
    }

    func reuse<T: UICollectionViewCell>(_ type: T.Type, _ indexPath: IndexPath) -> T? {
        dequeueReusableCell(withReuseIdentifier: T.reuseIdentifier, for: indexPath) as? T
    }

}

extension UICollectionViewCell {

    static var reuseIdentifier: String {
        String(describing: self)
    }

}

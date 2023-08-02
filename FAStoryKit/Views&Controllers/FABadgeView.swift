// Copyright (c) 2023 Magic Solutions. All rights reserved.

import UIKit

final class FABadgeView: UIControl {

    // MARK: - Computed propeties
    var title: String = "" {
        didSet {
            titleLabel.text = title
            invalidateIntrinsicContentSize()
        }
    }
    
     // MARK: - Subviews
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.numberOfLines = 1
        label.textAlignment = .center
        return label
    }()

    // MARK: - Init/Deinit
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - Private methods
    private func configure() {
        backgroundColor = .white
        layer.cornerRadius = Constants.cornerRadius
        clipsToBounds = true
        
        addSubviews()
        layout()
    }
    
    private func addSubviews() {
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func layout() {
        NSLayoutConstraint.activate(
            titleLabelConstraints() +
            setupViewConstraints()
        )
    }
    
    private func titleLabelConstraints() -> [NSLayoutConstraint] {
        return [
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12)
        ]
    }
    
    private func setupViewConstraints() -> [NSLayoutConstraint] {
        return [
            heightAnchor.constraint(equalToConstant: Constants.viewHeight)
        ]
    }
    
}

private enum Constants {
    static let cornerRadius: CGFloat = 11
    static let titleLabelFontSize: CGFloat = 10
    static let titleLabelNumberOfLines: Int = 1
    static let viewHeight: CGFloat = 33
}

// Copyright (c) 2024 Magic Solutions. All rights reserved.

import UIKit

final public class MSPreviewStoryView: UIView {

    // MARK: - IBOutlets
    @IBOutlet internal var storyView: UIView!

    @IBOutlet internal weak var collectionView: UICollectionView!

    @IBOutlet internal weak var collectionViewFlowLayout: UICollectionViewFlowLayout!

    @IBOutlet internal weak var collectionViewHeight: NSLayoutConstraint!

    public weak var delegate: MSPreviewStoryViewDelegate? {
        didSet {
            collectionViewHeight?.constant = (delegate?.cellHeight ?? DefaultValues.shared.cellHeight)
        }
    }

    private let viewModel: MSPreviewStoryViewModel

    // MARK: - Init
    public override init(frame: CGRect) {
        self.viewModel = MSPreviewStoryViewModel()
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        _setupUI()
    }

    public required init?(coder aDecoder: NSCoder) {
        self.viewModel = MSPreviewStoryViewModel()
        super.init(coder: aDecoder)
        translatesAutoresizingMaskIntoConstraints = true
        _setupUI()
    }

    // MARK: - View lifecycle
    public override func awakeFromNib() {
        super.awakeFromNib()
        autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }

    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        collectionView?.reloadData()
    }

    // MARK: - Public methods
    public func setScrollIndicators(hidden: Bool) {
        collectionView?.showsVerticalScrollIndicator = !hidden
        collectionView?.showsHorizontalScrollIndicator = !hidden
    }

    public func setContentInset(insets: UIEdgeInsets) {
        collectionView?.contentInset = insets
    }

    public func setBouncesOnScroll(_ bounces: Bool) {
        collectionView?.alwaysBounceHorizontal = bounces
    }

    // MARK: - Private methods
    private func _setupUI() {
        let bundle = Bundle(for: FAStoryView.self)
        bundle.loadNibNamed("FAStoryView", owner: self, options: nil)
        addSubview(storyView)
        storyView.frame = bounds
        storyView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        _cvSetup()

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(_storySeen(_:)),
                                               name: .storySeen,
                                               object: nil
        )
    }


    /// prepares the collectionView for usage
    private func _cvSetup() {
        collectionView.register(FAStoryCollectionViewCell.self, forCellWithReuseIdentifier: FAStoryCollectionViewCell.ident)
        collectionView.contentInset = .zero
        collectionView.delaysContentTouches = false
        collectionView.backgroundColor = .clear
    }

    @objc
    private func _storySeen(_ notification: Notification) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else {return}
            self.collectionView?.reloadData()
        }
    }
}

// MARK: - UICollectionViewDataSource
extension MSPreviewStoryView: UICollectionViewDataSource {


    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfStories()
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FAStoryCollectionViewCell.ident, for: indexPath) as! FAStoryCollectionViewCell
        cell.backgroundColor = backgroundColor
        cell.setCornerRadius(cornerRadius: delegate?.cornerRadius ?? DefaultValues.shared.cornerRadius)
        //cell.storyIdent = stories![indexPath.row].ident
        cell.setImage(viewModel.previewImage(for: indexPath))

        if let frameImage = delegate?.frameImage {
            cell.setFrameImage(frameImage)
        }

        return cell
    }

    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

}

// MARK: - UICollectionViewDelegate
extension MSPreviewStoryView: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let h = delegate?.cellHeight ?? DefaultValues.shared.cellHeight
        let w = delegate?.cellWidth ?? DefaultValues.shared.cellWidth
        return CGSize(width: w, height: h)
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return delegate?.cellHorizontalSpacing ?? DefaultValues.shared.cellHorizontalSpacing
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return delegate?.cellHorizontalSpacing ?? DefaultValues.shared.cellHorizontalSpacing
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: delegate?.cellHorizontalSpacing ?? DefaultValues.shared.cellHorizontalSpacing, bottom: 0, right: delegate?.cellHorizontalSpacing ?? DefaultValues.shared.cellHorizontalSpacing)
    }

    /// user selected a cell
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.didSelect(row: indexPath.row)
    }

}

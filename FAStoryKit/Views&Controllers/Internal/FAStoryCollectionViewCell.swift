//
//  StoryCollectionViewCell.swift
//  FAStoryKit
//
//  Created by Ferhat Abdullahoglu on 6.07.2019.
//  Copyright © 2019 Ferhat Abdullahoglu. All rights reserved.
//

import UIKit

internal class FAStoryCollectionViewCell: UICollectionViewCell {

    
    // ==================================================== //
    // MARK: IBOutlets
    // ==================================================== //
    
    
    // ==================================================== //
    // MARK: IBActions
    // ==================================================== //
    
    
    // ==================================================== //
    // MARK: Properties
    // ==================================================== //
    
    // -----------------------------------
    // Internal properties
    // -----------------------------------
    
    /// ident
    class var ident: String {
        return "FAStoryCollectionViewCellIDent"
    }
    
    /// imageView for the defaultImage
    internal var imageView: UIImageView!
    internal var frameImageView: UIImageView!
    
    /// story ident
    internal var storyIdent = ""
    
    // -----------------------------------
    
    
    // -----------------------------------
    // Private properties
    // -----------------------------------
    /// internal ui setup is completed
    private var isUiSetupDone = false
    private var cornerRadius: CGFloat = .zero {
        didSet {
            contentView.setNeedsLayout()
            contentView.layoutIfNeeded()
        }
    }
    // -----------------------------------
    
    
    // ==================================================== //
    // MARK: Init
    // ==================================================== //
    
    
    // ==================================================== //
    // MARK: VC lifecycle
    // ==================================================== //
    override init(frame: CGRect) {
        super.init(frame: frame)
        _setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        _setupUI()
    }
  
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.layer.cornerRadius = cornerRadius
        contentView.clipsToBounds = true
    }
    
    // ==================================================== //
    // MARK: Methods
    // ==================================================== //
    
    // -----------------------------------
    // Public methods
    // -----------------------------------
    
    /// Sets the preview image
    public func setImage(_ image: UIImage) {
        guard isUiSetupDone else {return}
        imageView.image = image 
    }
    
    public func setFrameImage(_ image: UIImage) {
        guard isUiSetupDone else {return}
        frameImageView.image = image
    }
    
    /// sets the radius
    ///
    /// - Parameters:
    ///   - cornerRadius: content view corner radius
    public func setCornerRadius(cornerRadius: CGFloat) {
        self.cornerRadius = cornerRadius
    }
    
    // -----------------------------------
    
    
    // -----------------------------------
    // Private methods
    // -----------------------------------
    /// UI Setup
    private func _setupUI() {
       
        //
        // clear the background color
        //
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        //
        // imageView Setup
        //
        imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleToFill
        imageView.backgroundColor = .clear
        
        contentView.addSubview(imageView)
        
        imageView.widthAnchor.constraint(equalTo: contentView.widthAnchor).isActive = true
        imageView.heightAnchor.constraint(equalTo: contentView.heightAnchor).isActive = true
        imageView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        
        //
        // frameImageView Setup
        //
        frameImageView = UIImageView()
        frameImageView.translatesAutoresizingMaskIntoConstraints = false
        frameImageView.contentMode = .scaleAspectFill
        frameImageView.backgroundColor = .clear
        contentView.addSubview(frameImageView)
        
        frameImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        frameImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        frameImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.8).isActive = true
        frameImageView.heightAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.8).isActive = true
        
        isUiSetupDone = true
    }
    
}

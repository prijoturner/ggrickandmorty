//
//  FavoriteTableViewCell.swift
//  RickNMorty
//
//  Created by Kazuha on 04/11/25.
//

import UIKit

class FavoriteTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    static let identifier = "FavoriteTableViewCell"
    private lazy var characterImageView = UIFactory.createImageView(contentMode: .scaleToFill, cornerRadius: 8, clipsToBounds: true)
    private lazy var nameLabel = UIFactory.createLabel(fontSize: 24, weight: .semibold, color: .label, lines: 1)
    private lazy var speciesLabel = UIFactory.createLabel(fontSize: 16, weight: .semibold, color: .label)
    private lazy var originLabel = UIFactory.createLabel(fontSize: 16, weight: .semibold, color: .label)
    private lazy var containerView = UIFactory.createView(backgroundColor: .appLightBackground, cornerRadius: 16)
    private var containerLeadingConstraint: NSLayoutConstraint!
    private lazy var checkmarkView = UIFactory.createView(cornerRadius: 10, borderColor: UIColor.appLightBackground.cgColor, borderWidth: 2, isHidden: true)
    private lazy var checkmarkImageView: UIImageView = {
        let imageView = UIFactory.createImageView(contentMode: .scaleAspectFit, clipsToBounds: true, isHidden: true)
        imageView.image = UIImage(systemName: "checkmark")
        imageView.tintColor = .white
        return imageView
    }()

    // MARK: - Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    // MARK: - Private Methods
    private func setupView() {
        contentView.addSubviews(checkmarkView, containerView)
        checkmarkView.addSubview(checkmarkImageView)
        containerView.isUserInteractionEnabled = false
        containerView.addSubviews(
            nameLabel,
            characterImageView,
            speciesLabel,
            originLabel
        )
        addConstraint()
    }
    
    private func addConstraint() {
        containerLeadingConstraint = containerView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16)
        
        NSLayoutConstraint.activate([
            /// `checkmarkView` constraint
            checkmarkView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16),
            checkmarkView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            checkmarkView.widthAnchor.constraint(equalToConstant: 20),
            checkmarkView.heightAnchor.constraint(equalToConstant: 20),
            
            /// `checkmarkImageView` constraint
            checkmarkImageView.centerXAnchor.constraint(equalTo: checkmarkView.centerXAnchor),
            checkmarkImageView.centerYAnchor.constraint(equalTo: checkmarkView.centerYAnchor),
            checkmarkImageView.widthAnchor.constraint(equalToConstant: 12),
            checkmarkImageView.heightAnchor.constraint(equalToConstant: 12),
            
            /// `containerView` constraint
            containerLeadingConstraint,
            containerView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16),
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0),
            
            /// `characterImgView` constraint
            characterImageView.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 8),
            characterImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            characterImageView.widthAnchor.constraint(equalToConstant: 100),
            characterImageView.heightAnchor.constraint(equalToConstant: 100),
            
            /// `nameLabel` constraint
            nameLabel.leftAnchor.constraint(equalTo: characterImageView.rightAnchor, constant: 14),
            nameLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -8),
            nameLabel.topAnchor.constraint(equalTo: characterImageView.topAnchor),
            
            /// `speciesLabel` constraint
            speciesLabel.leftAnchor.constraint(equalTo: characterImageView.rightAnchor, constant: 14),
            speciesLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            
            /// `originLabel` constraint
            originLabel.leftAnchor.constraint(equalTo: characterImageView.rightAnchor, constant: 14),
            originLabel.topAnchor.constraint(equalTo: speciesLabel.bottomAnchor, constant: 8),
            originLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -8),
        ])
    }
    
    // MARK: - Public Methods
    public func configureCell(with displayData: CharacterDetailDisplayData, isEditMode: Bool = false, isSelected: Bool = false) {
        nameLabel.text = displayData.name
        speciesLabel.text = displayData.species
        originLabel.text = displayData.origin
        characterImageView.fetchImage(from: displayData.imageURL)
        
        // Update checkmark visibility and state
        let wasInEditMode = !checkmarkView.isHidden
        checkmarkView.isHidden = !isEditMode
        checkmarkImageView.isHidden = !isSelected
        
        let shouldAnimate = wasInEditMode != isEditMode
        
        if isEditMode {
            containerLeadingConstraint.constant = 48
            if isSelected {
                checkmarkView.backgroundColor = .appAccent
                checkmarkView.layer.borderColor = UIColor.appAccent.cgColor
            } else {
                checkmarkView.backgroundColor = .clear
                checkmarkView.layer.borderColor = UIColor.systemGray3.cgColor
            }
        } else {
            containerLeadingConstraint.constant = 16
        }
        
        if shouldAnimate {
            UIView.animate(withDuration: 0.3) {
                self.layoutIfNeeded()
            }
        }
    }

}

//
//  GGCharacterCollectionViewCell.swift
//  GGRickMorty
//
//  Created by Kazuha on 29/04/23.
//

import UIKit

class GGCharacterCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    static let identifier = "GGCharacterCollectionViewCell"
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.layer.cornerRadius = 10
        imageView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    private let nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.numberOfLines = 1
        nameLabel.textColor = .black
        nameLabel.textAlignment = .center
        nameLabel.adjustsFontSizeToFitWidth = true
        nameLabel.minimumScaleFactor = 0.5
        nameLabel.font = .SFProRounded(style: .semibold, size: 21)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        return nameLabel
    }()
    private let speciesLabel: UILabel = {
        let speciesLabel = UILabel()
        speciesLabel.textColor = .black
        speciesLabel.font = .SFProRounded(style: .regular, size: 14)
        speciesLabel.translatesAutoresizingMaskIntoConstraints = false
        return speciesLabel
    }()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.layer.cornerRadius = 10
        contentView.backgroundColor = .GGLightGrey
        contentView.addSubviews(imageView, nameLabel, speciesLabel)
        addConstraint()
    }
    
    required init(coder: NSCoder) {
        fatalError("unsupported")
    }
    
    // MARK: - Reuse
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        nameLabel.text = nil
        speciesLabel.text = nil
    }
    
    // MARK: - Private Methods
    private func addConstraint() {
        NSLayoutConstraint.activate([
            /// Name label constraint
            nameLabel.heightAnchor.constraint(equalToConstant: 25),
            nameLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            nameLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 5),
            nameLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -5),
            nameLabel.bottomAnchor.constraint(equalTo: speciesLabel.topAnchor, constant: -4),
            
            /// Species label constraint
            speciesLabel.heightAnchor.constraint(equalToConstant: 25),
            speciesLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            speciesLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            
            /// Image view constraint
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            imageView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            imageView.bottomAnchor.constraint(equalTo: nameLabel.topAnchor, constant: -6),
        ])
    }
    
    // MARK: - Public Methods
    public func configureCell(with viewModel: Character) {
        nameLabel.text = viewModel.name
        speciesLabel.text = viewModel.species
        imageView.fetchImage(from: viewModel.image)
    }
}

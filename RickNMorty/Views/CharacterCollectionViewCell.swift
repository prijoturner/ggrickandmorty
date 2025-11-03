//
//  CharacterCollectionViewCell.swift
//  RickNMorty
//
//  Created by Kazuha on 29/04/23.
//

import UIKit

class CharacterCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    static let identifier = "CharacterCollectionViewCell"
    
    private lazy var imageView: UIImageView = {
        let imageView = UIFactory.createImageView(contentMode: .scaleToFill, cornerRadius: 10, clipsToBounds: true)
        imageView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        return imageView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UIFactory.createLabel(fontSize: 21, weight: .semibold, color: .black, lines: 1, alignment: .center)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        return label
    }()
    
    private lazy var speciesLabel = UIFactory.createLabel(fontSize: 14, weight: .regular, color: .black)
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.layer.cornerRadius = 10
        contentView.backgroundColor = .AppLightGrey
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
    public func configureCell(with displayData: CharacterDisplayData) {
        nameLabel.text = displayData.name
        speciesLabel.text = displayData.species
        imageView.fetchImage(from: displayData.imageURL)
    }
}

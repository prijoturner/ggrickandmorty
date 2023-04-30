//
//  GGRectangleListTableViewCell.swift
//  GGRickMorty
//
//  Created by Kazuha on 30/04/23.
//

import UIKit

class GGRectangleListTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    static let identifier = "GGRectangleListTableViewCell"
    private let borderView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        view.layer.borderWidth = 1.0
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.font = .SFProRounded(style: .semibold, size: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let typeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .SFProRounded(style: .semibold, size: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let dimensionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.numberOfLines = 2
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.font = .SFProRounded(style: .semibold, size: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        /// Update the `borderColor` if the interface style changes
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            updateBorderColor()
        }
    }

    private func updateBorderColor() {
        borderView.layer.borderColor = traitCollection.userInterfaceStyle == .dark ? UIColor.white.cgColor : UIColor.black.cgColor
    }

    // MARK: - Private Methods
    private func setupView() {
        contentView.addSubviews(
            borderView,
            nameLabel,
            typeLabel,
            dimensionLabel
        )
        updateBorderColor()
        addConstraint()
    }
    
    private func addConstraint() {
        NSLayoutConstraint.activate([
            /// `borderView` constraint
            borderView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16),
            borderView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16),
            borderView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            borderView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6),
            
            /// `nameLabel` constraint
            nameLabel.leftAnchor.constraint(equalTo: borderView.leftAnchor, constant: 14),
            nameLabel.widthAnchor.constraint(equalTo: borderView.widthAnchor, multiplier: 0.5),
            nameLabel.topAnchor.constraint(equalTo: borderView.topAnchor, constant: 6),
            
            /// `typeLabel` constraint
            typeLabel.leftAnchor.constraint(equalTo: borderView.leftAnchor, constant: 14),
            typeLabel.rightAnchor.constraint(equalTo: borderView.rightAnchor, constant: -14),
            typeLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 6),
            typeLabel.bottomAnchor.constraint(equalTo: borderView.bottomAnchor, constant: -6),
            
            /// `dimensionLabel` constraint
            dimensionLabel.leftAnchor.constraint(equalTo: nameLabel.rightAnchor, constant: 14),
            dimensionLabel.rightAnchor.constraint(equalTo: borderView.rightAnchor, constant: -14),
            dimensionLabel.centerYAnchor.constraint(equalTo: borderView.centerYAnchor),
            dimensionLabel.bottomAnchor.constraint(equalTo: borderView.bottomAnchor, constant: -6)
        ])
    }
    
    // MARK: - Public Methods
    public func configureCell(with location: GGLocation) {
        nameLabel.text = location.name
        typeLabel.text = location.type
        dimensionLabel.attributedText = AttributedStringHelper.attributedStringForLineBreak(title: "Dimension", subTitle: location.dimension)
    }
}

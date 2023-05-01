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
    public let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.font = .SFProRounded(style: .semibold, size: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    public let subtitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.numberOfLines = 2
        label.font = .SFProRounded(style: .semibold, size: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    public let detailLabel: UILabel = {
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
            subtitleLabel,
            detailLabel
        )
        updateBorderColor()
        layoutAndStyle()
    }
    
    private func layoutAndStyle() {
        addConstraint()
        if UserDefaultsHelper.shared.bool(forKey: UserDefaultsKeys.isUsedByEpisodeViewController) {
            subtitleLabel.font = .SFProRounded(style: .regular, size: 20)
            detailLabel.font = .SFProRounded(style: .regular, size: 19)
        }
    }
    
    private func addConstraint() {
        if UserDefaultsHelper.shared.bool(forKey: UserDefaultsKeys.isUsedByEpisodeViewController) {
            NSLayoutConstraint.activate([
                /// `detailLabel` top constraint for `EpisodeViewController`
                detailLabel.topAnchor.constraint(equalTo: subtitleLabel.topAnchor),
                
                /// `nameLabel` right constraint for `EpisodeViewController`
                nameLabel.rightAnchor.constraint(equalTo: borderView.rightAnchor, constant: -14),
            ])
        } else {
            NSLayoutConstraint.activate([
                /// `detailLabel` constraint for `LocationViewController`
                detailLabel.centerYAnchor.constraint(equalTo: borderView.centerYAnchor),
                detailLabel.bottomAnchor.constraint(equalTo: borderView.bottomAnchor, constant: -6),
                
                /// `nameLabel` width constraint for `EpisodeViewController`
                nameLabel.widthAnchor.constraint(equalTo: borderView.widthAnchor, multiplier: 0.5),
            ])
        }
        NSLayoutConstraint.activate([
            /// `borderView` constraint
            borderView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16),
            borderView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16),
            borderView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            borderView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6),
            
            /// `nameLabel` constraint
            nameLabel.leftAnchor.constraint(equalTo: borderView.leftAnchor, constant: 14),
            nameLabel.topAnchor.constraint(equalTo: borderView.topAnchor, constant: 6),
            
            /// `subtitleLabel` constraint
            subtitleLabel.leftAnchor.constraint(equalTo: borderView.leftAnchor, constant: 14),
            subtitleLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 6),
            subtitleLabel.bottomAnchor.constraint(equalTo: borderView.bottomAnchor, constant: -6),
            subtitleLabel.widthAnchor.constraint(equalTo: borderView.widthAnchor, multiplier: 0.5),
            
            /// `detailLabel` constraint
            detailLabel.rightAnchor.constraint(equalTo: borderView.rightAnchor, constant: -14),
            detailLabel.leftAnchor.constraint(equalTo: subtitleLabel.rightAnchor, constant: 6)
        ])
    }
    
}

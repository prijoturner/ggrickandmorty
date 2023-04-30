//
//  GGEpisodesTableViewCell.swift
//  GGRickMorty
//
//  Created by Kazuha on 29/04/23.
//

import UIKit

class GGEpisodesTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    static let identifier = "GGEpisodesTableViewCell"
    private let episodeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .SFProRounded(style: .regular, size: 16)
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

    // MARK: - Private Methods
    private func setupView() {
        contentView.addSubview(episodeLabel)
        addConstraint()
    }
    
    private func addConstraint() {
        NSLayoutConstraint.activate([
            /// Episode label constraint
            episodeLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16),
            episodeLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            episodeLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5)
        ])
    }
    
    // MARK: - Public Methods
    public func configureCell(with episode: String) {
        episodeLabel.text = episode
    }

}

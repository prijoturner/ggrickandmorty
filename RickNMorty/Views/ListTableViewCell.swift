//
//  ListTableViewCell.swift
//  RickNMorty
//
//  Created by Kazuha on 29/04/23.
//

import UIKit

class ListTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    static let identifier = "ListTableViewCell"
    private lazy var listLabel = UIFactory.createLabel(fontSize: 16, weight: .regular, color: .label)
    
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
        contentView.addSubview(listLabel)
        addConstraint()
    }
    
    private func addConstraint() {
        NSLayoutConstraint.activate([
            /// `listLabel` constraint
            listLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 0),
            listLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            listLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5)
        ])
    }
    
    // MARK: - Public Methods
    public func configureCell(with data: String) {
        listLabel.text = data
    }

}

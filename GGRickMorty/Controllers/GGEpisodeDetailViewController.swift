//
//  GGEpisodeDetailViewController.swift
//  GGRickMorty
//
//  Created by Kazuha on 01/05/23.
//

import UIKit

class GGEpisodeDetailViewController: GGBaseDetailViewController {
    
    // MARK: - Properties
    public let episodeDetailViewModel = GGEpisodeDetailViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        episodeDetailViewModel.applyData(titleLabel: titleLabel,
                                          headingLabel: headingLabel,
                                          subHeadingLabel: subHeadingLabel,
                                          createdLabel: createdLabel,
                                          titleForListLabel: titleForListLabel)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.layoutIfNeeded()
        let contentSize = tableView.contentSize
        let newHeight = contentSize.height
        tableViewHeightConstraint?.constant = newHeight
    }
    
    // MARK: - Private Methods
    private func setupView() {
        title = episodeDetailViewModel.episode?.name
        setupTableView()
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableViewHeightConstraint = NSLayoutConstraint(
            item: tableView,
            attribute: .height,
            relatedBy: .equal,
            toItem: nil,
            attribute: .notAnAttribute,
            multiplier: 1,
            constant: 0
        )
        tableViewHeightConstraint.isActive = true
    }

}

// MARK: - TableView
extension GGEpisodeDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return episodeDetailViewModel.episode?.characters.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: GGListTableViewCell.identifier, for: indexPath) as?  GGListTableViewCell else { fatalError("Couldn't find \(GGListTableViewCell.identifier)") }
        guard let character = episodeDetailViewModel.episode?.characters[indexPath.row] else { return UITableViewCell() }
        cell.configureCell(with: character)
        return cell
    }
    
}

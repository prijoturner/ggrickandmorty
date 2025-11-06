//
//  EpisodeDetailViewController.swift
//  RickNMorty
//
//  Created by Kazuha on 01/05/23.
//

import UIKit
import Combine

class EpisodeDetailViewController: BaseDetailViewController {
    
    // MARK: - Properties
    public let viewModel = EpisodeDetailViewModel()
    private var cancellables = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        bindViewModel()
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
    
    private func bindViewModel() {
        viewModel.$displayEpisodeDetail
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] data in
                self?.title = data.name
                self?.titleLabel.text = data.name
                self?.headingLabel.attributedText = data.headingText
                self?.subHeadingLabel.attributedText = data.episodeText
                self?.createdLabel.attributedText = data.createdText
                self?.titleForListLabel.text = data.charactersTitle
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)
    }

}

// MARK: - TableView
extension EpisodeDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfCharacters()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ListTableViewCell.identifier, for: indexPath) as?  ListTableViewCell else { fatalError("Couldn't find \(ListTableViewCell.identifier)") }
        guard let character = viewModel.character(at: indexPath.row) else { return UITableViewCell() }
        cell.configureCell(with: character)
        return cell
    }
    
}

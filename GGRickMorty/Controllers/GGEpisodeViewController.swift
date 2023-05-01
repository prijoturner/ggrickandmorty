//
//  GGEpisodeViewController.swift
//  GGRickMorty
//
//  Created by Kazuha on 29/04/23.
//

import UIKit

final class GGEpisodeViewController: GGBaseRectangleListViewController {
    
    // MARK: - Properties
    private let episodeViewModel = GGEpisodeViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        fetchAllLocations()
    }
    
    // MARK: - Private Methods
    private func setupView() {
        title = "Episode"
        view.backgroundColor = .systemBackground
        tableView.dataSource = self
        tableView.delegate = self
        setupSearchController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UserDefaultsHelper.shared.setBool(true, forKey: UserDefaultsKeys.isUsedByEpisodeViewController)
    }
    
    private func setupSearchController() {
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    private func fetchAllLocations() {
        /// Fetch characters data from API
        episodeViewModel.fetchEpisodes() { [weak self] result in
            guard let strongSelf = self else { return }
            switch result {
            case .success:
                DispatchQueue.main.async {
                    strongSelf.spinner.stopAnimating()
                    /// Check if the view models has no data
                    if strongSelf.episodeViewModel.episodes.isEmpty {
                        strongSelf.tableView.backgroundView = strongSelf.noDataView
                    } else {
                        UIView.animate(withDuration: 0.4) {
                            strongSelf.tableView.alpha = 1
                        }
                    }
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
}

extension GGEpisodeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return episodeViewModel.getNumberOfItems()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: GGRectangleListTableViewCell.identifier, for: indexPath) as?  GGRectangleListTableViewCell else { fatalError("Couldn't find \(GGRectangleListTableViewCell.identifier)") }
        let episode = episodeViewModel.getEpisode(at: indexPath.row)
        cell.nameLabel.text = episode.name
        cell.subtitleLabel.text = episode.episode.formatEpisodeString()
        cell.detailLabel.text = "Air Date:\n\(episode.airDate.formatDate())"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        /// Push the `EpisodeDetailViewController`
        let episodeDetailVC = GGEpisodeDetailViewController()
        let navigationController = UINavigationController(rootViewController: episodeDetailVC)
        episodeDetailVC.episodeDetailViewModel.episode = episodeViewModel.episodes[indexPath.row]
        self.present(navigationController, animated: true)
    }
    
}

extension GGEpisodeViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        episodeViewModel.setIsSearchBarActive(searchController.isActive && !(searchController.searchBar.text?.isEmpty ?? true))
        episodeViewModel.searchForEpisodes(with: searchText)
        tableView.reloadData()
        noDataView.isHidden = searchText.isEmpty || !episodeViewModel.searchedEpisodes.isEmpty ? true : false
    }
    
}


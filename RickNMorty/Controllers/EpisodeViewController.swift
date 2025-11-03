//
//  EpisodeViewController.swift
//  RickNMorty
//
//  Created by Kazuha on 29/04/23.
//

import UIKit
import Combine

final class EpisodeViewController: BaseRectangleListViewController {
    
    // MARK: - Properties
    private let episodeViewModel = EpisodeViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        bindViewModel()
        episodeViewModel.fetchEpisodes()
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
    
    private func bindViewModel() {
        episodeViewModel.$isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                if isLoading {
                    self?.spinner.startAnimating()
                } else {
                    self?.spinner.stopAnimating()
                }
            }
            .store(in: &cancellables)
        
        episodeViewModel.$displayEpisodes
            .receive(on: DispatchQueue.main)
            .sink { [weak self] episodes in
                guard let self = self else { return }
                if episodes.isEmpty && !self.episodeViewModel.isLoading {
                    self.noDataView.isHidden = false
                } else {
                    self.noDataView.isHidden = true
                    UIView.animate(withDuration: 0.4) {
                        self.tableView.alpha = 1
                    }
                }
                self.tableView.reloadData()
            }
            .store(in: &cancellables)
        
        episodeViewModel.$errorMessage
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] errorMessage in
                guard let self = self else { return }
                AlertHelper.showAlert(
                    on: self,
                    title: "Error",
                    message: "Failed to load episodes: \(errorMessage)",
                    primaryActionTitle: "Retry",
                    primaryActionHandler: { [weak self] _ in
                        self?.episodeViewModel.fetchEpisodes()
                    },
                    secondaryActionTitle: "Cancel"
                )
            }
            .store(in: &cancellables)
    }
    
}

extension EpisodeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return episodeViewModel.numberOfItems()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RectangleListTableViewCell.identifier, for: indexPath) as?  RectangleListTableViewCell else { fatalError("Couldn't find \(RectangleListTableViewCell.identifier)") }
        let episodeData = episodeViewModel.episode(at: indexPath.row)
        cell.configureForEpisode(with: episodeData)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        /// Push the `EpisodeDetailViewController`
        let episode = episodeViewModel.getOriginalEpisode(at: indexPath.row)
        let episodeDetailVC = EpisodeDetailViewController()
        let navigationController = UINavigationController(rootViewController: episodeDetailVC)
        episodeDetailVC.episodeDetailViewModel.episode = episode
        self.present(navigationController, animated: true)
    }
    
}

extension EpisodeViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let isActive = searchController.isActive && !(searchController.searchBar.text?.isEmpty ?? true)
        episodeViewModel.searchForEpisodes(with: searchText, isActive: isActive)
    }
    
}


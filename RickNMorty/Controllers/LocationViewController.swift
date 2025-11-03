//
//  LocationViewController.swift
//  RickNMorty
//
//  Created by Kazuha on 29/04/23.
//

import UIKit
import Combine

final class LocationViewController: BaseRectangleListViewController {
    
    // MARK: - Properties
    private let locationViewModel = LocationViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        bindViewModel()
        locationViewModel.fetchLocations()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UserDefaultsHelper.shared.setBool(false, forKey: UserDefaultsKeys.isUsedByEpisodeViewController)
    }
    
    // MARK: - Private Methods
    private func setupView() {
        title = "Location"
        view.backgroundColor = .systemBackground
        tableView.dataSource = self
        tableView.delegate = self
        setupSearchController()
    }
    
    private func setupSearchController() {
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    private func bindViewModel() {
        locationViewModel.$isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                if isLoading {
                    self?.spinner.startAnimating()
                } else {
                    self?.spinner.stopAnimating()
                }
            }
            .store(in: &cancellables)
        
        locationViewModel.$displayLocations
            .receive(on: DispatchQueue.main)
            .sink { [weak self] locations in
                guard let self = self else { return }
                if locations.isEmpty && !self.locationViewModel.isLoading {
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
        
        locationViewModel.$errorMessage
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] errorMessage in
                guard let self = self else { return }
                AlertHelper.showAlert(
                    on: self,
                    title: "Error",
                    message: "Failed to load locations: \(errorMessage)",
                    primaryActionTitle: "Retry",
                    primaryActionHandler: { [weak self] _ in
                        self?.locationViewModel.fetchLocations()
                    },
                    secondaryActionTitle: "Cancel"
                )
            }
            .store(in: &cancellables)
    }
    
}

extension LocationViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locationViewModel.numberOfItems()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RectangleListTableViewCell.identifier, for: indexPath) as?  RectangleListTableViewCell else { fatalError("Couldn't find \(RectangleListTableViewCell.identifier)") }
        let locationData = locationViewModel.location(at: indexPath.row)
        cell.configureForLocation(with: locationData)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        /// Push the `locationDetailViewController`
        let location = locationViewModel.getOriginalLocation(at: indexPath.row)
        let locationDetailVC = LocationDetailViewController()
        let navigationController = UINavigationController(rootViewController: locationDetailVC)
        locationDetailVC.locationDetailViewModel.location = location
        self.present(navigationController, animated: true)
    }
    
}

extension LocationViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let isActive = searchController.isActive && !(searchController.searchBar.text?.isEmpty ?? true)
        locationViewModel.searchForLocations(with: searchText, isActive: isActive)
    }
    
}

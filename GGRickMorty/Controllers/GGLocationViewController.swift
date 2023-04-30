//
//  GGLocationViewController.swift
//  GGRickMorty
//
//  Created by Kazuha on 29/04/23.
//

import UIKit

final class GGLocationViewController: GGBaseRectangleListViewController {
    
    // MARK: - Properties
    private let locationViewModel = GGLocationViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        fetchAllLocations()
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
    
    private func fetchAllLocations() {
        /// Fetch characters data from API
        locationViewModel.fetchLocations() { [weak self] result in
            guard let strongSelf = self else { return }
            switch result {
            case .success:
                DispatchQueue.main.async {
                    strongSelf.spinner.stopAnimating()
                    /// Check if the view models has no data
                    if strongSelf.locationViewModel.locations.isEmpty {
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

extension GGLocationViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locationViewModel.getNumberOfItems()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: GGRectangleListTableViewCell.identifier, for: indexPath) as?  GGRectangleListTableViewCell else { fatalError("Couldn't find \(GGRectangleListTableViewCell.identifier)") }
        cell.configureCell(with: locationViewModel.getCharacter(at: indexPath.row))
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        /// Push the `locationDetailViewController`
        let locationDetailVC = GGLocationDetailViewController()
        let navigationController = UINavigationController(rootViewController: locationDetailVC)
        locationDetailVC.locationDetailViewModel.location = locationViewModel.locations[indexPath.row]
        self.present(navigationController, animated: true)
    }
    
}

extension GGLocationViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        locationViewModel.setIsSearchBarActive(searchController.isActive && !(searchController.searchBar.text?.isEmpty ?? true))
        locationViewModel.searchForLocations(with: searchText)
        tableView.reloadData()
        noDataView.isHidden = searchText.isEmpty || !locationViewModel.searchedLocations.isEmpty ? true : false
    }
    
}

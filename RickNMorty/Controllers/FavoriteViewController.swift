//
//  FavoriteViewController.swift
//  RickNMorty
//
//  Created by Kazuha on 03/11/25.
//

import UIKit
import Combine

class FavoriteViewController: UIViewController {
    
    // MARK: - Properties
    private let viewModel = FavoriteViewModel()
    private var cancellables = Set<AnyCancellable>()
    private var bottomSheetTransitioningDelegate: FilterCharacterBottomSheetDelegate?
    private let searchController = UISearchController(searchResultsController: nil)
    private lazy var spinner = UIFactory.createActivityIndicator()
    private lazy var tableView = UIFactory.createTableView(
        alpha: 0,
        cellClass: FavoriteTableViewCell.self,
        cellIdentifier: FavoriteTableViewCell.identifier
    )
    private lazy var noDataView = UIFactory.createNoDataView()

    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchFavoriteCharacters()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationItem.hidesSearchBarWhenScrolling = true
    }
    
    private func setupView() {
        title = "Favorite"
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .clear
        tableView.allowsSelection = true
        view.addSubviews(tableView, noDataView, spinner)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            noDataView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            noDataView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        setupSearchController()
        setupNavigationItem()
    }
    
    private func setupSearchController() {
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
    }
    private func setupNavigationItem() {
        let sliderBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "slider.horizontal.3"), style: .plain, target: self, action: #selector(filterButtonTapped))
        let editBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "trash"), style: .plain, target: self, action: #selector(editButtonTapped))
        navigationItem.rightBarButtonItems = [sliderBarButtonItem, editBarButtonItem]
    }
    
    private func bindViewModel() {
        spinner.startAnimating()
        viewModel.$isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                if isLoading {
                    self?.spinner.startAnimating()
                } else {
                    self?.spinner.stopAnimating()
                }
            }
            .store(in: &cancellables)
        
        viewModel.$displayCharacters
            .receive(on: DispatchQueue.main)
            .sink { [weak self] characters in
                guard let self = self else { return }
                if characters.isEmpty && !self.viewModel.isLoading {
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
        
        viewModel.$errorMessage
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] errorMessage in
                guard let self = self else { return }
                AlertHelper.showAlert(
                    on: self,
                    title: "Error",
                    message: "Failed to load characters: \(errorMessage)",
                    primaryActionTitle: "Retry",
                    primaryActionHandler: { [weak self] _ in
                        self?.viewModel.fetchFavoriteCharacters()
                    },
                    secondaryActionTitle: "Cancel"
                )
            }
            .store(in: &cancellables)
        
        viewModel.$isEditMode
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isEditMode in
                self?.updateEditModeUI(isEditMode: isEditMode)
            }
            .store(in: &cancellables)
        
        viewModel.$selectedIndices
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.updateVisibleCells()
            }
            .store(in: &cancellables)
    }
    
    private func presentBottomSheet() {
        let controller = FilterCharacterSheetContent()
        controller.bottomSheetViewModel.delegate = self
        controller.bottomSheetViewModel.selectedFilters = viewModel.selectedFilters
        
        let transitionDelegate = FilterCharacterBottomSheetDelegate()
        bottomSheetTransitioningDelegate = transitionDelegate
        
        controller.modalPresentationStyle = .custom
        controller.transitioningDelegate = transitionDelegate
        
        present(controller, animated: true)
    }
    
    private func updateEditModeUI(isEditMode: Bool) {
        tableView.allowsMultipleSelection = isEditMode
        
        if isEditMode {
            navigationItem.rightBarButtonItems?[1].image = UIImage(systemName: "xmark.circle")
            navigationItem.rightBarButtonItems?[1].tintColor = .systemRed
            
            let deleteButton = UIBarButtonItem(title: "Delete", style: .plain, target: self, action: #selector(deleteSelectedTapped))
            deleteButton.tintColor = .systemRed
            navigationItem.leftBarButtonItem = deleteButton
        } else {
            navigationItem.rightBarButtonItems?[1].image = UIImage(systemName: "trash")
            navigationItem.rightBarButtonItems?[1].tintColor = nil
            navigationItem.leftBarButtonItem = nil
            
            if let selectedRows = tableView.indexPathsForSelectedRows {
                for indexPath in selectedRows {
                    tableView.deselectRow(at: indexPath, animated: false)
                }
            }
        }
        updateVisibleCells()
    }
    
    private func updateVisibleCells() {
        for cell in tableView.visibleCells {
            if let favoriteCell = cell as? FavoriteTableViewCell,
               let indexPath = tableView.indexPath(for: cell),
               let data = viewModel.character(at: indexPath.row) {
                favoriteCell.configureCell(with: data, isEditMode: viewModel.isEditMode, isSelected: viewModel.isSelected(at: indexPath.row))
            }
        }
    }
    
    @objc private func filterButtonTapped() {
        presentBottomSheet()
    }
    
    @objc private func editButtonTapped() {
        viewModel.toggleEditMode()
    }
    
    @objc private func deleteSelectedTapped() {
        guard viewModel.hasSelectedItems() else {
            AlertHelper.showAlert(
                on: self,
                title: "No Selection",
                message: "Please select items to delete",
                primaryActionTitle: "OK"
            )
            return
        }
        
        let count = viewModel.selectedItemsCount()
        let message = count == 1 ? "Remove this favorite character?" : "Remove \(count) favorite characters?"
        
        AlertHelper.showAlert(
            on: self,
            title: "Confirm Deletion",
            message: message,
            primaryActionTitle: "Delete",
            primaryActionHandler: { [weak self] _ in
                self?.viewModel.removeSelectedFavorites()
                self?.viewModel.exitEditMode()
            },
            secondaryActionTitle: "Cancel"
        )
    }

}

// MARK: - Search
extension FavoriteViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let isActive = searchController.isActive && !(searchController.searchBar.text?.isEmpty ?? true)
        viewModel.searchForCharacters(with: searchText, isActive: isActive)
    }
}

// MARK: - TableView
extension FavoriteViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.displayCharacters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: FavoriteTableViewCell.identifier, for: indexPath) as? FavoriteTableViewCell {
            if let data = viewModel.character(at: indexPath.row) {
                cell.configureCell(with: data, isEditMode: viewModel.isEditMode, isSelected: viewModel.isSelected(at: indexPath.row))
            }
            cell.selectionStyle = .none
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        if viewModel.isEditMode {
            viewModel.toggleSelection(at: indexPath.row)
            
            if let cell = tableView.cellForRow(at: indexPath) as? FavoriteTableViewCell,
               let data = viewModel.character(at: indexPath.row) {
                cell.configureCell(with: data, isEditMode: viewModel.isEditMode, isSelected: viewModel.isSelected(at: indexPath.row))
            }
        } else {
            let character = viewModel.getOriginalCharacter(at: indexPath.row)
            let characterDetailViewModel = CharacterDetailViewModel(character: character)
            let characterDetailVC = CharacterDetailViewController(viewModel: characterDetailViewModel)
            characterDetailVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(characterDetailVC, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 124
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (action, view, completionHandler) in
            guard let self = self,
                  let character = self.viewModel.character(at: indexPath.row) else {
                completionHandler(false)
                return
            }
            
            AlertHelper.showAlert(
                on: self,
                title: "Confirm Deletion",
                message: "Remove \(character.name) from favorites?",
                primaryActionTitle: "Delete",
                primaryActionHandler: { [weak self] _ in
                    guard let self = self else { return }
                    _ = self.viewModel.removeFavorite(byName: character.name)
                    self.viewModel.fetchFavoriteCharacters()
                    completionHandler(true)
                },
                secondaryActionTitle: "Cancel",
                secondaryActionHandler: { _ in
                    completionHandler(false)
                }
            )
        }
        deleteAction.image = UIImage(systemName: "trash")
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
    }
    
}

extension FavoriteViewController: BottomSheetDelegate {
    func bottomSheetDidDismissed(filters: [String]) {
        viewModel.applyFilter(filters: filters)
    }
}

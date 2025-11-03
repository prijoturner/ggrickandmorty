//
//  CharacterViewController.swift
//  RickNMorty
//
//  Created by Kazuha on 29/04/23.
//

import UIKit
import Combine

final class CharacterViewController: UIViewController {
    
    // MARK: - Properties
    private let characterListViewModel = CharacterListViewModel()
    private var cancellables = Set<AnyCancellable>()
    private var bottomSheetTransitioningDelegate: FilterCharacterBottomSheetDelegate?
    private let searchController = UISearchController(searchResultsController: nil)
    private lazy var spinner = UIFactory.createActivityIndicator()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UIFactory.createFlowLayout(
            scrollDirection: .vertical,
            sectionInset: UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20),
            minimumLineSpacing: 25
        )
        return UIFactory.createCollectionView(
            layout: layout,
            alpha: 0,
            cellClass: CharacterCollectionViewCell.self,
            cellIdentifier: CharacterCollectionViewCell.identifier
        )
    }()
    
    private lazy var noDataView = UIFactory.createNoDataView()
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        bindViewModel()
        characterListViewModel.fetchCharacters()
    }
    
    // MARK: - Private Methods
    private func setupView() {
        title = "Character"
        collectionView.dataSource = self
        collectionView.delegate = self
        view.addSubviews(collectionView, spinner, noDataView)
        addConstraint()
        setupSearchController()
        setupNavigationItem()
    }
    
    private func setupNavigationItem() {
        let sliderBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "slider.horizontal.3"), style: .plain, target: self, action: #selector(filterButtonTapped))
        navigationItem.rightBarButtonItem = sliderBarButtonItem
        
        NotificationCenter.default.addObserver(self, selector: #selector(scrollToTop), name: NSNotification.Name("TabBarItemTapped"), object: nil)
    }
    
    private func setupSearchController() {
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    private func bindViewModel() {
        spinner.startAnimating()
        characterListViewModel.$isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                if isLoading {
                    self?.spinner.startAnimating()
                } else {
                    self?.spinner.stopAnimating()
                }
            }
            .store(in: &cancellables)
        
        characterListViewModel.$displayCharacters
            .receive(on: DispatchQueue.main)
            .sink { [weak self] characters in
                guard let self = self else { return }
                if characters.isEmpty && !self.characterListViewModel.isLoading {
                    self.noDataView.isHidden = false
                } else {
                    self.noDataView.isHidden = true
                    UIView.animate(withDuration: 0.4) {
                        self.collectionView.alpha = 1
                    }
                }
                self.collectionView.reloadData()
            }
            .store(in: &cancellables)
        
        characterListViewModel.$errorMessage
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
                        self?.characterListViewModel.fetchCharacters()
                    },
                    secondaryActionTitle: "Cancel"
                )
            }
            .store(in: &cancellables)
    }
    
    private func addConstraint() {
        NSLayoutConstraint.activate([
            /// `spinner` constraints
            spinner.widthAnchor.constraint(equalToConstant: 100),
            spinner.heightAnchor.constraint(equalToConstant: 100),
            spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            /// `collectionView` constraints
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
            
            /// `noDataView` constraints
            noDataView.topAnchor.constraint(equalTo: collectionView.topAnchor),
            noDataView.bottomAnchor.constraint(equalTo: collectionView.bottomAnchor),
            noDataView.leftAnchor.constraint(equalTo: collectionView.leftAnchor),
            noDataView.rightAnchor.constraint(equalTo: collectionView.rightAnchor),
        ])
    }
    
    @objc private func filterButtonTapped() {
        presentBottomSheet()
    }
    
    @objc private func scrollToTop() {
        scrollToTop(of: collectionView)
    }
    
    private func presentBottomSheet() {
        let controller = FilterCharacterSheetContent()
        controller.bottomSheetViewModel.delegate = self
        controller.bottomSheetViewModel.selectedFilters = characterListViewModel.selectedFilters
        
        let transitionDelegate = FilterCharacterBottomSheetDelegate()
        self.bottomSheetTransitioningDelegate = transitionDelegate
        
        controller.modalPresentationStyle = .custom
        controller.transitioningDelegate = transitionDelegate
        
        self.present(controller, animated: true)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}

// MARK: - Search
extension CharacterViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let isActive = searchController.isActive && !(searchController.searchBar.text?.isEmpty ?? true)
        characterListViewModel.searchForCharacters(with: searchText, isActive: isActive)
    }
    
}

// MARK: - CollectionView
extension CharacterViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return characterListViewModel.numberOfItems()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CharacterCollectionViewCell.identifier, for: indexPath) as? CharacterCollectionViewCell else { fatalError("Couldn't find \(CharacterCollectionViewCell.identifier)") }
        cell.configureCell(with: characterListViewModel.character(at: indexPath.row))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) {
            /// Animate the cell's `contentView` background color
            UIView.animate(withDuration: 0.1, animations: {
                cell.contentView.backgroundColor = .AppNeonGreen
            }, completion: { _ in
                UIView.animate(withDuration: 0.1) {
                    cell.contentView.backgroundColor = .AppLightGrey
                }
                
                /// Push the `characterDetailViewController`
                let character = self.characterListViewModel.getOriginalCharacter(at: indexPath.row)
                let viewModel = CharacterDetailViewModel(character: character)
                let characterDetailVC = CharacterDetailViewController(viewModel: viewModel)
                characterDetailVC.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(characterDetailVC, animated: true)
            })
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let bounds = UIScreen.main.bounds
        let width = (bounds.width - 60) / 2
        return CGSize(width: width, height: width * 1.5)
    }
    
}

extension CharacterViewController: BottomSheetDelegate {
    func bottomSheetDidDismissed(filters: [String]) {
        characterListViewModel.applyFilter(filters: filters)
    }
}

//
//  GGCharacterViewController.swift
//  GGRickMorty
//
//  Created by Kazuha on 29/04/23.
//

import UIKit
import FittedSheets

final class GGCharacterViewController: UIViewController {
    
    // MARK: Properties
    private let characterListViewModel = GGCharacterListViewModel()
    private let searchController = UISearchController(searchResultsController: nil)
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .medium)
        spinner.hidesWhenStopped = true
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        layout.minimumLineSpacing = 25
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.alpha = 0
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(GGCharacterCollectionViewCell.self, forCellWithReuseIdentifier: GGCharacterCollectionViewCell.identifier)
        return collectionView
    }()
    private let noDataView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        
        let label = UILabel()
        label.text = "No Data Available"
        label.textColor = .label
        label.textAlignment = .center
        label.font = UIFont.SFProRounded(style: .semibold, size: 30)
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)

        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        return view
    }()
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        spinner.startAnimating()
        fetchAllCharacters()
    }
    
    // MARK: - Private Methods
    private func setupView() {
        title = "Character"
        view.backgroundColor = .systemBackground
        collectionView.dataSource = self
        collectionView.delegate = self
        view.addSubviews(collectionView, spinner, noDataView)
        addConstraint()
        setupSearchController()
        setupNavigationItem()
    }
    
    private func setupNavigationItem() {
        /// Add navigation item (right bar button)
        let sliderBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "slider.horizontal.3"), style: .plain, target: self, action: #selector(filterButtonTapped))
        navigationItem.rightBarButtonItem = sliderBarButtonItem
        
        /// Add observer for when tab bar item is tapped
        NotificationCenter.default.addObserver(self, selector: #selector(scrollToTop), name: NSNotification.Name("TabBarItemTapped"), object: nil)
    }
    
    private func setupSearchController() {
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    private func fetchAllCharacters() {
        /// Fetch characters data from API
        characterListViewModel.fetchCharacters() { [weak self] result in
            guard let strongSelf = self else { return }
            switch result {
            case .success:
                DispatchQueue.main.async {
                    strongSelf.spinner.stopAnimating()
                    /// Check if the view models has no data
                    if strongSelf.characterListViewModel.characters.isEmpty {
                        strongSelf.collectionView.backgroundView = strongSelf.noDataView
                    } else {
                        UIView.animate(withDuration: 0.4) {
                            strongSelf.collectionView.alpha = 1
                        }
                    }
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
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
        let controller = GGBottomSheetController()
        let options = SheetOptions(shrinkPresentingViewController: false)
        controller.bottomSheetViewModel.delegate = self
        controller.bottomSheetViewModel.selectedFilters = characterListViewModel.selectedFilters
        let sheetController = SheetViewController(
            controller: controller,
            sizes: [.fixed(hasNotch() ? 490 : 450)], options: options)

        /// The `cornerRadius` of the sheet
        sheetController.cornerRadius = 10

        /// Set the pullbar's background explicitly
        sheetController.pullBarBackgroundColor = UIColor.white

        /// Allow pulling past the maximum height and bounce back. Defaults to true.
        sheetController.allowPullingPastMaxHeight = false

        self.present(sheetController, animated: true, completion: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}

// MARK: - Search
extension GGCharacterViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        characterListViewModel.setIsSearchBarActive(searchController.isActive && !(searchController.searchBar.text?.isEmpty ?? true))
        characterListViewModel.searchForCharacters(with: searchText)
        collectionView.reloadData()
        noDataView.isHidden = searchText.isEmpty || !characterListViewModel.searchedCharacters.isEmpty ? true : false
    }

}

// MARK: - CollectionView
extension GGCharacterViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return characterListViewModel.getNumberOfItems()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GGCharacterCollectionViewCell.identifier, for: indexPath) as? GGCharacterCollectionViewCell else { fatalError("Couldn't find \(GGCharacterCollectionViewCell.identifier)") }
        cell.configureCell(with: characterListViewModel.getCharacter(at: indexPath.row))
        return cell
    }
        
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) {
            /// Animate the cell's `contentView` background color
            UIView.animate(withDuration: 0.1, animations: {
                cell.contentView.backgroundColor = .GGNeonGreen
            }, completion: { _ in
                UIView.animate(withDuration: 0.1) {
                    cell.contentView.backgroundColor = .GGLightGrey
                }
                
                /// Push the `characterDetailViewController`
                let characterDetailVC = GGCharacterDetailViewController()
                characterDetailVC.characterDetailViewModel.character = self.characterListViewModel.characters[indexPath.row]
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

extension GGCharacterViewController: GGBottomSheetDelegate {
    func bottomSheetDidDismissed(filters: [String]) {
        characterListViewModel.applyFilter(filters: filters)
        collectionView.reloadData()
        noDataView.isHidden = characterListViewModel.filteredCharacters.isEmpty ? false : true
    }
}

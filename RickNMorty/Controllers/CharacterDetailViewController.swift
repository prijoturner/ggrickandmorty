//
//  CharacterDetailViewController.swift
//  RickNMorty
//
//  Created by Kazuha on 29/04/23.
//

import UIKit
import Combine

class CharacterDetailViewController: UIViewController {
    
    // MARK: - Properties
    private let viewModel: CharacterDetailViewModel
    private var cancellables = Set<AnyCancellable>()
    private let screenWidth = UIScreen.main.bounds.width
    private var imageViewWidth: CGFloat = 0
    private var imageViewHeight: CGFloat = 0
    private var tableViewHeightConstraint: NSLayoutConstraint!
    private lazy var scrollView = UIFactory.createScrollView()
    private lazy var contentView = UIFactory.createView()
    private lazy var characterImageView = UIFactory.createImageView(contentMode: .scaleToFill, cornerRadius: 10, clipsToBounds: true)
    private lazy var statusImageView = UIFactory.createImageView(contentMode: .scaleToFill, cornerRadius: 10, clipsToBounds: true)
    private lazy var genderImageView = UIFactory.createImageView(contentMode: .scaleToFill, cornerRadius: 10, clipsToBounds: true)
    private lazy var nameLabel = UIFactory.createLabel(fontSize: 24, weight: .semibold, color: .label)
    private lazy var statusLabel = UIFactory.createLabel(fontSize: 20, weight: .regular, color: .label)
    private lazy var genderLabel = UIFactory.createLabel(fontSize: 20, weight: .regular, color: .label)
    private lazy var speciesLabel = UIFactory.createLabel(fontSize: 20, weight: .regular, color: .label)
    private lazy var createdLabel = UIFactory.createLabel(color: .label, lines: 2)
    private lazy var originLabel = UIFactory.createLabel(text: "Origin", fontSize: 20, weight: .semibold, color: .label)
    private lazy var originValueLabel = UIFactory.createLabel(fontSize: 16, weight: .regular, color: .label, lines: 0)
    private lazy var locationLabel = UIFactory.createLabel(text: "Location", fontSize: 20, weight: .semibold, color: .label)
    private lazy var locationValueLabel = UIFactory.createLabel(fontSize: 16, weight: .regular, color: .label, lines: 0)
    private lazy var episodeLabel = UIFactory.createLabel(text: "Episode", fontSize: 20, weight: .semibold, color: .label)
    
    private lazy var tableView = UIFactory.createTableView(
        isScrollEnabled: false,
        cellClass: ListTableViewCell.self,
        cellIdentifier: ListTableViewCell.identifier
    )
    
    // MARK: - Initialization
    init(viewModel: CharacterDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
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
    private func setupViews() {
        view.backgroundColor = .systemBackground
        imageViewWidth = (screenWidth / 2) - 32
        imageViewHeight = imageViewWidth * 1.7
        setupScrollView()
        setupTableView()
        setupNavigationItem()
        contentView.addSubviews(
            characterImageView,
            nameLabel,
            statusLabel,
            genderLabel,
            speciesLabel,
            createdLabel,
            statusImageView,
            genderImageView,
            originLabel,
            originValueLabel,
            locationLabel,
            locationValueLabel,
            episodeLabel,
            tableView
        )
        addConstraint()
    }
    
    private func setupNavigationItem() {
        updateFavoriteButton()
    }
    
    private func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
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
        viewModel.$displayCharacterDetail
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] data in
                self?.title = data.name
                self?.nameLabel.text = data.name
                self?.statusLabel.text = data.status
                self?.genderLabel.text = data.gender
                self?.speciesLabel.text = data.species
                self?.createdLabel.attributedText = data.createdText
                self?.originValueLabel.text = data.origin
                self?.locationValueLabel.text = data.location
                self?.statusImageView.setImage(named: data.statusImageName)
                self?.genderImageView.setImage(named: data.genderImageName)
                self?.characterImageView.fetchImage(from: data.imageURL)
                self?.tableView.reloadData()
                self?.viewModel.checkIfFavorite()
                self?.updateFavoriteButton()
            }
            .store(in: &cancellables)
        
        viewModel.$isFavorite
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.updateFavoriteButton()
            }
            .store(in: &cancellables)
    }
    
    private func addConstraint() {
        NSLayoutConstraint.activate([
            /// `characterImageView` constraints
            characterImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            characterImageView.widthAnchor.constraint(equalToConstant: imageViewWidth),
            characterImageView.heightAnchor.constraint(equalToConstant: 320),
            characterImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16),
            
            /// `nameLabel` constraints
            nameLabel.topAnchor.constraint(equalTo: characterImageView.topAnchor),
            nameLabel.leftAnchor.constraint(equalTo: characterImageView.rightAnchor, constant: 16),
            nameLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 16),
            
            /// `statusLabel` constraints
            statusLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10),
            statusLabel.leftAnchor.constraint(equalTo: characterImageView.rightAnchor, constant: 16),
            
            /// `statusImageView` constraints
            statusImageView.widthAnchor.constraint(equalToConstant: 25),
            statusImageView.heightAnchor.constraint(equalToConstant: 25),
            statusImageView.leftAnchor.constraint(equalTo: statusLabel.rightAnchor, constant: 6),
            statusImageView.centerYAnchor.constraint(equalTo: statusLabel.centerYAnchor),
            
            /// `genderLabel` constraints
            genderLabel.topAnchor.constraint(equalTo: statusLabel.bottomAnchor, constant: 10),
            genderLabel.leftAnchor.constraint(equalTo: characterImageView.rightAnchor, constant: 16),
            
            /// `genderImageView` constraints
            genderImageView.widthAnchor.constraint(equalToConstant: 25),
            genderImageView.heightAnchor.constraint(equalToConstant: 25),
            genderImageView.leftAnchor.constraint(equalTo: genderLabel.rightAnchor, constant: 6),
            genderImageView.centerYAnchor.constraint(equalTo: genderLabel.centerYAnchor),
            
            /// `speciesLabel` constraints
            speciesLabel.topAnchor.constraint(equalTo: genderLabel.bottomAnchor, constant: 10),
            speciesLabel.leftAnchor.constraint(equalTo: characterImageView.rightAnchor, constant: 16),
            
            /// `originLabel` constraints
            originLabel.topAnchor.constraint(equalTo: characterImageView.bottomAnchor, constant: 20),
            originLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16),
            
            /// `originValueLabel` constraints
            originValueLabel.topAnchor.constraint(equalTo: originLabel.bottomAnchor, constant: 10),
            originValueLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16),
            originValueLabel.rightAnchor.constraint(equalTo: locationValueLabel.leftAnchor, constant: 16),
            
            /// `locationLabel` constraints
            locationLabel.topAnchor.constraint(equalTo: characterImageView.bottomAnchor, constant: 20),
            locationLabel.leftAnchor.constraint(equalTo: characterImageView.rightAnchor, constant: 16),
            
            /// `locationValueLabel` label constraints
            locationValueLabel.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 10),
            locationValueLabel.leftAnchor.constraint(equalTo: characterImageView.rightAnchor, constant: 16),
            locationValueLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16),
            
            /// `createdLabel` constraints
            createdLabel.bottomAnchor.constraint(equalTo: characterImageView.bottomAnchor),
            createdLabel.leftAnchor.constraint(equalTo: characterImageView.rightAnchor, constant: 16),
            
            /// `episodeLabel` constraints
            episodeLabel.topAnchor.constraint(equalTo: locationValueLabel.bottomAnchor, constant: 20),
            episodeLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16),
            
            /// `scrollView` constraints
            scrollView.leftAnchor.constraint(equalTo: view.leftAnchor),
            scrollView.rightAnchor.constraint(equalTo: view.rightAnchor),
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            /// `contentView` constraints
            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.leftAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leftAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            
            /// Episodes `tableView` constraints
            tableView.topAnchor.constraint(equalTo: episodeLabel.bottomAnchor, constant: 10),
            tableView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            tableView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16),
            tableView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
        ])
    }
    
    private func updateFavoriteButton() {
        let isFavorite = viewModel.isFavorite
        let systemImage = isFavorite ? "heart.fill" : "heart"
        let button = UIBarButtonItem(
            image: UIImage(systemName: systemImage),
            style: .plain,
            target: self,
            action: #selector(addToFavoriteTapped)
        )
        navigationItem.rightBarButtonItem = button
    }
    
    @objc private func addToFavoriteTapped() {
        viewModel.toggleFavorite { [weak self] success, message in
            guard let self = self else { return }
            
            let feedbackType: UINotificationFeedbackGenerator.FeedbackType = message.contains("removed") ? .warning : .success
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(feedbackType)
            
            showToast(message: message)
        }
    }
    
}

extension CharacterDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfEpisodes()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ListTableViewCell.identifier, for: indexPath) as?  ListTableViewCell else { fatalError("Couldn't find \(ListTableViewCell.identifier)") }
        if let episode = viewModel.episodeURL(at: indexPath.row) {
            cell.configureCell(with: episode)
        }
        return cell
    }
    
}

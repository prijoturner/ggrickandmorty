//
//  GGCharacterDetailViewController.swift
//  GGRickMorty
//
//  Created by Kazuha on 29/04/23.
//

import UIKit

class GGCharacterDetailViewController: UIViewController {
    
    // MARK: - Properties
    public let characterDetailViewModel = GGCharacterDetailViewModel()
    private let screenWidth = UIScreen.main.bounds.width
    private var imageViewWidth: CGFloat = 0
    private var imageViewHeight: CGFloat = 0
    private var tableViewHeightConstraint: NSLayoutConstraint!
    private var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    private var contentView: UIView = {
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        return contentView
    }()
    private let characterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.layer.cornerRadius = 10
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    private let statusImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.layer.cornerRadius = 10
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    private let genderImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.layer.cornerRadius = 10
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.SFProRounded(style: .semibold, size: 24)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let statusLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.SFProRounded(style: .regular, size: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let genderLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.SFProRounded(style: .regular, size: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let speciesLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.SFProRounded(style: .regular, size: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let createdLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let originLabel: UILabel = {
        let label = UILabel()
        label.text = "Origin"
        label.font = UIFont.SFProRounded(style: .semibold, size: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let originValueLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.SFProRounded(style: .regular, size: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    private let locationLabel: UILabel = {
        let label = UILabel()
        label.text = "Location"
        label.font = UIFont.SFProRounded(style: .semibold, size: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let locationValueLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.SFProRounded(style: .regular, size: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    private let episodeLabel: UILabel = {
        let label = UILabel()
        label.text = "Episode"
        label.font = UIFont.SFProRounded(style: .semibold, size: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(GGEpisodesTableViewCell.self, forCellReuseIdentifier: GGEpisodesTableViewCell.identifier)
        return tableView
    }()
    
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
        applyData()
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
        title = characterDetailViewModel.character?.name
        view.backgroundColor = .systemBackground
        imageViewWidth = (screenWidth / 2) - 32
        imageViewHeight = imageViewWidth * 1.7
        setupScrollView()
        setupTableView()
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
    
    private func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isScrollEnabled = false
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 25
        tableView.separatorStyle = .none
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
    
    private func applyData() {
        if let statusImageName = characterDetailViewModel.statusImageName {
            statusImageView.setImage(named: statusImageName)
        }
        if let genderImageName = characterDetailViewModel.genderImageName {
            genderImageView.setImage(named: genderImageName)
        }
        characterDetailViewModel.configure(nameLabel, for: .name)
        characterDetailViewModel.configure(statusLabel, for: .status)
        characterDetailViewModel.configure(genderLabel, for: .gender)
        characterDetailViewModel.configure(createdLabel, for: .created)
        characterDetailViewModel.configure(originValueLabel, for: .origin)
        characterDetailViewModel.configure(locationValueLabel, for: .location)
        characterDetailViewModel.configure(characterImageView)
    }
    
    private func addConstraint() {
        NSLayoutConstraint.activate([
            /// Character image view constraints
            characterImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            characterImageView.widthAnchor.constraint(equalToConstant: imageViewWidth),
            characterImageView.heightAnchor.constraint(equalToConstant: 320),
            characterImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16),
            
            /// Name label constraints
            nameLabel.topAnchor.constraint(equalTo: characterImageView.topAnchor),
            nameLabel.leftAnchor.constraint(equalTo: characterImageView.rightAnchor, constant: 16),
            
            /// Status label constraints
            statusLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10),
            statusLabel.leftAnchor.constraint(equalTo: characterImageView.rightAnchor, constant: 16),
            
            /// Status image view constraints
            statusImageView.widthAnchor.constraint(equalToConstant: 25),
            statusImageView.heightAnchor.constraint(equalToConstant: 25),
            statusImageView.leftAnchor.constraint(equalTo: statusLabel.rightAnchor, constant: 6),
            statusImageView.centerYAnchor.constraint(equalTo: statusLabel.centerYAnchor),
            
            /// Gender label constraints
            genderLabel.topAnchor.constraint(equalTo: statusLabel.bottomAnchor, constant: 10),
            genderLabel.leftAnchor.constraint(equalTo: characterImageView.rightAnchor, constant: 16),
            
            /// Gender image view constraints
            genderImageView.widthAnchor.constraint(equalToConstant: 25),
            genderImageView.heightAnchor.constraint(equalToConstant: 25),
            genderImageView.leftAnchor.constraint(equalTo: genderLabel.rightAnchor, constant: 6),
            genderImageView.centerYAnchor.constraint(equalTo: genderLabel.centerYAnchor),
            
            /// Species label constraints
            speciesLabel.topAnchor.constraint(equalTo: genderLabel.bottomAnchor, constant: 10),
            speciesLabel.leftAnchor.constraint(equalTo: characterImageView.rightAnchor, constant: 16),
            
            /// Origin label constraints
            originLabel.topAnchor.constraint(equalTo: characterImageView.bottomAnchor, constant: 20),
            originLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16),
            
            /// Origin value label constraints
            originValueLabel.topAnchor.constraint(equalTo: originLabel.bottomAnchor, constant: 10),
            originValueLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16),
            originValueLabel.rightAnchor.constraint(equalTo: locationValueLabel.leftAnchor, constant: 16),
            
            /// Location label constraints
            locationLabel.topAnchor.constraint(equalTo: characterImageView.bottomAnchor, constant: 20),
            locationLabel.leftAnchor.constraint(equalTo: characterImageView.rightAnchor, constant: 16),
            
            /// Location value label constraints
            locationValueLabel.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 10),
            locationValueLabel.leftAnchor.constraint(equalTo: characterImageView.rightAnchor, constant: 16),
            locationValueLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16),
            
            /// Created label constraints
            createdLabel.bottomAnchor.constraint(equalTo: characterImageView.bottomAnchor),
            createdLabel.leftAnchor.constraint(equalTo: characterImageView.rightAnchor, constant: 16),
            
            /// Episode label constraints
            episodeLabel.topAnchor.constraint(equalTo: locationValueLabel.bottomAnchor, constant: 20),
            episodeLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16),
            
            /// Scroll view constraints
            scrollView.leftAnchor.constraint(equalTo: view.leftAnchor),
            scrollView.rightAnchor.constraint(equalTo: view.rightAnchor),
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            /// Content view constraints
            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.leftAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leftAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            
            /// Episodes table view constraints
            tableView.topAnchor.constraint(equalTo: episodeLabel.bottomAnchor, constant: 10),
            tableView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            tableView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
        ])
    }
    
}

extension GGCharacterDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return characterDetailViewModel.character?.episode.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: GGEpisodesTableViewCell.identifier, for: indexPath) as?  GGEpisodesTableViewCell else { fatalError("Couldn't find \(GGEpisodesTableViewCell.identifier)") }
        guard let episode = characterDetailViewModel.character?.episode[indexPath.row] else { return UITableViewCell() }
        cell.configureCell(with: episode)
        return cell
    }
    
}

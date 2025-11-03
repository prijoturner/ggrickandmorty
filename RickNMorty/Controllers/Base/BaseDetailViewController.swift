//
//  BaseDetailViewController.swift
//  RickNMorty
//
//  Created by Kazuha on 30/04/23.
//

import UIKit

class BaseDetailViewController: UIViewController {
    
    // MARK: - Properties
    public var tableViewHeightConstraint: NSLayoutConstraint!
    
    public lazy var scrollView = UIFactory.createScrollView()
    public lazy var contentView = UIFactory.createView()
    
    public lazy var titleLabel: UILabel = {
        let label = UIFactory.createLabel(fontSize: 32, weight: .semibold, color: .label)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        return label
    }()
    
    public lazy var headingLabel = UIFactory.createLabel(fontSize: 20, weight: .semibold, color: .label)
    
    public lazy var subHeadingLabel = UIFactory.createLabel(fontSize: 16, weight: .semibold, color: .label, lines: 2)
    
    public lazy var titleForListLabel = UIFactory.createLabel(fontSize: 20, weight: .semibold, color: .label)
    
    public lazy var createdLabel = UIFactory.createLabel(color: .label, lines: 2)
    
    public lazy var tableView = UIFactory.createTableView(
        isScrollEnabled: false,
        cellClass: ListTableViewCell.self,
        cellIdentifier: ListTableViewCell.identifier
    )

    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    // MARK: - Private Methods
    private func setupView() {
        view.backgroundColor = .systemBackground
        setupScrollView()
        contentView.addSubviews(
            titleLabel,
            headingLabel,
            subHeadingLabel,
            titleForListLabel,
            createdLabel,
            tableView
        )
        addConstraint()
    }
    
    private func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
    }
    
    private func addConstraint() {
        NSLayoutConstraint.activate([
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
            
            /// `titleLabel` constraint
            titleLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 21),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 26),
            titleLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -15),
            
            /// `createdLabel` constraint
            createdLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 15),
            createdLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -15),
            
            /// `headingLabel` constraint
            headingLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 50),
            headingLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 21),
            
            /// `subHeadingLabel` constraint
            subHeadingLabel.topAnchor.constraint(equalTo: headingLabel.bottomAnchor, constant: 16),
            subHeadingLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 21),
            
            /// `titleForListLabel` constraint
            titleForListLabel.topAnchor.constraint(equalTo: subHeadingLabel.bottomAnchor, constant: 29),
            titleForListLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 21),
            
            /// `tableView` constraints
            tableView.topAnchor.constraint(equalTo: titleForListLabel.bottomAnchor, constant: 10),
            tableView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            tableView.leftAnchor.constraint(equalTo: titleForListLabel.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            
        ])
    }

}

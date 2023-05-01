//
//  GGBaseDetailViewController.swift
//  GGRickMorty
//
//  Created by Kazuha on 30/04/23.
//

import UIKit

class GGBaseDetailViewController: UIViewController {
    
    // MARK: - Properties
    public var tableViewHeightConstraint: NSLayoutConstraint!
    public var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    public var contentView: UIView = {
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        return contentView
    }()
    public let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .SFProRounded(style: .semibold, size: 32)
        label.textColor = .label
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    public let headingLabel: UILabel = {
        let label = UILabel()
        label.font = .SFProRounded(style: .semibold, size: 20)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    public let subHeadingLabel: UILabel = {
        let label = UILabel()
        label.font = .SFProRounded(style: .semibold, size: 16)
        label.numberOfLines = 2
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    public let titleForListLabel: UILabel = {
        let label = UILabel()
        label.font = .SFProRounded(style: .semibold, size: 20)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    public let createdLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    public let tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(GGListTableViewCell.self, forCellReuseIdentifier: GGListTableViewCell.identifier)
        tableView.isScrollEnabled = false
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 25
        tableView.separatorStyle = .none
        return tableView
    }()

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

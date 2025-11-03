//
//  BaseRectangleListViewController.swift
//  RickNMorty
//
//  Created by Kazuha on 01/05/23.
//

import UIKit

class BaseRectangleListViewController: UIViewController {
    
    // MARK: - Properties
    public let searchController = UISearchController(searchResultsController: nil)
    public lazy var spinner = UIFactory.createActivityIndicator()
    
    public lazy var tableView = UIFactory.createTableView(
        alpha: 0,
        cellClass: RectangleListTableViewCell.self,
        cellIdentifier: RectangleListTableViewCell.identifier
    )
    
    public lazy var noDataView = UIFactory.createNoDataView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        spinner.startAnimating()
        setupView()
    }
    
    // MARK: - Private Methods
    private func setupView() {
        view.backgroundColor = .systemBackground
        view.addSubviews(tableView, spinner, noDataView)
        addConstraint()
        
        /// Add observer for when tab bar item is tapped after scrolling
        NotificationCenter.default.addObserver(self, selector: #selector(scrollToTop), name: NSNotification.Name("TabBarItemTapped"), object: nil)
    }
    
    private func addConstraint() {
        NSLayoutConstraint.activate([
            /// `spinner` constraints
            spinner.widthAnchor.constraint(equalToConstant: 100),
            spinner.heightAnchor.constraint(equalToConstant: 100),
            spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            /// `tableView` constraints
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            
            /// `noDataView` constraints
            noDataView.topAnchor.constraint(equalTo: tableView.topAnchor),
            noDataView.bottomAnchor.constraint(equalTo: tableView.bottomAnchor),
            noDataView.leftAnchor.constraint(equalTo: tableView.leftAnchor),
            noDataView.rightAnchor.constraint(equalTo: tableView.rightAnchor),
        ])
    }
    
    @objc private func scrollToTop() {
        scrollToTop(of: tableView)
    }
    
}

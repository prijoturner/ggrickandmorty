//
//  GGBaseRectangleListViewController.swift
//  GGRickMorty
//
//  Created by Kazuha on 01/05/23.
//

import UIKit

class GGBaseRectangleListViewController: UIViewController {
    
    // MARK: - Properties
    public let searchController = UISearchController(searchResultsController: nil)
    public let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .medium)
        spinner.hidesWhenStopped = true
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()
    public let tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.alpha = 0
        tableView.separatorStyle = .none
        tableView.register(GGRectangleListTableViewCell.self, forCellReuseIdentifier: GGRectangleListTableViewCell.identifier)
        return tableView
    }()
    public let noDataView: UIView = {
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

//
//  GGLocationDetailViewController.swift
//  GGRickMorty
//
//  Created by Kazuha on 30/04/23.
//

import UIKit

class GGLocationDetailViewController: GGBaseDetailViewController {
    
    //MARK: - Properties
    public let locationDetailViewModel = GGLocationDetailViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        locationDetailViewModel.applyData(titleLabel: titleLabel,
                                          headingLabel: headingLabel,
                                          subHeadingLabel: subHeadingLabel,
                                          createdLabel: createdLabel,
                                          titleForListLabel: titleForListLabel)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.layoutIfNeeded()
        let contentSize = tableView.contentSize
        let newHeight = contentSize.height
        tableViewHeightConstraint?.constant = newHeight
    }
    
    private func setupView() {
        title = locationDetailViewModel.location?.name
        setupTableView()
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

}

extension GGLocationDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locationDetailViewModel.location?.residents.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: GGListTableViewCell.identifier, for: indexPath) as?  GGListTableViewCell else { fatalError("Couldn't find \(GGListTableViewCell.identifier)") }
        guard let episode = locationDetailViewModel.location?.residents[indexPath.row] else { return UITableViewCell() }
        cell.configureCell(with: episode)
        return cell
    }
    
}

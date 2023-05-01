//
//  GGBottomSheetController.swift
//  GGRickMorty
//
//  Created by Kazuha on 29/04/23.
//

import UIKit
import TagListView

final class GGBottomSheetController: UIViewController {
    
    // MARK: - Properties
    public let bottomSheetViewModel = GGBottomSheetViewModel()
    public var delegate: GGBottomSheetDelegate?
    private lazy var applyButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .GGBlue
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Apply", for: .normal)
        button.titleLabel?.font = .SFProRounded(style: .semibold, size: 20)
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(applyButtonTapped), for: .touchUpInside)
        return button
    }()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Filter"
        label.font = .SFProRounded(style: .semibold, size: 30)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let statusLabel: UILabel = {
        let label = UILabel()
        label.text = "Status"
        label.font = .SFProRounded(style: .semibold, size: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let statusFilterView: TagListView = {
        let filtersView = TagListView()
        filtersView.textFont = .SFProRounded(style: .semibold, size: 14)
        filtersView.textColor = .GGGrey
        filtersView.selectedTextColor = .GGBlue
        filtersView.borderWidth = 1
        filtersView.borderColor = .GGGrey
        filtersView.tagBackgroundColor = .systemBackground
        filtersView.cornerRadius = 10
        filtersView.marginX = 10
        filtersView.paddingX = 10
        filtersView.paddingY = 10
        filtersView.translatesAutoresizingMaskIntoConstraints = false
        return filtersView
    }()
    private let speciesLabel: UILabel = {
        let label = UILabel()
        label.text = "Species"
        label.font = .SFProRounded(style: .semibold, size: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let speciesFilterView: TagListView = {
        let filtersView = TagListView()
        filtersView.textFont = .SFProRounded(style: .semibold, size: 14)
        filtersView.textColor = .GGGrey
        filtersView.selectedTextColor = .GGBlue
        filtersView.borderWidth = 1
        filtersView.borderColor = .GGGrey
        filtersView.tagBackgroundColor = .systemBackground
        filtersView.cornerRadius = 10
        filtersView.marginX = 10
        filtersView.marginY = 10
        filtersView.paddingX = 10
        filtersView.paddingY = 10
        filtersView.translatesAutoresizingMaskIntoConstraints = false
        return filtersView
    }()
    private let genderLabel: UILabel = {
        let label = UILabel()
        label.text = "Gender"
        label.font = .SFProRounded(style: .semibold, size: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let genderFilterView: TagListView = {
        let filtersView = TagListView()
        filtersView.textFont = .SFProRounded(style: .semibold, size: 14)
        filtersView.textColor = .GGGrey
        filtersView.selectedTextColor = .GGBlue
        filtersView.borderWidth = 1
        filtersView.borderColor = .GGGrey
        filtersView.tagBackgroundColor = .systemBackground
        filtersView.cornerRadius = 10
        filtersView.marginX = 10
        filtersView.paddingX = 10
        filtersView.paddingY = 10
        filtersView.translatesAutoresizingMaskIntoConstraints = false
        return filtersView
    }()

    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    // MARK: - Private Methods
    private func setupView() {
        view.backgroundColor = .systemBackground
        setupFiltersViewViewModel()
        view.addSubviews(
            titleLabel,
            statusLabel,
            statusFilterView,
            speciesLabel,
            speciesFilterView,
            genderLabel,
            genderFilterView,
            applyButton
        )
        addConstraint()
    }
    
    private func setupFiltersViewViewModel() {
        /// Setup filters view
        bottomSheetViewModel.setupFiltersView(statusFilterView, tags: bottomSheetViewModel.statusTags)
        bottomSheetViewModel.setupFiltersView(speciesFilterView, tags: bottomSheetViewModel.speciesTags)
        bottomSheetViewModel.setupFiltersView(genderFilterView, tags: bottomSheetViewModel.genderTags)
        
        /// Apply selected filters value
        bottomSheetViewModel.applySelectedFilter(to: statusFilterView, selectedFilters: bottomSheetViewModel.selectedFilters)
        bottomSheetViewModel.applySelectedFilter(to: speciesFilterView, selectedFilters: bottomSheetViewModel.selectedFilters)
        bottomSheetViewModel.applySelectedFilter(to: genderFilterView, selectedFilters: bottomSheetViewModel.selectedFilters)
    }
    
    private func addConstraint() {
        NSLayoutConstraint.activate([
            /// `titleLabel` constraints
            titleLabel.heightAnchor.constraint(equalToConstant: 37),
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 17),
            titleLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 23),
            
            /// `statusLabel` constraints
            statusLabel.heightAnchor.constraint(equalToConstant: 27),
            statusLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            statusLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 23),
            
            /// `statusFilterView` constraints
            statusFilterView.heightAnchor.constraint(equalToConstant: 35),
            statusFilterView.topAnchor.constraint(equalTo: statusLabel.bottomAnchor, constant: 9),
            statusFilterView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 23),
            statusFilterView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -23),
            
            /// `speciesLabel` constraints
            speciesLabel.heightAnchor.constraint(equalToConstant: 27),
            speciesLabel.topAnchor.constraint(equalTo: statusFilterView.bottomAnchor, constant: 15),
            speciesLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 23),
            
            /// `speciesFilterView` constraints
            speciesFilterView.heightAnchor.constraint(equalToConstant: 70),
            speciesFilterView.topAnchor.constraint(equalTo: speciesLabel.bottomAnchor, constant: 9),
            speciesFilterView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 23),
            speciesFilterView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -23),
            
            /// `genderLabel` constraints
            genderLabel.heightAnchor.constraint(equalToConstant: 27),
            genderLabel.topAnchor.constraint(equalTo: speciesFilterView.bottomAnchor, constant: 20),
            genderLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 23),
            
            /// `genderFilterView` constraints
            genderFilterView.heightAnchor.constraint(equalToConstant: 35),
            genderFilterView.topAnchor.constraint(equalTo: genderLabel.bottomAnchor, constant: 9),
            genderFilterView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 23),
            genderFilterView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -23),
            
            /// `applyButton` constraints
            applyButton.heightAnchor.constraint(equalToConstant: 50),
            applyButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -11),
            applyButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 32),
            applyButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -32),
            applyButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }
    
    @objc private func applyButtonTapped() {
        bottomSheetViewModel.applyButtonTapped()
        self.dismiss(animated: true)
    }

}

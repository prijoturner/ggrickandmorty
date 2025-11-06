//
//  FilterCharacterSheetContent.swift
//  RickNMorty
//
//  Created by Kazuha on 29/04/23.
//

import UIKit
import TagListView

final class FilterCharacterSheetContent: UIViewController {
    
    // MARK: - Properties
    public let bottomSheetViewModel = BottomSheetViewModel()
    public var delegate: BottomSheetDelegate?
    
    private lazy var applyButton: UIButton = {
        let button = UIFactory.createTextButton(
            title: "Apply",
            fontSize: 20,
            weight: .semibold,
            backgroundColor: .appAccent,
            cornerRadius: 10
        )
        button.addTarget(self, action: #selector(applyButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var titleLabel = UIFactory.createLabel(text: "Filter", fontSize: 30, weight: .semibold, color: .label)
    private lazy var statusLabel = UIFactory.createLabel(text: "Status", fontSize: 20, weight: .semibold, color: .label)
    private let statusFilterView: TagListView = {
        let filtersView = TagListView()
        filtersView.textFont = .SFProRounded(style: .semibold, size: 14)
        filtersView.textColor = .appGrey
        filtersView.selectedTextColor = .appAccent
        filtersView.borderWidth = 1
        filtersView.borderColor = .appGrey
        filtersView.tagBackgroundColor = .systemBackground
        filtersView.cornerRadius = 10
        filtersView.marginX = 10
        filtersView.paddingX = 10
        filtersView.paddingY = 10
        filtersView.translatesAutoresizingMaskIntoConstraints = false
        return filtersView
    }()
    private lazy var speciesLabel = UIFactory.createLabel(text: "Species", fontSize: 20, weight: .semibold, color: .label)
    private let speciesFilterView: TagListView = {
        let filtersView = TagListView()
        filtersView.textFont = .SFProRounded(style: .semibold, size: 14)
        filtersView.textColor = .appGrey
        filtersView.selectedTextColor = .appAccent
        filtersView.borderWidth = 1
        filtersView.borderColor = .appGrey
        filtersView.tagBackgroundColor = .systemBackground
        filtersView.cornerRadius = 10
        filtersView.marginX = 10
        filtersView.marginY = 10
        filtersView.paddingX = 10
        filtersView.paddingY = 10
        filtersView.translatesAutoresizingMaskIntoConstraints = false
        return filtersView
    }()
    private lazy var genderLabel = UIFactory.createLabel(text: "Gender", fontSize: 20, weight: .semibold, color: .label)
    private let genderFilterView: TagListView = {
        let filtersView = TagListView()
        filtersView.textFont = .SFProRounded(style: .semibold, size: 14)
        filtersView.textColor = .appGrey
        filtersView.selectedTextColor = .appAccent
        filtersView.borderWidth = 1
        filtersView.borderColor = .appGrey
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updatePreferredContentSize()
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
    
    private func updatePreferredContentSize() {
        view.layoutIfNeeded()
        let contentHeight = calculateContentHeight()
        preferredContentSize = CGSize(width: view.bounds.width, height: contentHeight)
    }
    
    private func calculateContentHeight() -> CGFloat {
        var height: CGFloat = 0
        
        // Top padding grabber and spacing
        height += 16
        
        // Title
        height += titleLabel.frame.height + 16
        
        // Status section
        height += statusLabel.frame.height
        height += 8
        height += statusFilterView.intrinsicContentSize.height
        height += 16
        
        // Species section
        height += speciesLabel.frame.height
        height += 8
        height += speciesFilterView.intrinsicContentSize.height
        height += 16
        
        // Gender section
        height += genderLabel.frame.height
        height += 8
        height += genderFilterView.intrinsicContentSize.height
        height += 32
        
        // Apply button
        height += 42
        height += 16
        
        return height
    }
    
    private func addConstraint() {
        NSLayoutConstraint.activate([
            /// `titleLabel` constraints
            titleLabel.heightAnchor.constraint(equalToConstant: 37),
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 16),
            titleLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24),
            
            /// `statusLabel` constraints
            statusLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            statusLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24),
            
            /// `statusFilterView` constraints
            statusFilterView.topAnchor.constraint(equalTo: statusLabel.bottomAnchor, constant: 8),
            statusFilterView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24),
            statusFilterView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -24),
            
            /// `speciesLabel` constraints
            speciesLabel.topAnchor.constraint(equalTo: statusFilterView.bottomAnchor, constant: 16),
            speciesLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24),
            
            /// `speciesFilterView` constraints
            speciesFilterView.topAnchor.constraint(equalTo: speciesLabel.bottomAnchor, constant: 8),
            speciesFilterView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24),
            speciesFilterView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -24),
            
            /// `genderLabel` constraints
            genderLabel.topAnchor.constraint(equalTo: speciesFilterView.bottomAnchor, constant: 16),
            genderLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24),
            
            /// `genderFilterView` constraints
            genderFilterView.topAnchor.constraint(equalTo: genderLabel.bottomAnchor, constant: 8),
            genderFilterView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24),
            genderFilterView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -24),
            
            /// `applyButton` constraints
            applyButton.heightAnchor.constraint(equalToConstant: 42),
            applyButton.topAnchor.constraint(equalTo: genderFilterView.bottomAnchor, constant: 32),
            applyButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24),
            applyButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -24),
            applyButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
        ])
    }
    
    @objc private func applyButtonTapped() {
        bottomSheetViewModel.applyButtonTapped()
        self.dismiss(animated: true)
    }

}

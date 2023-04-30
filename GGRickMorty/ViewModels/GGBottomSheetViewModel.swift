//
//  GGBottomSheetViewModel.swift
//  GGRickMorty
//
//  Created by Kazuha on 29/04/23.
//

import Foundation
import TagListView

protocol GGBottomSheetDelegate: AnyObject {
    func bottomSheetDidDismissed(filters: [String])
}

final class GGBottomSheetViewModel {
    
    // MARK: - Properties
    public var selectedFilters: [String] = []
    public weak var delegate: GGBottomSheetDelegate?
    public let statusTags = ["Alive", "Dead", "Unknown"]
    public let speciesTags = ["Alien", "Animal", "Mythological Creature", "Human"]
    public let genderTags = ["Male", "Female", "Genderless", "Unknown"]
    
    // MARK: - Public Methods
    public func setupFiltersView(_ filtersView: TagListView, tags: [String]) {
        filtersView.delegate = self
        filtersView.addTags(tags)
    }
    
    public func applySelectedFilter(to filterView: TagListView, selectedFilters: [String]) {
        if let selectedTagView = filterView.tagViews.first(where: { selectedFilters.contains($0.titleLabel?.text ?? "") }) {
            selectedTagView.borderColor = .GGBlue
            selectedTagView.isSelected = true
        }
    }
    
    public func applyButtonTapped() {
        delegate?.bottomSheetDidDismissed(filters: selectedFilters)
    }
    
}

extension GGBottomSheetViewModel: TagListViewDelegate {
    func tagPressed(_ title: String, tagView: TagView, sender: TagListView) {
        /// Deselect the previously selected filters in the same FiltersView and remove them from selected filters
        let selectedTags = sender.selectedTags()
        for tag in selectedTags {
            if tag != tagView {
                tag.isSelected = false
                tag.borderColor = .lightGray
                selectedFilters.removeAll(where: { $0 == tag.titleLabel?.text })
            }
        }
        /// Toggle the selection state of the pressed tag
        tagView.isSelected = !tagView.isSelected
        tagView.borderColor = tagView.isSelected ? .GGBlue : .lightGray
        
        /// Add or remove the pressed tag from the selected filters
        if tagView.isSelected {
            selectedFilters.append(title)
        } else {
            selectedFilters.removeAll(where: { $0 == title })
        }
    }
}

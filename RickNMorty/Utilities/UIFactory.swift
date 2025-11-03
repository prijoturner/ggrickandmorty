//
//  UIFactory.swift
//  RickNMorty
//
//  Created by Kazuha on 31/10/25.
//

import UIKit

struct UIFactory {

    // MARK: - Label
    static func createLabel(
        text: String = "",
        fontSize: CGFloat = 18,
        weight: UIFont.SFProRoundedStyle = .regular,
        alpha: Double = 1,
        color: UIColor = .white,
        lines: Int = 0,
        alignment: NSTextAlignment = .left,
        isHidden: Bool = false
    ) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textColor = color
        label.font = {
            switch weight {
            case .regular:
                return .SFProRounded(style: .regular, size: fontSize)
            case .semibold:
                return .SFProRounded(style: .semibold, size: fontSize)
            case .bold:
                return .SFProRounded(style: .bold, size: fontSize)
            }
        }()
        label.textAlignment = alignment
        label.alpha = alpha
        label.numberOfLines = lines
        label.isHidden = isHidden
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }

    // MARK: - Button
    static func createButton(withImage imageName: String, tint: UIColor = .white) -> UIButton {
        let button = UIButton()
        button.setImage(UIImage(named: imageName), for: .normal)
        button.backgroundColor = .clear
        button.tintColor = tint
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }

    static func createTextButton(
        title: String = "",
        fontSize: CGFloat = 12,
        weight: UIFont.SFProRoundedStyle = .regular,
        titleColor: UIColor = .white,
        backgroundColor: UIColor = .clear,
        cornerRadius: CGFloat = 5,
        borderColor: UIColor? = .clear,
        borderWidth: CGFloat = 0
    ) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.setTitleColor(titleColor, for: .normal)
        button.titleLabel?.font = {
            switch weight {
            case .regular:
                return .SFProRounded(style: .regular, size: fontSize)
            case .semibold:
                return .SFProRounded(style: .semibold, size: fontSize)
            case .bold:
                return .SFProRounded(style: .bold, size: fontSize)
            }
        }()
        button.backgroundColor = backgroundColor
        button.layer.cornerRadius = cornerRadius
        if let borderColor = borderColor {
            button.layer.borderColor = borderColor.cgColor
            button.layer.borderWidth = borderWidth
        }
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }
    
    // MARK: - Views
    static func createView(backgroundColor: UIColor = .clear, alpha: CGFloat = 1.0, cornerRadius: CGFloat = 0.0) -> UIView {
        let view = UIView()
        view.backgroundColor = backgroundColor
        view.alpha = alpha
        view.layer.cornerRadius = cornerRadius
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
    
    static func createStackView(axis: NSLayoutConstraint.Axis = .horizontal, alignment: UIStackView.Alignment = .leading, spacing: CGFloat, distribution: UIStackView.Distribution = .fill) -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = axis
        stackView.alignment = alignment
        stackView.spacing = spacing
        stackView.distribution = distribution
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }
    
    static func createActivityIndicator(style: UIActivityIndicatorView.Style = .medium, color: UIColor = .gray) -> UIActivityIndicatorView {
        let indicator = UIActivityIndicatorView(style: style)
        indicator.color = color
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }
    
    static func createRefreshControl(
        tintColor: UIColor = UIColor.red,
        target: Any?,
        action: Selector
    ) -> UIRefreshControl {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = tintColor
        refreshControl.addTarget(target, action: action, for: .valueChanged)
        return refreshControl
    }
    
    // MARK: - Collection View
    static func createCollectionView(
        layout: UICollectionViewLayout,
        backgroundColor: UIColor = .systemBackground,
        alpha: CGFloat = 1.0,
        cellClass: AnyClass,
        cellIdentifier: String
    ) -> UICollectionView {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = backgroundColor
        collectionView.alpha = alpha
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(cellClass, forCellWithReuseIdentifier: cellIdentifier)
        return collectionView
    }
    
    static func createFlowLayout(
        scrollDirection: UICollectionView.ScrollDirection = .vertical,
        sectionInset: UIEdgeInsets = .zero,
        minimumLineSpacing: CGFloat = 0,
        minimumInteritemSpacing: CGFloat = 0
    ) -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = scrollDirection
        layout.sectionInset = sectionInset
        layout.minimumLineSpacing = minimumLineSpacing
        layout.minimumInteritemSpacing = minimumInteritemSpacing
        return layout
    }
    
    // MARK: - Empty State View
    static func createNoDataView(
        message: String = "No Data Available",
        fontSize: CGFloat = 30,
        weight: UIFont.SFProRoundedStyle = .semibold,
        textColor: UIColor = .label,
        backgroundColor: UIColor = .systemBackground
    ) -> UIView {
        let view = UIView()
        view.backgroundColor = backgroundColor
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        
        let label = createLabel(
            text: message,
            fontSize: fontSize,
            weight: weight,
            color: textColor,
            alignment: .center
        )
        view.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        return view
    }
    
    // MARK: - Table View
    static func createTableView(
        style: UITableView.Style = .plain,
        separatorStyle: UITableViewCell.SeparatorStyle = .none,
        backgroundColor: UIColor = .systemBackground,
        alpha: CGFloat = 1.0,
        isScrollEnabled: Bool = true,
        rowHeight: CGFloat = UITableView.automaticDimension,
        estimatedRowHeight: CGFloat = 25,
        cellClass: AnyClass? = nil,
        cellIdentifier: String? = nil
    ) -> UITableView {
        let tableView = UITableView(frame: .zero, style: style)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = separatorStyle
        tableView.backgroundColor = backgroundColor
        tableView.alpha = alpha
        tableView.isScrollEnabled = isScrollEnabled
        tableView.rowHeight = rowHeight
        tableView.estimatedRowHeight = estimatedRowHeight
        
        if let cellClass = cellClass, let identifier = cellIdentifier {
            tableView.register(cellClass, forCellReuseIdentifier: identifier)
        }
        
        return tableView
    }
    
    // MARK: - Scroll View
    static func createScrollView() -> UIScrollView {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }
    
    // MARK: - Image View
    static func createImageView(
        contentMode: UIView.ContentMode = .scaleAspectFill,
        cornerRadius: CGFloat = 0,
        clipsToBounds: Bool = false
    ) -> UIImageView {
        let imageView = UIImageView()
        imageView.contentMode = contentMode
        imageView.layer.cornerRadius = cornerRadius
        imageView.clipsToBounds = clipsToBounds
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }
    
}

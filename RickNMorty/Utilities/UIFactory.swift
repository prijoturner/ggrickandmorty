//
//  UIFactory.swift
//  RickNMorty
//
//  Created by Kazuha on 31/10/25.
//

import UIKit

/// A factory struct that provides convenient methods for creating pre-configured UI components.
///
/// `UIFactory` centralizes UI element creation with consistent styling and configuration,
/// reducing boilerplate code and ensuring UI consistency across the application.
///
/// ## Topics
///
/// ### Creating Labels
/// - ``createLabel(text:fontSize:weight:alpha:color:lines:alignment:isHidden:)``
///
/// ### Creating Buttons
/// - ``createButton(withImage:tint:)``
/// - ``createTextButton(title:fontSize:weight:titleColor:backgroundColor:cornerRadius:borderColor:borderWidth:)``
///
/// ### Creating Views
/// - ``createView(backgroundColor:alpha:cornerRadius:)``
/// - ``createStackView(axis:alignment:spacing:distribution:)``
/// - ``createActivityIndicator(style:color:)``
/// - ``createRefreshControl(tintColor:target:action:)``
/// - ``createNoDataView(message:fontSize:weight:textColor:backgroundColor:)``
///
/// ### Creating Collection Views
/// - ``createCollectionView(layout:backgroundColor:alpha:cellClass:cellIdentifier:)``
/// - ``createFlowLayout(scrollDirection:sectionInset:minimumLineSpacing:minimumInteritemSpacing:)``
///
/// ### Creating Table Views
/// - ``createTableView(style:separatorStyle:backgroundColor:alpha:isScrollEnabled:rowHeight:estimatedRowHeight:cellClass:cellIdentifier:)``
///
/// ### Creating Other Views
/// - ``createScrollView()``
/// - ``createImageView(contentMode:cornerRadius:clipsToBounds:)``
struct UIFactory {

    // MARK: - Label
    
    /// Creates a pre-configured UILabel with customizable properties.
    ///
    /// - Parameters:
    ///   - text: The text to display in the label. Default is empty string.
    ///   - fontSize: The font size for the label text. Default is 18.
    ///   - weight: The font weight style from SF Pro Rounded. Default is `.regular`.
    ///   - alpha: The opacity of the label. Default is 1.0 (fully opaque).
    ///   - color: The text color. Default is `.white`.
    ///   - lines: The maximum number of lines. Use 0 for unlimited. Default is 0.
    ///   - alignment: The text alignment. Default is `.left`.
    ///   - isHidden: Whether the label should be hidden initially. Default is `false`.
    /// - Returns: A configured `UILabel` instance with `translatesAutoresizingMaskIntoConstraints` set to `false`.
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
    
    /// Creates a button with an image.
    ///
    /// - Parameters:
    ///   - imageName: The name of the image asset to use for the button.
    ///   - tint: The tint color for the button image. Default is `.white`.
    /// - Returns: A configured `UIButton` with a clear background and the specified image.
    static func createButton(withImage imageName: String, tint: UIColor = .white) -> UIButton {
        let button = UIButton()
        button.setImage(UIImage(named: imageName), for: .normal)
        button.backgroundColor = .clear
        button.tintColor = tint
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }

    /// Creates a button with text and customizable styling.
    ///
    /// - Parameters:
    ///   - title: The button title text. Default is empty string.
    ///   - fontSize: The font size for the button title. Default is 12.
    ///   - weight: The font weight style from SF Pro Rounded. Default is `.regular`.
    ///   - titleColor: The color of the button title. Default is `.white`.
    ///   - backgroundColor: The background color of the button. Default is `.clear`.
    ///   - cornerRadius: The corner radius for rounded corners. Default is 5.
    ///   - borderColor: The border color. Pass `nil` for no border. Default is `.clear`.
    ///   - borderWidth: The width of the border. Default is 0.
    /// - Returns: A configured `UIButton` with the specified styling properties.
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
    
    /// Creates a basic UIView with customizable properties.
    ///
    /// - Parameters:
    ///   - backgroundColor: The background color of the view. Default is `.clear`.
    ///   - alpha: The opacity of the view. Default is 1.0 (fully opaque).
    ///   - cornerRadius: The corner radius for rounded corners. Default is 0.0.
    ///   - borderColor: The color of the border. Default is `clear`.
    ///   - borderWidth: The size of the border. Default is 0
    ///   - isHidden: Whether the view is initially hidden. Default is `false`
    /// - Returns: A configured `UIView` instance.
    static func createView(
        backgroundColor: UIColor = .clear,
        alpha: CGFloat = 1.0,
        cornerRadius: CGFloat = 0.0,
        borderColor: CGColor = UIColor.clear.cgColor,
        borderWidth: CGFloat = 0.0,
        isHidden: Bool = false
    ) -> UIView {
        let view = UIView()
        view.backgroundColor = backgroundColor
        view.alpha = alpha
        view.layer.cornerRadius = cornerRadius
        view.layer.borderColor = borderColor
        view.layer.borderWidth = borderWidth
        view.isHidden = isHidden
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
    
    /// Creates a UIStackView with customizable layout properties.
    ///
    /// - Parameters:
    ///   - axis: The axis along which arranged views are laid out. Default is `.horizontal`.
    ///   - alignment: The alignment of arranged subviews perpendicular to the stack view's axis. Default is `.leading`.
    ///   - spacing: The spacing between arranged subviews.
    ///   - distribution: The distribution of arranged subviews along the stack view's axis. Default is `.fill`.
    /// - Returns: A configured `UIStackView` instance.
    static func createStackView(axis: NSLayoutConstraint.Axis = .horizontal, alignment: UIStackView.Alignment = .leading, spacing: CGFloat, distribution: UIStackView.Distribution = .fill) -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = axis
        stackView.alignment = alignment
        stackView.spacing = spacing
        stackView.distribution = distribution
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }
    
    /// Creates an activity indicator for loading states.
    ///
    /// - Parameters:
    ///   - style: The style of the activity indicator. Default is `.medium`.
    ///   - color: The color of the activity indicator. Default is `.gray`.
    /// - Returns: A configured `UIActivityIndicatorView` that hides when stopped.
    static func createActivityIndicator(style: UIActivityIndicatorView.Style = .medium, color: UIColor = .gray) -> UIActivityIndicatorView {
        let indicator = UIActivityIndicatorView(style: style)
        indicator.color = color
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }
    
    /// Creates a refresh control for pull-to-refresh functionality.
    ///
    /// - Parameters:
    ///   - tintColor: The tint color of the refresh control. Default is `.red`.
    ///   - target: The target object that receives the action message.
    ///   - action: The action selector to invoke when the refresh control is triggered.
    /// - Returns: A configured `UIRefreshControl` instance.
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
    
    /// Creates a UICollectionView with the specified layout and configuration.
    ///
    /// - Parameters:
    ///   - layout: The layout object to use for organizing collection view items.
    ///   - backgroundColor: The background color of the collection view. Default is `.systemBackground`.
    ///   - alpha: The opacity of the collection view. Default is 1.0.
    ///   - cellClass: The class to register for collection view cells.
    ///   - cellIdentifier: The reuse identifier for the cell class.
    /// - Returns: A configured `UICollectionView` with the specified cell class registered.
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
    
    /// Creates a UICollectionViewFlowLayout with customizable properties.
    ///
    /// - Parameters:
    ///   - scrollDirection: The scroll direction of the collection view. Default is `.vertical`.
    ///   - sectionInset: The margins for the section. Default is `.zero`.
    ///   - minimumLineSpacing: The minimum spacing between lines. Default is 0.
    ///   - minimumInteritemSpacing: The minimum spacing between items. Default is 0.
    /// - Returns: A configured `UICollectionViewFlowLayout` instance.
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
    
    /// Creates an empty state view to display when no data is available.
    ///
    /// The view includes a centered image and message label.
    ///
    /// - Parameters:
    ///   - message: The message to display. Default is "No Data Available".
    ///   - fontSize: The font size for the message. Default is 30.
    ///   - weight: The font weight for the message. Default is `.semibold`.
    ///   - textColor: The color of the message text. Default is `.label`.
    ///   - backgroundColor: The background color of the view. Default is `.systemBackground`.
    /// - Returns: A configured `UIView` with an image and label, initially hidden.
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
        
        let imageView = createImageView(contentMode: .scaleAspectFit, clipsToBounds: true)
        imageView.image = UIImage(named: "tiny_rick")
        imageView.layer.cornerRadius = 8
        view.addSubview(imageView)
        
        let label = createLabel(
            text: message,
            fontSize: fontSize,
            weight: weight,
            color: textColor,
            alignment: .center
        )
        view.addSubview(label)
        
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.bottomAnchor.constraint(equalTo: label.topAnchor, constant: -16),
            imageView.widthAnchor.constraint(equalToConstant: 120),
            imageView.heightAnchor.constraint(equalToConstant: 120),
            
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 120)
        ])
        
        return view
    }
    
    // MARK: - Table View
    
    /// Creates a UITableView with customizable properties.
    ///
    /// - Parameters:
    ///   - style: The style of the table view. Default is `.plain`.
    ///   - separatorStyle: The style of cell separators. Default is `.none`.
    ///   - backgroundColor: The background color of the table view. Default is `.systemBackground`.
    ///   - alpha: The opacity of the table view. Default is 1.0.
    ///   - isScrollEnabled: Whether scrolling is enabled. Default is `true`.
    ///   - rowHeight: The height of rows. Default is `UITableView.automaticDimension`.
    ///   - estimatedRowHeight: The estimated height of rows for calculation. Default is 25.
    ///   - cellClass: The class to register for table view cells. Optional.
    ///   - cellIdentifier: The reuse identifier for the cell class. Optional.
    /// - Returns: A configured `UITableView` instance.
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
    
    /// Creates a basic UIScrollView.
    ///
    /// - Returns: A configured `UIScrollView` instance with `translatesAutoresizingMaskIntoConstraints` set to `false`.
    static func createScrollView() -> UIScrollView {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }
    
    // MARK: - Image View
    
    /// Creates a UIImageView with customizable properties.
    ///
    /// - Parameters:
    ///   - contentMode: The content mode for the image. Default is `.scaleAspectFill`.
    ///   - cornerRadius: The corner radius for rounded corners. Default is 0.
    ///   - clipsToBounds: Whether to clip content to the view's bounds. Default is `false`.
    ///   - isHidden: Whether the image view is initially hidden. Default is `false`
    /// - Returns: A configured `UIImageView` instance.
    static func createImageView(
        contentMode: UIView.ContentMode = .scaleAspectFill,
        cornerRadius: CGFloat = 0,
        clipsToBounds: Bool = false,
        isHidden: Bool = false
    ) -> UIImageView {
        let imageView = UIImageView()
        imageView.contentMode = contentMode
        imageView.layer.cornerRadius = cornerRadius
        imageView.clipsToBounds = clipsToBounds
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isHidden = isHidden
        return imageView
    }
    
}

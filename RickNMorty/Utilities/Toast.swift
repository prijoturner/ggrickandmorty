//
//  Toast.swift
//  RickNMorty
//
//  Created by Kazuha on 05/11/25.
//

import UIKit

/// Defines the vertical position where a toast message should appear on screen.
enum ToastPosition {
    /// Displays the toast at the top of the screen.
    case top
    /// Displays the toast in the center of the screen.
    case center
    /// Displays the toast at the bottom of the screen.
    case bottom
}

/// A lightweight toast notification utility for displaying temporary messages.
///
/// `Toast` provides a simple, non-intrusive way to show brief messages to users
/// with customizable position, duration, and styling. Toast messages automatically
/// fade in and out, and don't require user interaction to dismiss.
///
/// ## Usage Example
/// ```swift
/// let toast = Toast(message: "Item saved successfully", duration: 2.0, position: .bottom)
/// toast.show(in: self)
/// ```
///
/// ## Features
/// - Customizable position (top, center, bottom)
/// - Adjustable display duration
/// - Automatic tab bar detection for proper positioning
/// - Smooth fade in/out animations
/// - Multi-line text support
class Toast {
    
    /// The message text to display in the toast.
    private var message: String
    
    /// How long the toast should remain visible, in seconds.
    private var duration: TimeInterval
    
    /// The vertical position where the toast appears.
    private var position: ToastPosition
    
    /// Additional vertical offset from the position anchor point.
    private var offsetY: CGFloat
    
    /// The background color of the toast.
    private var backgroundColor: UIColor
    
    /// Initializes a new toast notification.
    ///
    /// - Parameters:
    ///   - message: The message text to display. Will be capitalized automatically.
    ///   - duration: The duration the toast should remain visible, in seconds. Default is 3.0.
    ///   - position: The vertical position on screen. Default is `.bottom`.
    ///   - offsetY: Additional vertical offset from the position anchor. Positive values move the toast down for top/center, up for bottom. Default is 0.
    ///   - backgroundColor: The background color of the toast. Default is black.
    init(message: String, duration: TimeInterval = 3.0, position: ToastPosition = .bottom, offsetY: CGFloat = 0, backgroundColor: UIColor = UIColor.black) {
        self.message = message
        self.duration = duration
        self.position = position
        self.offsetY = offsetY
        self.backgroundColor = backgroundColor
    }
    
    /// Displays the toast message in the specified view controller.
    ///
    /// The toast automatically fades in, remains visible for the specified duration,
    /// then fades out and removes itself from the view hierarchy. The toast width
    /// adapts to the message length up to a maximum width. For bottom position,
    /// the toast automatically adjusts for tab bars if present.
    ///
    /// - Parameter viewController: The view controller in which to display the toast.
    func show(in viewController: UIViewController) {
        let toastLabel = UILabel()
        toastLabel.text = message.capitalized
        toastLabel.textColor = .white
        toastLabel.textAlignment = .center
        toastLabel.backgroundColor = backgroundColor
        toastLabel.layer.cornerRadius = 20
        toastLabel.clipsToBounds = true
        toastLabel.numberOfLines = 0
        toastLabel.lineBreakMode = .byWordWrapping
        toastLabel.font = UIFont.SFProRounded(style: .semibold, size: 14)

        let capsuleHeight: CGFloat = 40
        let maxWidth = viewController.view.frame.size.width - 40
        let messageSize = message.size(withAttributes: [.font: toastLabel.font as Any])
        let toastWidth = min(messageSize.width + 24, maxWidth)

        var yPosition: CGFloat = 0
        switch position {
        case .top:
            yPosition = 60 + offsetY
        case .center:
            yPosition = (viewController.view.frame.size.height - capsuleHeight) / 2 + offsetY
        case .bottom:
            if let tabBarHeight = viewController.tabBarController?.tabBar.frame.height {
                yPosition = viewController.view.frame.height - tabBarHeight - offsetY
            } else {
                yPosition = viewController.view.frame.height - capsuleHeight - offsetY
            }
        }

        toastLabel.frame = CGRect(x: (viewController.view.frame.size.width - toastWidth) / 2,
                                  y: yPosition,
                                  width: toastWidth, height: capsuleHeight)

        viewController.view.addSubview(toastLabel)

        toastLabel.alpha = 0.0
        UIView.animate(withDuration: 0.5, animations: {
            toastLabel.alpha = 1.0
        })

        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            UIView.animate(withDuration: 0.5, animations: {
                toastLabel.alpha = 0.0
            }, completion: { _ in
                toastLabel.removeFromSuperview()
            })
        }
    }
}

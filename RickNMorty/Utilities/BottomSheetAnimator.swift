//
//  BottomSheetAnimator.swift
//  RickNMorty
//
//  Created by Kazuha on 01/11/25.
//

import UIKit

/// Provides custom presentation and dismissal animations for bottom sheet view controllers.
///
/// `BottomSheetAnimator` implements `UIViewControllerAnimatedTransitioning` to create
/// smooth slide-up and slide-down transitions with spring damping for a natural feel.
///
/// ## Usage Example
/// ```swift
/// let animator = BottomSheetAnimator(isPresenting: true)
/// // Use with UIViewControllerTransitioningDelegate
/// ```
final class BottomSheetAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    private let isPresenting: Bool
    
    /// Initializes a new bottom sheet animator.
    ///
    /// - Parameter isPresenting: `true` for presentation animation, `false` for dismissal.
    init(isPresenting: Bool) {
        self.isPresenting = isPresenting
        super.init()
    }
    
    /// Returns the duration of the transition animation.
    ///
    /// - Parameter transitionContext: The context object containing information about the transition.
    /// - Returns: The animation duration in seconds (0.3).
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    
    /// Performs the transition animation.
    ///
    /// - Parameter transitionContext: The context object containing information about the transition.
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if isPresenting {
            animatePresentation(using: transitionContext)
        } else {
            animateDismissal(using: transitionContext)
        }
    }
    
    /// Animates the presentation of the bottom sheet from the bottom of the screen.
    ///
    /// - Parameter transitionContext: The context object containing information about the transition.
    private func animatePresentation(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toViewController = transitionContext.viewController(forKey: .to) else {
            transitionContext.completeTransition(false)
            return
        }
        
        let containerView = transitionContext.containerView
        let finalFrame = transitionContext.finalFrame(for: toViewController)
        
        toViewController.view.frame = finalFrame.offsetBy(dx: 0, dy: finalFrame.height)
        toViewController.view.layer.cornerRadius = 16
        toViewController.view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        toViewController.view.clipsToBounds = true
        
        containerView.addSubview(toViewController.view)
        
        UIView.animate(
            withDuration: transitionDuration(using: transitionContext),
            delay: 0,
            usingSpringWithDamping: 0.85,
            initialSpringVelocity: 0.5,
            options: .curveEaseOut
        ) {
            toViewController.view.frame = finalFrame
        } completion: { finished in
            transitionContext.completeTransition(finished)
        }
    }
    
    /// Animates the dismissal of the bottom sheet by sliding it down off screen.
    ///
    /// - Parameter transitionContext: The context object containing information about the transition.
    private func animateDismissal(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromViewController = transitionContext.viewController(forKey: .from) else {
            transitionContext.completeTransition(false)
            return
        }
        
        let finalFrame = fromViewController.view.frame.offsetBy(dx: 0, dy: fromViewController.view.frame.height)
        
        UIView.animate(
            withDuration: transitionDuration(using: transitionContext),
            delay: 0,
            options: .curveEaseIn
        ) {
            fromViewController.view.frame = finalFrame
        } completion: { finished in
            transitionContext.completeTransition(finished)
        }
    }
}

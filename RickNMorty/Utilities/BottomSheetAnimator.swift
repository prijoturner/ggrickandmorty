//
//  BottomSheetAnimator.swift
//  RickNMorty
//
//  Created by Kazuha on 01/11/25.
//

import UIKit


final class BottomSheetAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    private let isPresenting: Bool
    
    init(isPresenting: Bool) {
        self.isPresenting = isPresenting
        super.init()
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if isPresenting {
            animatePresentation(using: transitionContext)
        } else {
            animateDismissal(using: transitionContext)
        }
    }
    
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

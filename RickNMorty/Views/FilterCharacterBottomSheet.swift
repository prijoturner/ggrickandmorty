//
//  FilterCharacterBottomSheet.swift
//  RickNMorty
//
//  Created by Kazuha on 01/11/25.
//

import UIKit

final class FilterCharacterBottomSheet: UIPresentationController {
    
    private var panGestureRecognizer: UIPanGestureRecognizer!
    private var initialFrame: CGRect = .zero
    
    private lazy var dimmingView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        view.alpha = 0
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleDimmingViewTap))
        view.addGestureRecognizer(tapGesture)
        return view
    }()
    
    private lazy var grabberView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray3
        view.layer.cornerRadius = 2.5
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func presentationTransitionWillBegin() {
        guard let containerView = containerView,
              let presentedView = presentedView else { return }
        
        dimmingView.frame = containerView.bounds
        containerView.insertSubview(dimmingView, at: 0)
        
        presentedView.addSubview(grabberView)
        NSLayoutConstraint.activate([
            grabberView.centerXAnchor.constraint(equalTo: presentedView.centerXAnchor),
            grabberView.topAnchor.constraint(equalTo: presentedView.topAnchor, constant: 8),
            grabberView.widthAnchor.constraint(equalToConstant: 36),
            grabberView.heightAnchor.constraint(equalToConstant: 5)
        ])
        
        // Add pan gesture recognizer for swipe to dismiss
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        panGestureRecognizer.delegate = self
        presentedView.addGestureRecognizer(panGestureRecognizer)
        
        // Observe preferredContentSize changes
        presentedViewController.addObserver(self, forKeyPath: "preferredContentSize", options: [.new], context: nil)
        
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { _ in
            self.dimmingView.alpha = 1
        })
    }
    
    override func dismissalTransitionWillBegin() {
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { _ in
            self.dimmingView.alpha = 0
        })
    }
    
    override func dismissalTransitionDidEnd(_ completed: Bool) {
        if completed {
            dimmingView.removeFromSuperview()
            presentedViewController.removeObserver(self, forKeyPath: "preferredContentSize")
        }
    }
    
    override func containerViewDidLayoutSubviews() {
        super.containerViewDidLayoutSubviews()
        dimmingView.frame = containerView?.bounds ?? .zero
        presentedView?.frame = frameOfPresentedViewInContainerView
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "preferredContentSize" {
            UIView.animate(withDuration: 0.3) {
                self.presentedView?.frame = self.frameOfPresentedViewInContainerView
            }
        }
    }
    
    override var frameOfPresentedViewInContainerView: CGRect {
        guard let containerView = containerView else { return .zero }
        let preferredHeight = presentedViewController.preferredContentSize.height
        let contentHeight = preferredHeight > 0 ? preferredHeight : 450
        let safeAreaBottom = containerView.safeAreaInsets.bottom
        let totalHeight = min(contentHeight + safeAreaBottom, containerView.bounds.height * 0.9)
        let yPosition = containerView.bounds.height - totalHeight
        
        return CGRect(
            x: 0,
            y: yPosition,
            width: containerView.bounds.width,
            height: totalHeight
        )
    }
    
    @objc private func handleDimmingViewTap() {
        presentedViewController.dismiss(animated: true)
    }
    
    @objc private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        guard let presentedView = presentedView,
              let containerView = containerView else { return }
        
        let translation = gesture.translation(in: containerView)
        let velocity = gesture.velocity(in: containerView)
        
        switch gesture.state {
        case .began:
            initialFrame = presentedView.frame
            
        case .changed:
            // Only allow downward dragging
            let newY = max(initialFrame.origin.y, initialFrame.origin.y + translation.y)
            presentedView.frame.origin.y = newY
            
            // Update dimming view alpha based on drag progress
            let progress = translation.y / presentedView.frame.height
            dimmingView.alpha = max(0, 1 - progress)
            
        case .ended, .cancelled:
            let draggedDistance = presentedView.frame.origin.y - initialFrame.origin.y
            let shouldDismiss = draggedDistance > presentedView.frame.height * 0.3 || velocity.y > 500
            
            if shouldDismiss {
                // Dismiss with animation
                UIView.animate(withDuration: 0.25, animations: {
                    presentedView.frame.origin.y = containerView.bounds.height
                    self.dimmingView.alpha = 0
                }) { _ in
                    self.presentedViewController.dismiss(animated: false)
                }
            } else {
                // Snap back to original position
                UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5) {
                    presentedView.frame = self.initialFrame
                    self.dimmingView.alpha = 1
                }
            }
            
        default:
            break
        }
    }
}

// MARK: - UIGestureRecognizerDelegate
extension FilterCharacterBottomSheet: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let panGesture = gestureRecognizer as? UIPanGestureRecognizer,
              let presentedView = presentedView else { return false }
        
        let velocity = panGesture.velocity(in: presentedView)
        let isVertical = abs(velocity.y) > abs(velocity.x)
        let isDownward = velocity.y > 0
        
        return isVertical && isDownward
    }
}

final class FilterCharacterBottomSheetDelegate: NSObject, UIViewControllerTransitioningDelegate {
    func presentationController(
        forPresented presented: UIViewController,
        presenting: UIViewController?,
        source: UIViewController
    ) -> UIPresentationController? {
        return FilterCharacterBottomSheet(
            presentedViewController: presented,
            presenting: presenting
        )
    }
    
    func animationController(
        forPresented presented: UIViewController,
        presenting: UIViewController,
        source: UIViewController
    ) -> UIViewControllerAnimatedTransitioning? {
        return BottomSheetAnimator(isPresenting: true)
    }
    
    func animationController(
        forDismissed dismissed: UIViewController
    ) -> UIViewControllerAnimatedTransitioning? {
        return BottomSheetAnimator(isPresenting: false)
    }
}

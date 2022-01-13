//
//  BottomSheetPresentationController.swift
//  EasyDo
//
//  Created by Maximus on 11.01.2022.
//

import Foundation
import UIKit

public final class BottomSheetPresentationController: UIPresentationController {
    
    private enum State {
        case dismised
        case presenting
        case presented
        case dismissing
    }
    
    private enum Style {
        static let cornerRadius: CGFloat = 10
        static let pullBarHeight = Style.cornerRadius * 2
        
    }
    
    var shadingView: UIView?
    private var state: State = .dismised
    
    private var pullBar: PullBar?
    
    private func applyStyle() {
        guard  presentedViewController.isViewLoaded  else { return  }
        presentedViewController.view.clipsToBounds = true
        presentedViewController.view.layer.cornerRadius = Style.cornerRadius
    }
    
    public override func presentationTransitionWillBegin() {
        state = .presenting
       
        addSubviews()
        applyStyle()
    }
    
    public override func presentationTransitionDidEnd(_ completed: Bool) {
        if completed {
            state = .presented
        } else {
            state = .dismised
        }
    }
    
    public override func dismissalTransitionWillBegin() {
        state = .dismissing
        
    }
    
    public override func dismissalTransitionDidEnd(_ completed: Bool) {
        if completed {
            removeSubviews()
            state = .dismised
        } else {
            state = .presented
        }
    }
    
    private func addSubviews() {
        guard let containerView = containerView else { return }
        setupShadingView(containerView: containerView)
        setupPullBar(containerView: containerView)
    }
    
    private func setupShadingView(containerView: UIView) {
        let shadingView = UIView()
        containerView.addSubview(shadingView)
        shadingView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        shadingView.frame = containerView.bounds
        
        let tapGesture = UITapGestureRecognizer()
        shadingView.addGestureRecognizer(tapGesture)
        tapGesture.addTarget(self, action: #selector(handleShadingViewTapGesture))
        self.shadingView = shadingView
    }
    
    @objc private func handleShadingViewTapGesture() {
        dismissIfPossible()
    }
    
    private func removeSubviews() {
        shadingView?.removeFromSuperview()
        shadingView = nil
        pullBar?.removeFromSuperview()
        pullBar = nil
    }
    
    private func  dismissIfPossible() {
        let canBeDismissed = state == .presented
        if canBeDismissed {
            dissmisalHandler.performDismissal(animated: true)
        }
    }
    
    private let dissmisalHandler: BottomSheetModalDissmisalHandler
    
     public init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?, dissmisalHandler: BottomSheetModalDissmisalHandler) {
        self.dissmisalHandler = dissmisalHandler
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
    }
    
    public override var shouldPresentInFullscreen: Bool {
        return false
    }
    
    public override var frameOfPresentedViewInContainerView: CGRect {
        return targetFrameForPresentedView()
    }
    
    public override func preferredContentSizeDidChange(forChildContentContainer container: UIContentContainer) {
        updatePresentedViewSize()
    }
    
    private func updatePresentedViewSize() {
        guard let presentedView = presentedView else { return }
        let oldFrame = presentedView.frame
        let targetFrame = targetFrameForPresentedView()
        
        if !oldFrame.isAlmostEqual(to: targetFrame) {
            presentedView.frame  = targetFrame
            pullBar?.frame.origin.y = presentedView.frame.minY - Style.pullBarHeight
        }
    }
    
    private func setupPullBar(containerView: UIView) {
        let pullBar = PullBar()
        pullBar.frame.size = CGSize(width: containerView.frame.width, height: Style.pullBarHeight)
        containerView.addSubview(pullBar)
        self.pullBar = pullBar
    }

    private func targetFrameForPresentedView() -> CGRect {
        guard let containerView = containerView else {
            return .zero
        }

        let windowInsets = presentedView?.window?.safeAreaInsets ?? .zero

        let preferredHeight = presentedViewController.preferredContentSize.height + windowInsets.bottom
        let maxHeight = containerView.bounds.height - windowInsets.top
        let height = min(preferredHeight, maxHeight)
        
        return CGRect(
            x: 0,
            y: (containerView.bounds.height - height),
            width: containerView.bounds.width,
            height: height
        )
    }
    
}


extension BottomSheetPresentationController: UIViewControllerAnimatedTransitioning {
    
    
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        0.3
    }
    
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard
            let sourceViewController = transitionContext.viewController(forKey: .from),
            let destinationViewController = transitionContext.viewController(forKey: .to),
            let sourceView = sourceViewController.view,
            let destinationView = destinationViewController.view
        else {
            return
        }
        
        let isPresenting = destinationViewController.isBeingPresented
        let presentedView = isPresenting ? destinationView : sourceView
        let containerView = transitionContext.containerView
        if isPresenting {
            containerView.addSubview(destinationView)
            
            destinationView.frame = containerView.bounds
        }
        
        sourceView.layoutIfNeeded()
        destinationView.layoutIfNeeded()
        
        let frameInContainer = frameOfPresentedViewInContainerView
        let offscreenFrame = CGRect(
            origin: CGPoint(
                x: 0,
                y: containerView.bounds.height
            ),
            size: sourceView.frame.size
        )
        
        presentedView.frame = isPresenting ? offscreenFrame : frameInContainer
        pullBar?.frame.origin.y = presentedView.frame.minY - Style.pullBarHeight
        shadingView?.alpha = isPresenting ? 0 : 1
        
        let animations = {
            presentedView.frame = isPresenting ? frameInContainer : offscreenFrame
            self.pullBar?.frame.origin.y = presentedView.frame.minY - Style.pullBarHeight
            self.shadingView?.alpha = isPresenting ? 1 : 0
        }
        
        let completion = { (completed: Bool) in
            transitionContext.completeTransition(completed && !transitionContext.transitionWasCancelled)
        }
        
        let options: UIView.AnimationOptions = transitionContext.isInteractive ? .curveLinear : .curveEaseInOut
        let transitionDurationValue = transitionDuration(using: transitionContext)
        UIView.animate(withDuration: transitionDurationValue, delay: 0, options: options, animations: animations, completion: completion)
    }
}

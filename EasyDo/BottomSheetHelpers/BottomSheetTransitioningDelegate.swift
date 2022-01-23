//
//  BottomSheetTransitioningDelegate.swift
//  EasyDo
//
//  Created by Maximus on 11.01.2022.
//

import Foundation
import UIKit

public protocol BottomSheetPresentationControllerFactory {
    func makeBottomSheetPresentationController(
        presentedViewController: UIViewController?,
        presentingViewController: UIViewController?) -> BottomSheetPresentationController
}

typealias TransitionDelegate = NSObject & UIViewControllerTransitioningDelegate

class BottomSheetTransitioningDelegate: TransitionDelegate {
    
    private let factory: BottomSheetPresentationControllerFactory
    
    private weak var presentationController: BottomSheetPresentationController?
    
    public init(factory: BottomSheetPresentationControllerFactory) {
        self.factory = factory
    }
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return _presentationController(forPresented: presented, presenting: presenting, source: source)
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        presentationController
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        presentationController
    }
    private func _presentationController(forPresented presented: UIViewController, presenting: UIViewController?,
                                         source: UIViewController) -> BottomSheetPresentationController {
        if let presentationController = presentationController {
            return presentationController
        }
        let controller = factory.makeBottomSheetPresentationController(presentedViewController: presented, presentingViewController: presenting)
        presentationController = controller
        return controller
    }
    
    
    
}





    




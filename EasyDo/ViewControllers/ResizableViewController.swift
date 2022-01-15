//
//  ResizebleViewController.swift
//  EasyDo
//
//  Created by Maximus on 12.01.2022.
//

import Foundation
import UIKit

class ResizableViewController: UIViewController {
    
    private var bottomSheetTransitionDelegate: UIViewControllerTransitioningDelegate?
    private var currentHeight: CGFloat
    var delegate: (() -> ())?
    @objc 
    init(initialHeight: CGFloat) {
        currentHeight = initialHeight
        
        super.init(nibName: nil, bundle: nil)
        bottomSheetTransitionDelegate = BottomSheetTransitioningDelegate(factory: self)
        transitioningDelegate = bottomSheetTransitionDelegate
        modalPresentationStyle = .custom
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func updateCurrentHeight(newValue: CGFloat ) {
        currentHeight = newValue
        UIView.animate(
            withDuration: 0.25,
            animations: { [self] in
                preferredContentSize = CGSize(
                    width: UIScreen.main.bounds.width,
                    height: newValue
                )
            }
        )
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateCurrentHeight(newValue: currentHeight)
    }
}

extension ResizableViewController: BottomSheetPresentationControllerFactory {
    func makeBottomSheetPresentationController(presentedViewController: UIViewController?, presentingViewController: UIViewController?) -> BottomSheetPresentationController {
        .init(presentedViewController: presentedViewController!, presenting: presentingViewController, dissmisalHandler: self)
    }
    
    
}

//MARK: BottomSheetModalDissmisalHandler
extension ResizableViewController: BottomSheetModalDissmisalHandler {
    func performDismissal(animated: Bool) {
        presentingViewController?.dismiss(animated: animated)
    }
}

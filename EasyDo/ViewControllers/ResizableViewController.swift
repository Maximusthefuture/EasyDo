//
//  ResizebleViewController.swift
//  EasyDo
//
//  Created by Maximus on 12.01.2022.
//

import Foundation
import UIKit

class ResizableViewController: UIViewController {
    
    private var currentHeight: CGFloat
    
    init(initialHeight: CGFloat) {
        currentHeight = initialHeight
        super.init(nibName: nil, bundle: nil)
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

//
//  MenuLabel.swift
//  EasyDo
//
//  Created by Maximus on 06.01.2022.
//

import Foundation
import UIKit

class MenuLabel: UILabel{
    
  
    
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
        
    }
    
    private func commonInit() {
        isUserInteractionEnabled = true
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapGesture)))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        commonInit()
    }
    
    @objc internal func handleTapGesture(_ gesture: UITapGestureRecognizer) {
       
        var menu = UIMenu(title: "", options: .displayInline, children: [
            
            UIAction(title: "Hello", attributes: .disabled, state: .mixed)  { _ in
                
            },
            UIAction(title: "Projects", attributes: .destructive, state: .on) { _ in
            }
        ])
        print("HANDLE TAP")
        
        
        
//        guard let gestureView = gesture.view, let superView = gestureView.superview else { return }
//        let menuController = UIMenuController.shared
//        guard !menuController.isMenuVisible, gestureView.canBecomeFirstResponder else { return }
//        gestureView.becomeFirstResponder()
//        menuController.menuItems = [
//            UIMenuItem(title: "Project", action: #selector(handleSomeAction)),
//            UIMenuItem(title: "Some other title", action: #selector(handleSomeAction))
//        ]
//        menuController.arrowDirection = .left
////        menuController.
////        UIMenuController.shared.arrowDirection = .down
//        menuController.showMenu(from: superView, rect: gestureView.frame)
      
        
    
    }
    
    override func buildMenu(with builder: UIMenuBuilder) {
        guard builder.system == UIMenuSystem.main else { return }
        let menu = UIMenu(title: "", options: .displayInline, children: [

            UIAction(title: "Hello", attributes: .disabled, state: .mixed)  { _ in

            },
            UIAction(title: "Projects", attributes: .destructive, state: .on) { _ in
            }
        ])
        builder.insertChild(menu, atStartOfMenu: .text)
        
    }
    
    @objc func handleSomeAction() {
        
    }
    
}

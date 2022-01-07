//
//  RoundedView.swift
//  EasyDo
//
//  Created by Maximus on 07.01.2022.
//

import Foundation
import UIKit

class RoundedView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.cornerRadius = 16
        self.backgroundColor = .white
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOpacity = 10
        self.layer.shadowOffset = .zero
        self.layer.shadowRadius = 10
        self.layer.masksToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    let roundedView: UIView = {
//        var view = UIView()
//
//        return view
//    }()
}

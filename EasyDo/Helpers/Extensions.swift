//
//  Extensions.swift
//  EasyDo
//
//  Created by Maximus on 04.01.2022.
//

import Foundation
import UIKit

extension UIView {
    func roundedView() -> UIView {
            self.layer.cornerRadius = 16
            self.backgroundColor = .white
            self.layer.shadowColor = UIColor.gray.cgColor
            self.layer.shadowOpacity = 10
            self.layer.shadowOffset = .zero
            self.layer.shadowRadius = 10
            self.layer.masksToBounds = true
            return self
      
    }
}

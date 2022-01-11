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

extension BinaryFloatingPoint {
    func isAlmostEqual(to other: Self) -> Bool {
        abs(self - other) < abs(self + other).ulp
    }
}

extension CGRect {
    func isAlmostEqual(to other: CGRect) -> Bool {
        size.isAlmostEqual(to: other.size) && origin.isAlmostEqual(to: other.origin)
    }
    
    var center: CGPoint {
        get {
            CGPoint(x: midX, y: midY)
        }
        set {
            origin = CGPoint(x: newValue.x - width * 0.5, y: newValue.y - height * 0.5)
        }
    }
}

extension CGSize {
    func isAlmostEqual(to other: CGSize) -> Bool {
        width.isAlmostEqual(to: other.width) && height.isAlmostEqual(to: other.height)
    }
}

extension CGPoint {
    func isAlmostEqual(to other: CGPoint) -> Bool {
        x.isAlmostEqual(to: other.x) && y.isAlmostEqual(to: other.y)
    }
}



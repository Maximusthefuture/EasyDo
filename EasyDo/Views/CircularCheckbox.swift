//
//  CircularCheckbox.swift
//  EasyDo
//
//  Created by Maximus on 28.01.2022.
//

import Foundation
import UIKit

class CircularCheckBox: UIView {
    
    var radius: CGFloat?
    var fillColor: CGColor?
    var isChecked = false
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//        layer.borderWidth = 0.5
//        layer.borderColor = UIColor.secondaryLabel.cgColor
//        layer.cornerRadius = frame.size.width / 2.0
//        backgroundColor = .blue
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    func toggle() {
        self.isChecked = !isChecked
        if self.isChecked {
            fillColor = UIColor.blue.cgColor
            setNeedsDisplay()
        } else {
            fillColor = UIColor.white.cgColor
            setNeedsDisplay()
        }
       
    }
    override func draw(_ rect: CGRect) {
        let bezierPath = UIBezierPath(arcCenter: .init(x: bounds.size.width / 2, y: bounds.size.height / 2), radius: 10, startAngle: 0, endAngle: Double.pi * 2, clockwise: true)
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = bezierPath.cgPath
        
        shapeLayer.fillColor = fillColor
        shapeLayer.strokeColor = UIColor.black.cgColor
        shapeLayer.lineWidth = 1.0
        layer.addSublayer(shapeLayer)
    }
}

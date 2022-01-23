//
//  TagUIView.swift
//  EasyDo
//
//  Created by Maximus on 20.12.2021.
//

import UIKit

class TagUIView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 6
       
//        layer.masksToBounds = true
        clipsToBounds = true
        isAccessibilityElement = false
        addSubview(label)
        label.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 8, left: 16, bottom: 8, right: 16))
        label.isAccessibilityElement = true
        label.accessibilityIdentifier = "LabelInTagView"
        accessibilityIdentifier = "TagView"
//        label.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 8, left: 16, bottom: 8, right: 16))
//        translatesAutoresizingMaskIntoConstraints = false
//        heightAnchor.constraint(equalToConstant: label.frame.height).isActive = true
//        widthAnchor.constraint(equalToConstant: label.frame.width).isActive = true
        
  
    }
    
    var label: UILabel = {
        var label = UILabel()
        return label
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        let clipPath = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: label.frame.width, height: 40), cornerRadius: 6).cgPath
        let ctx = UIGraphicsGetCurrentContext()!
        ctx.addPath(clipPath)
//        ctx.setFillColor(UIColor.red.cgColor)
        ctx.closePath()
//        ctx.fillPath()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
}

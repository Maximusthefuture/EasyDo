//
//  TagUIView.swift
//  EasyDo
//
//  Created by Maximus on 20.12.2021.
//

import UIKit


//MARK: LABEL TEXT IN CENTER
class TagUIView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 6
        clipsToBounds = true
        isAccessibilityElement = false
        addSubview(label)
        label.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 8, left: 8, bottom: 8, right: 8))
        label.isAccessibilityElement = true
        label.accessibilityIdentifier = "LabelInTagView"
        accessibilityIdentifier = "TagView"
    }
    
    var label: UILabel = {
        var label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13, weight: .bold)
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
        ctx.closePath()
    }
 
    override func layoutSubviews() {
        super.layoutSubviews()
        label.textAlignment = .center
    }
    
}

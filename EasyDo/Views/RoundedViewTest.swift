//
//  RoundedView.swift
//  EasyDo
//
//  Created by Maximus on 06.02.2022.
//

import Foundation
import UIKit

class ViewWithCorners: UIView {
    
    
    let label: UILabel = {
        let label = UILabel()
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = true
        backgroundColor = .white
        addSubview(label)
        label.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 8, left: 8, bottom: 8, right: 8))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        let bezier = UIBezierPath(roundedRect: .init(origin: .init(x: 0, y: 0), size: .init(width: rect.width , height: rect.height)), cornerRadius: 10)
        let color: UIColor = .blue
        UIColor.white.setFill()
        bezier.addClip()
        bezier.fill()
        color.setStroke()
        bezier.stroke()
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        label.textAlignment = .center
    }
}

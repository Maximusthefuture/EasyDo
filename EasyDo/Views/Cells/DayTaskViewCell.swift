//
//  DayTaskViewCell.swift
//  EasyDo
//
//  Created by Maximus on 04.01.2022.
//

import UIKit

class DayTaskViewCell: UITableViewCell {
    
    
    let timeLabel: UILabel = {
       let label = UILabel()
        label.text = "SOME TEXT"
        return label
    }()
    
    let taskLabel: UILabel = {
        let label = UILabel()
        label.text = "HELLOW"
         return label
    }()
//    
    let roundedView: UIView =  {
        let view = UIView()
        return  view.roundedView()
    }()
    
    /*
     A UIView (Or your custom UIImageView which will create your yellow line. It needs to be vertically centered, leading and trailing to superview equal to 0 and the height lets say 5pt
     */
    
    var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        
        return view
        
    }()
    
    var path = UIBezierPath()
    var shapeLayer = CAShapeLayer()
    
        
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(timeLabel)
        addSubview(roundedView)
        roundedView.addSubview(taskLabel)
        
        timeLabel.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor , trailing: trailingAnchor)
        roundedView.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 10, left: 60, bottom: 10, right: 30))
        taskLabel.anchor(top: roundedView.topAnchor, leading: roundedView.leadingAnchor, bottom: roundedView.bottomAnchor, trailing: roundedView.trailingAnchor, padding: .init(top: 0, left: 16, bottom: 0, right: 0))
        
        path.move(to: CGPoint(x: self.frame.minX + 20, y: roundedView.bounds.origin.y + 30))
        path.addLine(to: CGPoint(x: self.frame.minX + 20, y: roundedView.bounds.origin.y - 30))
        
        
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = #colorLiteral(red: 0.4374618232, green: 0.4814278483, blue: 0.999235332, alpha: 1).cgColor
        shapeLayer.lineWidth = 5.0
        contentView.layer.addSublayer(shapeLayer)
        roundedView.backgroundColor = #colorLiteral(red: 0.9722431302, green: 0.972392261, blue: 1, alpha: 1)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
       
       
    }
    
    
}

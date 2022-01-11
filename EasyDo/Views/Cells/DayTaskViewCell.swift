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
        addSubview(lineView)
        addSubview(timeLabel)
        addSubview(roundedView)
       
        
        timeLabel.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor , trailing: trailingAnchor)
        roundedView.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 10, left: 60, bottom: 10, right: 30))
//        drawLine()
        
        
        path.move(to: CGPoint(x: self.frame.midX, y: roundedView.bounds.origin.y - 10))
        path.addLine(to: CGPoint(x: self.frame.midX, y: roundedView.bounds.origin.y + 10))
        
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = UIColor.red.cgColor
        shapeLayer.lineWidth = 5.0
        layer.addSublayer(shapeLayer)
       
        lineView.translatesAutoresizingMaskIntoConstraints = false
        lineView.centerXAnchor.constraint(equalTo: roundedView.centerXAnchor).isActive = true
        lineView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        lineView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        lineView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        lineView.widthAnchor.constraint(equalToConstant: 5).isActive = true
        
        
        
        roundedView.backgroundColor = .systemBlue
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        roundedView.addSubview(taskLabel)
        taskLabel.anchor(top: roundedView.topAnchor, leading: roundedView.leadingAnchor, bottom: roundedView.bottomAnchor, trailing: roundedView.trailingAnchor)
    }
    
    
}

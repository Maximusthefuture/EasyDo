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
    
    var path: UIBezierPath?
    var shapeLayer = CAShapeLayer()
    var shapeLayer2 = CAShapeLayer()
    
    func drawCircle() -> UIBezierPath {
        let startAngle = CGFloat(-Double.pi / 2)
        let endAngle = startAngle + 2 * Double.pi * 1
        let circle = UIBezierPath(arcCenter: CGPoint(x: self.frame.minX + 20, y: roundedView.bounds.origin.y + 30), radius: 10, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        circle.stroke()
        return circle
    }
    
    
        
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        addSubview(timeLabel)
        addSubview(roundedView)
        roundedView.addSubview(taskLabel)
        path = UIBezierPath()
        timeLabel.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor , trailing: trailingAnchor)
        roundedView.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 10, left: 60, bottom: 10, right: 30))
        taskLabel.anchor(top: roundedView.topAnchor, leading: roundedView.leadingAnchor, bottom: roundedView.bottomAnchor, trailing: roundedView.trailingAnchor, padding: .init(top: 0, left: 16, bottom: 0, right: 0))
        roundedView.backgroundColor = #colorLiteral(red: 0.9722431302, green: 0.972392261, blue: 1, alpha: 1)
        path?.move(to: CGPoint(x: self.frame.minX + 20, y: roundedView.bounds.origin.y + 30))
        path?.addLine(to: CGPoint(x: self.frame.minX + 20, y: roundedView.bounds.origin.y - 30))
        shapeLayer2.path = path?.cgPath
        shapeLayer.path = drawCircle().cgPath
        
        shapeLayer.strokeColor = #colorLiteral(red: 0.4374618232, green: 0.4814278483, blue: 0.999235332, alpha: 1).cgColor
        shapeLayer.lineWidth = 0.0
        shapeLayer2.strokeColor = #colorLiteral(red: 0.4374618232, green: 0.4814278483, blue: 0.999235332, alpha: 1).cgColor
        shapeLayer2.lineWidth = 5.0
        shapeLayer.fillColor = UIColor.systemPink.cgColor
        contentView.layer.addSublayer(shapeLayer2)
        contentView.layer.addSublayer(shapeLayer)
       
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //?????
    override func layoutSubviews() {
        super.layoutSubviews()
       
       
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
//        shapeLayer.path = nil
//        path = UIBezierPath()
        
    }
    
    
}

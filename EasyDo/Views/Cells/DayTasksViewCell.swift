//
//  DayTasksViewCell.swift
//  EasyDo
//
//  Created by Maximus on 31.01.2022.
//

import Foundation
import UIKit

class DayTasksViewCell: UITableViewCell {
    
    let roundedView: UIView =  {
        let view = UIView()
        view.clipsToBounds = true
        return  view.roundedView()
    }()
    
    let taskLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
//        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 16, weight: .heavy)
        label.text = "HELLOW"
        return label
    }()
    
    let taskDescription: UILabel = {
        let label = UILabel()
//        label.textColor = .white
        label.numberOfLines = 2
        label.lineBreakMode = .byClipping
        
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        return label
    }()
    
    let tagView: TagUIView = {
        let view = TagUIView()
        view.backgroundColor = .white
        
        return view
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        //градиент с 2х тагов?))))
       
        let marginGuide = contentView.layoutMarginsGuide
                contentView.addSubview(roundedView)
        contentView.addSubview(taskLabel)
        contentView.addSubview(taskDescription)
                contentView.addSubview(tagView)
//        backgroundColor = .yellow
        roundedView.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 10, left: 8, bottom: 0, right: 8))
       
//        roundedView.backgroundColor = gradientLayer
        taskLabel.anchor(top: marginGuide.topAnchor, leading: marginGuide.leadingAnchor, bottom: nil, trailing: marginGuide.trailingAnchor, padding: .init(top: 8, left: 8, bottom: 0, right: 0))
        taskDescription.anchor(top: taskLabel.bottomAnchor, leading: marginGuide.leadingAnchor, bottom: nil, trailing: marginGuide.trailingAnchor, padding: .init(top: 6, left: 8, bottom: 0, right: 0))
        tagView.anchor(top: taskDescription.bottomAnchor, leading: marginGuide.leadingAnchor, bottom: marginGuide.bottomAnchor, trailing: nil, padding: .init(top: 8, left: 8, bottom: 0, right: 0))
        selectionStyle = .none
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let colorTop =  UIColor(red: 255.0/255.0, green: 149.0/255.0, blue: 0.0/255.0, alpha: 1.0).cgColor
           let colorBottom = UIColor(red: 255.0/255.0, green: 94.0/255.0, blue: 58.0/255.0, alpha: 1.0).cgColor
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop, colorBottom]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = roundedView.bounds
        roundedView.layer.addSublayer(gradientLayer)
        
        if tagView.isHidden {
            taskLabel.centerYAnchor.constraint(equalTo: roundedView.centerYAnchor).isActive = true
        }
    }
    
    
}

//
//  WeeklyPickerViewCell.swift
//  EasyDo
//
//  Created by Maximus on 17.01.2022.
//

import Foundation
import UIKit


class WeeklyPickerViewCell: UICollectionViewCell {
    
    
    let dayLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        return label
    }()
    
    let roundedView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.9722431302, green: 0.972392261, blue: 1, alpha: 1)
        view.layer.cornerRadius = 20
        view.clipsToBounds = true
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(roundedView)
        contentView.addSubview(dayLabel)
//        backgroundColor = .blue
        dayLabel.anchor(top: roundedView.topAnchor, leading: roundedView.leadingAnchor, bottom: roundedView.bottomAnchor, trailing: roundedView.trailingAnchor, padding: .init(top: 0, left: 8, bottom: 0, right: 0))
        roundedView.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor)
//        backgroundColor = .red
        roundedView.isHidden = true
    }
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                dayLabel.textColor = #colorLiteral(red: 0.5596068501, green: 0.5770205855, blue: 1, alpha: 1)
                dayLabel.font = UIFont.boldSystemFont(ofSize: 15)
                roundedView.isHidden = false
            } else {
                dayLabel.textColor = .black
                dayLabel.font = UIFont.boldSystemFont(ofSize: 13)
                roundedView.isHidden = true
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}

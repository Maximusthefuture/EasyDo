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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(dayLabel)
//        backgroundColor = .blue
        dayLabel.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 0, left: 16, bottom: 0, right: 16))
    }
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                dayLabel.textColor = .green
                dayLabel.font = UIFont.boldSystemFont(ofSize: 15)
            } else {
                dayLabel.textColor = .black
                dayLabel.font = UIFont.boldSystemFont(ofSize: 13)
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}

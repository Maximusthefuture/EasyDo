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
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}

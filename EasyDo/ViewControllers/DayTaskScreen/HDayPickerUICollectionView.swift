//
//  HDayPickerUICollectionView.swift
//  EasyDo
//
//  Created by Maximus on 17.01.2022.
//

import Foundation
import UIKit

class HDayPickerUICollectionView: BaseListController {
    let dayPickerCellId = "dayPicker"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let layout = collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
        }
        collectionView.register(WeeklyPickerViewCell.self, forCellWithReuseIdentifier: dayPickerCellId)
    }
}

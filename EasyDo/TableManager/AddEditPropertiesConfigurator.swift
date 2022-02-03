//
//  AddEditPropertiesConfigurator.swift
//  EasyDo
//
//  Created by Maximus on 03.02.2022.
//

import Foundation
import UIKit


final class AddEditPropertiesConfigurator: CellConfigurator {
    
    var reuseId: String{ String(describing: AddEditCardPropertiesViewCell.self) }
    
    var cellType: AddEditCardCellType { .properties }
    
    var model: String?
    var propeptiesLabel: String?
    
    func setupCell(_ cell: UIView) {
        
        guard let cell = cell as? AddEditCardPropertiesViewCell,
              let task = model else { return }
        cell.label.text = model
//        cell.initTask(initialTask: task)
    }
    
    
}

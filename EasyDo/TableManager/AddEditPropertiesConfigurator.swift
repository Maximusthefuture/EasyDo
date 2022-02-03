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

final class AddEditAttachmentConfigurator: CellConfigurator {
    var reuseId: String{ String(describing: AttachmentsCardViewCell.self) }
    
    var cellType: AddEditCardCellType { .attachments }
    var model: String?
    
    func setupCell(_ cell: UIView) {
        guard let cell = cell as? AddEditCardPropertiesViewCell,
              let task = model else { return }
        
    }
    
    
}

final class AddEditTodoConfigurator: CellConfigurator {
    let cellId = "CellID"
    var reuseId: String { return cellId }
    
    var cellType: AddEditCardCellType { .todo }
    var model: String?
    
    func setupCell(_ cell: UIView) {
        guard let cell = cell as? UITableViewCell,
              let task = model else { return }
        cell.backgroundColor = .blue
        print("cell", cell.isSelected)
        
    }
    
    
}


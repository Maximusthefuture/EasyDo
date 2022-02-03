//
//  TodoListCell.swift
//  EasyDo
//
//  Created by Maximus on 03.02.2022.
//

import Foundation
import UIKit


class TodoListCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .red
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

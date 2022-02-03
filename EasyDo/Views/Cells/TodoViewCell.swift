//
//  TodoViewCell.swift
//  EasyDo
//
//  Created by Maximus on 03.02.2022.
//

import Foundation
import UIKit


class TodoViewCell: UITableViewCell {
    
    var todoViewController = TodoViewController()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(todoViewController.view)
        todoViewController.view.fillSuperview()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

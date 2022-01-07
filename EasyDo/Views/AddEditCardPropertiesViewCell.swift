//
//  AddEditCardPropertiesViewCell.swift
//  EasyDo
//
//  Created by Maximus on 07.01.2022.
//

import Foundation
import UIKit


class AddEditCardPropertiesViewCell: UITableViewCell {
    
    
    let view:  RoundedView = {
        let view = RoundedView()
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(view)
        view.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor)
        view.backgroundColor = .black
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

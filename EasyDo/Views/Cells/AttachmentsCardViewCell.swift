//
//  AttachmentsCardViewCell.swift
//  EasyDo
//
//  Created by Maximus on 07.01.2022.
//

import Foundation
import UIKit

class AttachmentsCardViewCell: UITableViewCell {
    
    
    var horizontalAttachments = HorizontalAttachmentsController()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(horizontalAttachments.view)
        horizontalAttachments.view.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor)
        horizontalAttachments.view.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

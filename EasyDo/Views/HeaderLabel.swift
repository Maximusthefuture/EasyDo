//
//  HeaderLabel.swift
//  EasyDo
//
//  Created by Maximus on 12.01.2022.
//

import Foundation
import UIKit

class HeaderLabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        font = UIFont.systemFont(ofSize: 18, weight: .bold)
        textColor = UIColor.gray
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.insetBy(dx: 16, dy: 0))
    }
}

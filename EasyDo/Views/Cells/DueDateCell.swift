//
//  DueDateCell.swift
//  EasyDo
//
//  Created by Maximus on 28.01.2022.
//

import Foundation
import UIKit

class DueDateCell: UITableViewCell {
    
    let roundedView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        return view.roundedView()
    }()
    
    private let noDeadLineLabel: UILabel = {
        let label = UILabel()
        label.text = "No deadline"
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textColor = .black
        return label
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(roundedView)
        roundedView.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: nil, padding: .init(top: 8, left: 16, bottom: 8, right: 0), size: .init(width: (frame.width / 2) + 40, height: 0))
        roundedView.addSubview(timeLabel)
        contentView.addSubview(noDeadLineLabel)
        noDeadLineLabel.centerInRight(leading: leadingAnchor,padding: .init(top: 0, left: 0, bottom: 0, right: 16))
        timeLabel.centerInSuperview()
        roundedView.backgroundColor = #colorLiteral(red: 0.9722431302, green: 0.972392261, blue: 1, alpha: 1)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}

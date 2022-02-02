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
    
    let datePicker: UIDatePicker = {
        let dp = UIDatePicker()
        dp.datePickerMode = .dateAndTime
        return dp
    }()
    
    var deadLineCheckbox:CircularCheckBox = {
       let checkbox = CircularCheckBox()
        return checkbox
    }()
    
    @objc func handleCheckboxTap() {
        deadLineCheckbox.toggle()
        if deadLineCheckbox.isChecked {
           
            datePicker.isHidden = true
            datePicker.date = Date(timeIntervalSince1970: 0)
        } else {
           
            datePicker.isHidden = false
        }
    }
    
    func initDueDateTask(task: Task?, isHaveDueDate: Bool) {
        if !isHaveDueDate {
            if let date = task?.dueDate {
                datePicker.date = date
            } else {
                datePicker.isHidden = true
                deadLineCheckbox.isChecked = true
            }
            datePicker.isHidden = false
            deadLineCheckbox.isChecked = false
            deadLineCheckbox.isHidden = true
            noDeadLineLabel.isHidden = true
        } else {
            datePicker.isHidden = true
            deadLineCheckbox.toggle()
            deadLineCheckbox.isUserInteractionEnabled = false
        }
       
      
    }
    
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
        
        let stackView = UIStackView(arrangedSubviews: [deadLineCheckbox, noDeadLineLabel])
//        contentView.addSubview(roundedView)
        contentView.addSubview(datePicker)
        contentView.addSubview(stackView)
        stackView.axis = .horizontal
        stackView.spacing = 1
        datePicker.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: nil, padding: .init(top: 8, left: 16, bottom: 8, right: 0), size: .init(width: (frame.width / 2) + 40, height: 0))
//        roundedView.addSubview(timeLabel)
        stackView.anchor(top: topAnchor, leading: nil, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 8, left: 0, bottom: 9, right: 16), size: .init(width: 120, height: 30))
//        timeLabel.centerInSuperview()
        deadLineCheckbox.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleCheckboxTap)))
        roundedView.backgroundColor = #colorLiteral(red: 0.9722431302, green: 0.972392261, blue: 1, alpha: 1)
        selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}

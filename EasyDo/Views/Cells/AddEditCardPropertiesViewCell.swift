//
//  AddEditCardPropertiesViewCell.swift
//  EasyDo
//
//  Created by Maximus on 07.01.2022.
//

import Foundation
import UIKit


class AddEditCardPropertiesViewCell: UITableViewCell {
    
    
    let roundedView: RoundedView = {
        let view = RoundedView()
        return view
    }()
    
    let label: UILabel = {
        let label = UILabel()
        label.text = "Due Date"
//        label.backgroundColor = .green
        return label
    }()
    
    let pomodoroCount: UILabel = {
        let label = UILabel()
        return label
    }()
    
    let icon: UIImageView = {
        let image = UIImageView()
        let systemIcon = UIImage(systemName: "calendar")
        image.image = systemIcon
//        image.backgroundColor = .red
        return image
    }()
    
    let resultView: UIView = {
        let view = UIView()
        return view
    }()

    //?????
    let datePicker: UIDatePicker = {
        let dp = UIDatePicker()
        dp.datePickerMode = .date
        return dp
    }()
    //lazy?
    lazy var stackView = UIStackView()
    
    var task: Task?
    
    
    func configure(viewModel: AddEditCardViewModel) {
        pomodoroCount.text = "\(viewModel.pomodoroCount)"
        datePicker.date = viewModel.dueDate ?? Date()
    }
    
    func initTask(initialTask: Task?) {
        task = initialTask
        stackView.isAccessibilityElement = false
        stackView.accessibilityIdentifier = "StackView"
        guard let count = task?.tags else { return }
        for title in count {
            if stackView.subviews.count == (task?.tags?.count)! {
                break
            }
            let tagView = TagUIView()
            tagView.label.text = title
            tagView.backgroundColor = UIColor().randomColor()
            
            stackView.addArrangedSubview(tagView)
        }
        pomodoroCount.text = "\(Int(task?.pomodoroCount ?? 0))"
        datePicker.date = task?.dueDate ?? Date()
        
    }
    
   
  
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(roundedView)
        addSubview(icon)
        roundedView.addSubview(datePicker)
        contentView.addSubview(label)
        contentView.addSubview(stackView)
        contentView.addSubview(pomodoroCount)
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        roundedView.isAccessibilityElement = false
       
        
        icon.anchor(top: roundedView.topAnchor, leading: leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 30, left: 40, bottom: 0, right: 16), size: .init(width: 30, height: 30))
//        icon.centerYAnchor.constraint(equalTo: roundedView.centerYAnchor).isActive = true
        label.anchor(top: topAnchor, leading: icon.trailingAnchor, bottom: bottomAnchor, trailing: nil, padding: .init(top: 0, left: 16, bottom: 10, right: 16))
        pomodoroCount.centerInRight(leading: nil)
        stackView.centerInRight(leading: nil, padding: .init(top: 0, left: 16, bottom: 0, right: 16))
//        stackView.backgroundColor = .gray
        roundedView.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 16, bottom: 10, right: 16))
        datePicker.anchor(top: roundedView.topAnchor, leading: nil, bottom: roundedView.bottomAnchor, trailing: roundedView.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 16))
        datePicker.isHidden = true
        
        roundedView.backgroundColor = #colorLiteral(red: 0.9722431302, green: 0.972392261, blue: 1, alpha: 1)
        roundedView.clipsToBounds = true
        pomodoroCount.isHidden = true
        stackView.isHidden = true
       
        selectionStyle = .none
        accessoryType = .disclosureIndicator
        roundedView.isAccessibilityElement = true
        isAccessibilityElement = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

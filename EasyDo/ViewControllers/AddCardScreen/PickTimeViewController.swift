//
//  PickTimeViewController.swift
//  EasyDo
//
//  Created by Maximus on 12.01.2022.
//

import Foundation
import UIKit

class PickTimeViewController: ResizableViewController {
    
    let whenLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        return label
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        return label
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        return label
    }()
    
    var isTimeChanged: Bool?
    var date: Date?
    var time: Date?
    var dataSavedWithDate: ((Date?, Date?) -> Void)?
    
    let saveButton: UIButton = {
       let b = UIButton()
        b.setTitle("Save", for: .normal)
        b.layer.cornerRadius = 10
        b.backgroundColor = .blue
//        b.backgroundColor = .darkGray
        b.addTarget(self, action: #selector(handleSaveButton), for: .touchUpInside)
        return b
    }()
    
    let timePicker: UIDatePicker = {
        let dp = UIDatePicker()
        dp.locale = Locale.current
        dp.datePickerMode = .time
        dp.addTarget(self, action: #selector(handleTimePickerChange), for: .editingDidEnd)
        
        return dp
    }()
    
    let datePicker: UIDatePicker = {
        let dp = UIDatePicker()
        dp.locale = Locale.current
        dp.datePickerMode = .date
        dp.addTarget(self, action: #selector(handleDatePickerChange), for: .editingDidEnd)
        
        return dp
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(whenLabel)
        view.addSubview(saveButton)
        whenLabel.text = "When?"
        whenLabel.centerInTop(padding: .init(top: 20, left: 0, bottom: 0, right: 0))
        saveButton.anchor(top: nil, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor, padding: .init(top: 0, left: 16, bottom: 0, right: 16),size: CGSize(width: 0, height: 60))
        dateLabel.text = "Date"
        timeLabel.text = "Time"
        stackViewInit()
    }
    
    fileprivate func stackViewInit() {
        let horizontalDateStackView = UIStackView(arrangedSubviews: [dateLabel, datePicker])
        horizontalDateStackView.spacing = 20
        let horizontalTimeStackView = UIStackView(arrangedSubviews: [timeLabel, timePicker])
        horizontalTimeStackView.spacing  = 20
        let verticalStackView = VerticalStackView(arrangedSubviews: [horizontalDateStackView, horizontalTimeStackView], spacing: 30)
        view.addSubview(verticalStackView)
        verticalStackView.centerInSuperview(padding: .init(top: 0, left: 0, bottom: 30, right: 0))
    }
    
    @objc func handleTimePickerChange(sender: UIDatePicker) {
        sender.timeZone = .autoupdatingCurrent
        time = sender.date
    }
    
    @objc func handleDatePickerChange(sender: UIDatePicker) {
        sender.timeZone = .autoupdatingCurrent
        date = sender.date
    }
    
    @objc func handleSaveButton(sender: UIButton) {
        dataSavedWithDate?(time, date)
    }
}

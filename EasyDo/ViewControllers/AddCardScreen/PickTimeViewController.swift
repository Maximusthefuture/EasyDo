//
//  PickTimeViewController.swift
//  EasyDo
//
//  Created by Maximus on 12.01.2022.
//

import Foundation
import UIKit


class PickTimeViewController: ResizableViewController {
    
    var vm = PickTimeViewModel()
    
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
    var dataSavedWithDate: ((Date?, Date?, Bool?) -> Void)?
    var coreDataStack: CoreDataStack?
    
    let saveButton: UIButton = {
        let b = UIButton()
        b.setTitle("Save", for: .normal)
        b.layer.cornerRadius = 10
        b.backgroundColor = .blue
        b.addTarget(self, action: #selector(handleSaveButton), for: .touchUpInside)
        return b
        
    }()
    
    let timePicker: UIDatePicker = {
        let dp = UIDatePicker()
        dp.locale = Locale.current
        dp.datePickerMode = .time
        dp.addTarget(self, action: #selector(handleTimePickerChange), for: .valueChanged)
        return dp
    }()
    
    let datePicker: UIDatePicker = {
        let dp = UIDatePicker()
        dp.locale = Locale.current
        dp.datePickerMode = .date
        dp.addTarget(self, action: #selector(handleDatePickerChange), for: .valueChanged)
        
        return dp
    }()
    
    var isNotificationOn: Bool?
    
    let notificationLabel: UILabel = {
        $0.text = "Notification"
        $0.textColor = .black
        $0.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        return $0
    }(UILabel(frame: .zero))
    
    let notificationSwitch: UISwitch = {
        $0.addTarget(self, action: #selector(handleNotificationSwitch), for: .valueChanged)
        return $0
    }(UISwitch(frame: .zero))
    
    var dailyItems: [DailyItems] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let fetchRequest = DailyItems.fetchRequest()
        dailyItems = try! coreDataStack!.managedContext.fetch(fetchRequest)
        view.backgroundColor = .white
        view.addSubview(whenLabel)
        view.addSubview(saveButton)
        whenLabel.text = "When?"
        whenLabel.centerInTop(padding: .init(top: 20, left: 0, bottom: 0, right: 0))
        saveButton.anchor(top: nil, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor, padding: .init(top: 0, left: 16, bottom: 0, right: 16),size: CGSize(width: 0, height: 60))
        
        dateLabel.text = "Date"
        timeLabel.text = "Time"
        checkPrevTime()
        buttonStackViewInit()
    }
    
    let her = PickTimeViewModel()
    
    fileprivate func checkPrevTime() {
        //MARK: TODO move to VM?
                let lastItem = dailyItems.filter { 
                  
                    $0.inDate?.onlyDate == datePicker.date.onlyDate }.last
                timePicker.date = lastItem?.inTime ?? Date()
    }
    
    @objc fileprivate func handleNotificationSwitch(_ sender: UISwitch) {
        isNotificationOn = sender.isOn
    }
    
    let todayButton: UIButton = {
        let button = UIButton()
        button.setTitle("Today", for: .normal)
        button.layer.cornerRadius = 10
        button.backgroundColor = .lightGray
        button.addTarget(self, action: #selector(handleDateChangeButton), for: .touchUpInside)
        return button
    }()
    
    let tommorowButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 10
        button.backgroundColor = .lightGray
        button.setTitle("Tommorow", for: .normal)
        button.addTarget(self, action: #selector(handleDateChangeButton), for: .touchUpInside)
        
        return button
    }()
    
    let pickDateButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 10
        button.backgroundColor = .lightGray
        button.setTitle("Pick date", for: .normal)
        return button
    }()
    
    fileprivate func buttonStackViewInit() {
        let horizontalStackView = UIStackView(arrangedSubviews: [todayButton, tommorowButton, datePicker])
        horizontalStackView.distribution = .fillEqually
        horizontalStackView.spacing = 10
        horizontalStackView.axis = .horizontal
        let notificationStackView = UIStackView(arrangedSubviews: [notificationLabel, notificationSwitch])
        view.addSubview(horizontalStackView)
        view.addSubview(notificationStackView)
        
        horizontalStackView.anchor(top: whenLabel.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: Padding.sixteen, left: Padding.sixteen, bottom: 0, right: Padding.sixteen))
        timePicker.preferredDatePickerStyle = .wheels
        view.addSubview(timePicker)
        timePicker.anchor(top: horizontalStackView.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: Padding.eight, left: Padding.sixteen, bottom: 0, right: Padding.sixteen))
        notificationStackView.anchor(top: timePicker.bottomAnchor, leading: view.leadingAnchor, bottom: saveButton.topAnchor, trailing: view.trailingAnchor, padding: .init(top: Padding.sixteen, left: Padding.sixteen, bottom: Padding.sixteen, right: Padding.sixteen))
        
       
    }
    
    
    var today = Date()
    
    @objc func handleDateChangeButton(_ sender: UIButton) {
        sender.isSelected = true
        sender.backgroundColor = .blue
        if sender == tommorowButton {
            date = vm.setPickerTime(date: Date(), datePicker: .tommorow)
        }
        if sender == todayButton {
            date = Date()
        }
        
    }
    
    @objc func handleTimePickerChange(sender: UIDatePicker) {
        sender.timeZone = .autoupdatingCurrent
        time = sender.date
        //        viewModel.timeBinding.value = sender.date
    }
    
    @objc func handleDatePickerChange(sender: UIDatePicker) {
        sender.timeZone = .autoupdatingCurrent
        date = sender.date
    }
       
    @objc func handleSaveButton(sender: UIButton) {
        vm.bindableDate.value = date
        if let time = time {
            dataSavedWithDate?(time, date ?? Date(), isNotificationOn)
        }
 
    }
}

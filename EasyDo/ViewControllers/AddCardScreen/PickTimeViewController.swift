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
    
    var isTimeChanged: Bool?
    
    var changeDate: ((Date) -> ())?
    var dataIsSaved: (() -> ())?
    
    let saveButton: UIButton = {
       let b = UIButton()
        b.setTitle("Save", for: .normal)
        b.backgroundColor = .darkGray
        b.addTarget(self, action: #selector(handleSaveButton), for: .touchUpInside)
        return b
    }()
    
    let datePicker: UIDatePicker = {
        let dp = UIDatePicker()
        dp.locale = Locale.current
        dp.datePickerMode = .time
        dp.addTarget(self, action: #selector(handleDatePickerChange), for: .editingDidEnd)
        
        return dp
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        view.addSubview(whenLabel)
        view.addSubview(datePicker)
        view.addSubview(saveButton)
        whenLabel.text = "When?"
        whenLabel.centerInTop(padding: .init(top: 20, left: 0, bottom: 0, right: 0))
        saveButton.centerInBottom()
        datePicker.centerInSuperview()
    
    }
    
    @objc func handleDatePickerChange(sender: UIDatePicker) {
        print("DATE IS ", sender.date)
        changeDate?(sender.date)
        isTimeChanged = true
    }
    
    @objc func handleSaveButton(sender: UIButton) {
        print("SAVED")
        dataIsSaved?()
    }
    
    
}
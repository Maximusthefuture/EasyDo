//
//  WeeklyPickerViewCell.swift
//  EasyDo
//
//  Created by Maximus on 17.01.2022.
//

import Foundation
import UIKit


class WeeklyPickerViewCell: UICollectionViewCell {
    
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                dayLabel.textColor = #colorLiteral(red: 0.5596068501, green: 0.5770205855, blue: 1, alpha: 1)
                dayLabel.font = UIFont.boldSystemFont(ofSize: 15)
                dayLabel.textColor = .black
                roundedView.backgroundColor = .blue
            } else {
                dayLabel.textColor = .black
                dayLabel.font = UIFont.boldSystemFont(ofSize: 14)
                circular.fillColor = nil
                roundedView.backgroundColor = #colorLiteral(red: 0.9722431302, green: 0.972392261, blue: 1, alpha: 1)
            }
        }
    }
    
    let dayLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        return label
    }()
    
    let roundedView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.9722431302, green: 0.972392261, blue: 1, alpha: 1)
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        return view
    }()
    
    func configure(date: Date?) {
        guard let date = date else {
            return
        }
        
        let attributedString = NSMutableAttributedString(string: " \(extractDate(date: date, format: "dd"))", attributes: [.font: UIFont.systemFont(ofSize: 13, weight: .bold)])
        dayLabel.attributedText = attributedString
        
        if isCurrentDate(date: date) {
            dayLabel.text = "Today"
            print("DATE IS: \(date)")
        }
    }
 
    let circular: CircularCheckBox = {
       let v = CircularCheckBox()
        v.strokeColor = UIColor.blue.cgColor
        return v
    }()
    
   
    func isCurrentDate(date: Date) -> Bool {
        let calendar = Calendar.current
        let day = calendar.component(.day, from: date)
        let currentDay = calendar.component(.day, from: Date())
        return day == currentDay
    }
    
    let pomodoroCount: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        label.textColor = .blue
        
        return label
    }()
    let pomodoroIcon: UIImageView = {
        let image = UIImage(named: "tomato")
        let imageView = UIImageView(image: image)
        return imageView
    }()
   
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(roundedView)
        roundedView.addSubview(dayLabel)
        contentView.addSubview(pomodoroIcon)
        pomodoroIcon.addSubview(pomodoroCount)
        pomodoroCount.text = "3"
        pomodoroCount.textColor = .black
        roundedView.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 0, left: 0, bottom: 8, right: 0),size: .init(width: 30, height: 30))
        dayLabel.fillSuperview()
        pomodoroIcon.anchor(top: roundedView.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0),size: .init(width: 0, height: 30))
        pomodoroCount.fillSuperview(padding: .init(top: 8, left: 0, bottom: 0, right: 0))
        if pomodoroCount.text == "0" {
            pomodoroIcon.isHidden = true
        }
    }
    
    func extractDate(date: Date, format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: date)
    }
  
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        dayLabel.textAlignment = .center
        pomodoroCount.textAlignment = .center
    }
}

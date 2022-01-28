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
//                roundedView.isHidden = false
                roundedView.backgroundColor = .blue
            } else {
                dayLabel.textColor = .black
                dayLabel.font = UIFont.boldSystemFont(ofSize: 14)
//                roundedView.isHidden = true
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
        view.layer.cornerRadius = 20
//        view.clipsToBounds = true
        view.layer.masksToBounds = true
        return view
    }()
    
    
    func configure(date: Date) {
        let attributedString = NSMutableAttributedString(string: " \(extractDate(date: date, format: "dd"))", attributes: [.font: UIFont.systemFont(ofSize: 13, weight: .bold)])
        attributedString.append(NSMutableAttributedString(string: "\n\(extractDate(date: date, format: "EEE"))", attributes: [.font: UIFont.systemFont(ofSize: 14, weight: .bold)]))
        dayLabel.attributedText = attributedString
        
        if isCurrentDate(date: date) {
//            isSelected = true
//            dayLabel.textColor = .blue
            dayLabel.text = "Today"
            print("DATE IS: \(date)")

        }
        
    }
    
   
    func isCurrentDate(date: Date) -> Bool {
        let calendar = Calendar.current
        let day = calendar.component(.day, from: date)
        let currentDay = calendar.component(.day, from: Date())
        return day == currentDay
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(roundedView)
        contentView.addSubview(dayLabel)
//        backgroundColor = .blue
        dayLabel.anchor(top: roundedView.topAnchor, leading: roundedView.leadingAnchor, bottom: roundedView.bottomAnchor, trailing: roundedView.trailingAnchor, padding: .init(top: 0, left: 8, bottom: 0, right: 0))
        roundedView.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor)
//        backgroundColor = .red
//        roundedView.isHidden = true
        
       
       
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
       
    }
    
    
    
}

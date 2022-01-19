//
//  Extensions.swift
//  EasyDo
//
//  Created by Maximus on 04.01.2022.
//

import Foundation
import UIKit





extension UIColor {
    func randomColor() -> UIColor {
       let red = CGFloat(arc4random_uniform(255)) / 255.0
       let green = CGFloat(arc4random_uniform(255)) / 255.0
       let blue = CGFloat(arc4random_uniform(255)) / 255.0
        
       return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
   }
}

extension UIView {
    func roundedView() -> UIView {
            self.layer.cornerRadius = 16
            self.backgroundColor = .white
//            self.layer.shadowColor = UIColor.gray.cgColor
//            self.layer.shadowOpacity = 10
//            self.layer.shadowOffset = .zero
//            self.layer.shadowRadius = 10
//            self.layer.masksToBounds = true
            return self
      
    }
}

extension BinaryFloatingPoint {
    func isAlmostEqual(to other: Self) -> Bool {
        abs(self - other) < abs(self + other).ulp
    }
}

extension CGRect {
    func isAlmostEqual(to other: CGRect) -> Bool {
        size.isAlmostEqual(to: other.size) && origin.isAlmostEqual(to: other.origin)
    }
    
    var center: CGPoint {
        get {
            CGPoint(x: midX, y: midY)
        }
        set {
            origin = CGPoint(x: newValue.x - width * 0.5, y: newValue.y - height * 0.5)
        }
    }
}

extension CGSize {
    func isAlmostEqual(to other: CGSize) -> Bool {
        width.isAlmostEqual(to: other.width) && height.isAlmostEqual(to: other.height)
    }
}

extension CGPoint {
    func isAlmostEqual(to other: CGPoint) -> Bool {
        x.isAlmostEqual(to: other.x) && y.isAlmostEqual(to: other.y)
    }
}

extension Date {
    
    
    func getStartOfDate() -> Date {
        let calendar = Calendar.current
        let dateFrom = calendar.startOfDay(for: self)
        let date = calendar.date(byAdding: .day, value: 1, to: dateFrom)
        
        return date ?? self
    }
    
   

        var onlyDate: Date {
            get {
                let calender = Calendar.current
                var dateComponents = calender.dateComponents([.year, .month, .day], from: self)
                dateComponents.hour = 0
                dateComponents.minute = 0
                dateComponents.second = 0
//                dateComponents.timeZone = NSTimeZone.system
                return calender.date(from: dateComponents) ?? self
            }
        }

    
  
    func format(format:String = "dd-MM-yyyy") -> Date {
             let dateFormatter = DateFormatter()
             dateFormatter.dateFormat = format
             let dateString = dateFormatter.string(from: self)
             if let newDate = dateFormatter.date(from: dateString) {
                 return newDate
             } else {
                 return self
             }
}
}



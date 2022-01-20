//
//  HDayPickerUICollectionView.swift
//  EasyDo
//
//  Created by Maximus on 17.01.2022.
//

import Foundation
import UIKit

protocol HDayPickerUICollectionViewDelegate: AnyObject {
    func filterTasksByDate(didSelectPredicate: NSPredicate?,
                           sortDescriptor: NSSortDescriptor?)
}

class HDayPickerUICollectionView: BaseListController {
    
    let dayPickerCellId = "dayPicker"
    weak var delegate: HDayPickerUICollectionViewDelegate?
    var selectedSortDescriptor: NSSortDescriptor?
    var selectedPredicate: NSPredicate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchCurrentWeek()
        if let layout = collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
            
        }
        collectionView.register(WeeklyPickerViewCell.self, forCellWithReuseIdentifier: dayPickerCellId)
        collectionView.backgroundColor = .white
        collectionView.showsHorizontalScrollIndicator = false
    }
    
    func setPredicateByDate(date: Date) -> NSPredicate{
        return NSPredicate(format: "%K == %@", #keyPath(DailyItems.inDate), date as NSDate)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return currentWeek.count
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    

    var currentWeek: [Date] = []
    
    //MARK: MOVE TO VIEWMODEL
    func fetchCurrentWeek() {
        let today = Date()
        let calendar = Calendar.current
        let week = calendar.dateInterval(of: .weekOfMonth, for: today)
        
        guard let firstWeekDay = week?.start else { return }
        
        (1...14).forEach { day in
            if let weekday = calendar.date(byAdding: .day, value: day, to: firstWeekDay) {
                currentWeek.append(weekday)
            }
        }
    }
    
    func extractDate(date: Date, format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: date)
    }
 
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: dayPickerCellId, for: indexPath) as! WeeklyPickerViewCell
        let date = currentWeek[indexPath.item]
        //AttributedText?
        let attributedString = NSMutableAttributedString(string: " \(extractDate(date: currentWeek[indexPath.item], format: "dd"))", attributes: [.font: UIFont.systemFont(ofSize: 13, weight: .bold)])
        attributedString.append(NSMutableAttributedString(string: "\n\(extractDate(date: currentWeek[indexPath.item], format: "EEE"))", attributes: [.font: UIFont.systemFont(ofSize: 14, weight: .bold)]))
        cell.dayLabel.attributedText = attributedString
        
        if date.getStartOfDate()  == Date().getStartOfDate() {
            cell.isSelected = true
        }
        return cell
    }
    
    
    func setSelectedItemFromScrollView(_ scrollView: UIScrollView) {
        if collectionView == scrollView {
            let center = CGPoint(x: scrollView.center.x + scrollView.contentOffset.x, y: scrollView.center.y + scrollView.contentOffset.y)
            let index = collectionView.indexPathForItem(at: center)
            if index != nil {
                collectionView.scrollToItem(at: index!, at: .centeredHorizontally, animated: true)
                self.collectionView.selectItem(at: index, animated: false, scrollPosition: [])
                self.collectionView(self.collectionView, didSelectItemAt: index!)
            }
        }
    }
    //MARK: TODO
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if collectionView == scrollView  {
            setSelectedItemFromScrollView(scrollView)
        }
    }
    
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if collectionView == scrollView && !decelerate {
            setSelectedItemFromScrollView(scrollView)
        }
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! WeeklyPickerViewCell
        
        let selectedDate = currentWeek[indexPath.item].getStartOfDate()
        selectedPredicate = setPredicateByDate(date: selectedDate)
        print(selectedDate)
        delegate?.filterTasksByDate(didSelectPredicate: selectedPredicate, sortDescriptor: selectedSortDescriptor)
    }
    
  
    
}

extension HDayPickerUICollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    
}

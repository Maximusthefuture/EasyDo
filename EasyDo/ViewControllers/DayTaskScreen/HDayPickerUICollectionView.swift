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
    var dayTaskViewModel: DayTasksViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchCurrentWeek()
//        if let layout = collectionViewLayout as? UICollectionViewFlowLayout {
//            layout.scrollDirection = .horizontal
//
//        }
        collectionView.collectionViewLayout = createLayout()
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
    
    
    func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout {
            (sectionIndex: Int, layoutEnviroment: NSCollectionLayoutEnvironment) ->
            NSCollectionLayoutSection? in
            
            let item1 = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.2), heightDimension: .fractionalHeight(0.4)))
            let group1 = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.7), heightDimension: .absolute(100)), subitems: [item1])
            let section = NSCollectionLayoutSection(group: group1)
            section.orthogonalScrollingBehavior = .groupPaging
            return section
        }
        return layout
    }
    

    var currentWeek: [Date] = []
    
    //MARK: MOVE TO VIEWMODEL
    func fetchCurrentWeek() {
        let today = Date()
        var calendar = Calendar.current
        let week = calendar.dateInterval(of: .weekOfMonth, for: today)
        calendar.timeZone = .autoupdatingCurrent
        guard let firstWeekDay = week?.start else { return }
        
        (0...30).forEach { day in
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
    
    func isCurrentDate(date: Date) -> Bool {
        let calendar = Calendar.current
        let day = calendar.component(.day, from: date)
        let currentDay = calendar.component(.day, from: Date())
        return day == currentDay
    }
 
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: dayPickerCellId, for: indexPath) as! WeeklyPickerViewCell
        let date = currentWeek[indexPath.item]
        cell.configure(date: date)
        if cell.isCurrentDate(date: date) {
            collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .bottom)
            
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
    
    //MARK: DON't WORK WITH UICollectionViewCompositionalLayout
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        if collectionView == scrollView  {
            setSelectedItemFromScrollView(scrollView)
//        }
    }
    
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
//        if collectionView == scrollView && !decelerate {
            setSelectedItemFromScrollView(scrollView)
//        }
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! WeeklyPickerViewCell
        let selectedDate = currentWeek[indexPath.item]
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

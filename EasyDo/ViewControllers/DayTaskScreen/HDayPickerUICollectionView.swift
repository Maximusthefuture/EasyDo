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
    var dayTaskViewModel: DayTaskViewModelProtocol?
    var currentWeek: [Date]?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        if let layout = collectionViewLayout as? UICollectionViewFlowLayout {
//            layout.scrollDirection = .horizontal
        collectionView.collectionViewLayout = createLayout()
        collectionView.register(WeeklyPickerViewCell.self, forCellWithReuseIdentifier: dayPickerCellId)
        collectionView.backgroundColor = .white
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.isScrollEnabled = false
    }
  
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dayTaskViewModel?.currentWeek.count ?? 0
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout {
            (sectionIndex: Int, layoutEnviroment: NSCollectionLayoutEnvironment) ->
            NSCollectionLayoutSection? in
            
            let item1 = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.2), heightDimension: .fractionalHeight(0.4)))
            let group1 = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(100)), subitem: item1, count: 7)
            group1.contentInsets = .init(top: 0, leading: 8, bottom: 0, trailing: 8)
            let section = NSCollectionLayoutSection(group: group1)
            section.interGroupSpacing = 16
            section.orthogonalScrollingBehavior = .groupPaging
            return section
        }
        return layout
    }
    
//    func configurePickerCell(cell: WeeklyPickerViewCell, indexPath: IndexPath) {
//        dayTaskViewModel?.currentWeekBindble.bind({ date in
//            let dateHere = date?[indexPath.item]
//            cell.configure(date: dateHere ?? Date())
//        })
//    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: dayPickerCellId, for: indexPath) as! WeeklyPickerViewCell
//        configurePickerCell(cell: cell, indexPath: indexPath)
        
        let date = dayTaskViewModel?.currentWeek[indexPath.item]
        guard let date = date else { return cell }
        cell.configure(date: date)
        if let dayTaskViewModel = dayTaskViewModel {
            if dayTaskViewModel.isCurrentDate(date: date) {
                collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .bottom)
            }
        }
        return cell
    }
   
    
//    func setSelectedItemFromScrollView(_ scrollView: UIScrollView) {
//        if collectionView == scrollView {
//            let center = CGPoint(x: scrollView.center.x + scrollView.contentOffset.x, y: scrollView.center.y + scrollView.contentOffset.y)
//            let index = collectionView.indexPathForItem(at: center)
//            if index != nil {
//                collectionView.scrollToItem(at: index!, at: .centeredHorizontally, animated: true)
//                self.collectionView.selectItem(at: index, animated: false, scrollPosition: [])
//                self.collectionView(self.collectionView, didSelectItemAt: index!)
//            }
//
//        }
//    }
    
//    //MARK: DON't WORK WITH UICollectionViewCompositionalLayout
//    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
////        if collectionView == scrollView  {
//            setSelectedItemFromScrollView(scrollView)
////        }
//    }
//    
//    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
////        if collectionView == scrollView && !decelerate {
//            setSelectedItemFromScrollView(scrollView)
////        }
//    }
//    
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! WeeklyPickerViewCell
        
        let selectedDate = dayTaskViewModel?.currentWeek[indexPath.item]
        guard let selectedDate = selectedDate else { return }
        selectedPredicate = dayTaskViewModel?.setPredicateByDate(date: selectedDate)
        print(selectedDate)
        delegate?.filterTasksByDate(didSelectPredicate: selectedPredicate, sortDescriptor: selectedSortDescriptor)
    }
    
  
    
}

extension HDayPickerUICollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
}

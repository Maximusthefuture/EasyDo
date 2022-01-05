//
//  DayTasksViewController.swift
//  EasyDo
//
//  Created by Maximus on 04.01.2022.
//

import UIKit
import CoreData

private let reuseIdentifier = "Cell"

//delegate doesn't work in AddDetailVC
protocol IsNeedToAddDayTaskDelegate: AnyObject {
    func isShowButton(vc: DayTasksViewController, show: Bool)
}

class DayTasksViewController: BaseListController {
    var addButton = UIButton()
    lazy var isAddMyDay: Bool = false
    weak var dayTaskDelegate: IsNeedToAddDayTaskDelegate?
    let coreDataStack = CoreDataStack(modelName: "EasyDo")
    var myDailyItems: [DailyItems] = []
    var fetchRequest: NSFetchRequest<DailyItems>?
    
    lazy var fetchedResultsController:
    NSFetchedResultsController<DailyItems> = {
        let fetchRequest: NSFetchRequest<DailyItems> = DailyItems.fetchRequest()
        let sort = NSSortDescriptor(key: #keyPath(DailyItems.inTime), ascending: true)
        fetchRequest.sortDescriptors = [sort]
        let fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: coreDataStack.managedContext,
            sectionNameKeyPath: nil,
            cacheName: nil)
        
        return fetchedResultsController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "My day"
        navigationController?.navigationBar.prefersLargeTitles = true
        do {
          try fetchedResultsController.performFetch()

        } catch let err as NSError {
          print("cannot fetch", err)
        }

        self.collectionView.register(DayTaskViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.backgroundColor = .white
        if let layout = collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .vertical
            layout.minimumInteritemSpacing = 0
            layout.minimumLineSpacing = 0
        }
        addButtonInit()
    }
    
    fileprivate func addButtonInit() {
        view.addSubview(addButton)
        addButton.anchor(top: nil, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor, padding: .init(top: 0, left: 16, bottom: 0, right: 16),size: CGSize(width: 0, height: 60))
        addButton.setTitle("+ Add Card", for: .normal)
        addButton.layer.cornerRadius = 10
        addButton.backgroundColor = .blue
        addButton.addTarget(self, action: #selector(addNewTask), for: .touchUpInside)
    }
    
    
    @objc fileprivate func addNewTask(sender: UIButton) {
//        let item = DailyItems(context: coreDataStack.managedContext)
//        let task = Task(context: coreDataStack.managedContext)
//        task.title = "NEW ITEMS"
//        item.inTime = Date()
//        item.task = task
//       try? coreDataStack.saveContext()
//        collectionView.reloadData()
        
        let vc = ViewController()
        self.isAddMyDay = true
        vc.isAddMyDay = self.isAddMyDay
        dayTaskDelegate?.isShowButton(vc: self, show: true)
        vc.coreDataStack = coreDataStack
        present(vc, animated: true)
//        array.add(delegate?) closure?
//        deleteAll()
    }
    
    func deleteAll() {
        let fetchRequest = DailyItems.fetchRequest()
        let item = try? coreDataStack.managedContext.fetch(fetchRequest)
        guard let item = item else { return }
        for i in item {
            coreDataStack.managedContext.delete(i)
        }
//            let item = DailyItems(context: coreDataStack.managedContext)

            coreDataStack.saveContext()
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
        // #warning Incomplete implementation, return the number of sections
//        return fetchedResultsController.sections?.count ?? 1
    }
    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if velocity.y > 0 {
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn) {
               
                self.addButton.transform = CGAffineTransform(translationX: 0, y: 100)

            }
        } else {
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn) {
                self.addButton.transform = CGAffineTransform(translationX: 0, y: 0)
                self.addButton.isHidden = false
            }
        }
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
//        return myDailyItems.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! DayTaskViewCell
        let items = fetchedResultsController.object(at: indexPath)
//        let items = myDailyItems[indexPath.item]
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .short
        cell.timeLabel.text = dateFormatter.string(from: items.inTime ?? Date())
        //        cell.backgroundColor = .red
        cell.taskLabel.text = items.task?.title
        if indexPath.item == 0 {
            cell.shapeLayer.removeFromSuperlayer()
  
        } else if indexPath.item == (collectionView.numberOfSections - 1) {
           
        }
        // Configure the cell
    
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        present(ViewController(), animated: true) {
//            print("COMPLETE HERE")
//        }
        
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */
    

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}

extension DayTasksViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 100)
    }
   
}

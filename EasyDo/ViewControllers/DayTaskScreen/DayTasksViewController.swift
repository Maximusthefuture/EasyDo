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

class DayTasksViewController: UIViewController {
    
    var addButton = UIButton()
    lazy var isAddMyDay: Bool = false
    weak var dayTaskDelegate: IsNeedToAddDayTaskDelegate?
    let coreDataStack = CoreDataStack(modelName: "EasyDo")
    var myDayLabel = UIButton()
  
    lazy var fetchedResultsController:
    NSFetchedResultsController<DailyItems> = {
        let fetchRequest: NSFetchRequest<DailyItems> = DailyItems.fetchRequest()
        let sort = NSSortDescriptor(key: #keyPath(DailyItems.inTime.timeIntervalSince1970), ascending: true)
        fetchRequest.sortDescriptors = [sort]
        let fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: coreDataStack.managedContext,
            sectionNameKeyPath: nil,
            cacheName: nil)
        
        return fetchedResultsController
    }()

    var tableView = UITableView()
    
    //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableViewInit()
        myDayLabelInit()
        navigationController?.navigationBar.isHidden = true
        view.backgroundColor = .white
        
        
        do {
          try fetchedResultsController.performFetch()

        } catch let err as NSError {
          print("cannot fetch", err)
        }
       
        fetchedResultsController.delegate = self

        addButtonInit()
    }
    
    fileprivate func tableViewInit() {
        view.addSubview(tableView)
        tableView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom:  view.bottomAnchor, trailing: view.trailingAnchor, padding: .init(top: 40, left: 0, bottom: 0, right: 0))
        tableView.register(DayTaskViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.backgroundColor = .white
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
    }
    
    
    fileprivate func myDayLabelInit() {
        view.addSubview(myDayLabel)
        myDayLabel.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: tableView.topAnchor, trailing: nil, padding: .init(top: 40, left: 16, bottom: 0, right: 0))
        myDayLabel.setTitle("My day", for: .normal)
        myDayLabel.titleLabel?.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        myDayLabel.setTitleColor(.black, for: .normal)
        let interaction = UIContextMenuInteraction(delegate: self)
        myDayLabel.showsMenuAsPrimaryAction = true
        self.myDayLabel.addInteraction(interaction)
       
        //MARK: TODO
        let menu = UIMenu(title: "", options: .destructive, children: [
            UIAction(title: "Projects")  { _ in
                let vc = ProjectsListViewController()
                vc.coreDataStack = self.coreDataStack
                //                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true)
            },
            UIAction(title: "????") { _ in
            }
        ])
        let duplicateAction = self.duplicateAction()
        let deleteAction = self.deleteAction()
        //Submenu
        let mainMenu = UIMenu(title: "", children: [duplicateAction, menu])
        myDayLabel.menu = mainMenu
       
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
        let vc = ProjectsListViewController()
        self.isAddMyDay = true
        vc.isAddMyDay = self.isAddMyDay
        dayTaskDelegate?.isShowButton(vc: self, show: true)
        vc.coreDataStack = coreDataStack
//        letsInsert()
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
            coreDataStack.saveContext()
    }
}

extension DayTasksViewController: UITableViewDataSource, UITableViewDelegate {
    
//    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
//           if velocity.y > 0 {
//               UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn) {
//
//                   self.addButton.transform = CGAffineTransform(translationX: 0, y: 100)
//
//               }
//           } else {
//               UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn) {
//                   self.addButton.transform = CGAffineTransform(translationX: 0, y: 0)
//                   self.addButton.isHidden = false
//               }
//           }
//       }

  
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let scrollViewContentHeight = scrollView.contentSize.height
//        let scrollViewHeight = scrollView.frame.height
//
//
//        if scrollView.contentOffset.y < (scrollViewContentHeight - scrollViewHeight){
//            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn) {
//                self.addButton.transform = CGAffineTransform(translationX: 0, y: 0)
//                self.addButton.isHidden = false
//            }
//        } else {
//            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn) {
//                self.addButton.transform = CGAffineTransform(translationX: 0, y: 100)
//
//            }
//        }
//    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 0
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //When we have time difference, change count?????
        //or change section count?? use section intead of new cell???
        return fetchedResultsController.sections![section].numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            let fetchRequest = DailyItems.fetchRequest()
            let item = try? coreDataStack.managedContext.fetch(fetchRequest)
            item?[indexPath.row].task?.mainTag = "Done"
            coreDataStack.managedContext.delete(item![indexPath.row])
            coreDataStack.saveContext()
        }
    }
    
    func configure(cell: UITableViewCell, for indexPath: IndexPath) {
        guard let cell = cell as? DayTaskViewCell else { return }
        let items = fetchedResultsController.object(at: indexPath)
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .short
        dateFormatter.dateFormat = "HH:mm"
        cell.timeLabel.text = dateFormatter.string(from: items.inTime ?? Date())
        var d = dateFormatter.string(from: items.inTime ?? Date())
        //        cell.backgroundColor = .red
        cell.taskLabel.text = items.task?.title
    }
    
    func letsInsert() {
        let index = IndexPath(row: 1, section: 0)
        tableView.insertRows(at: [index], with: .automatic)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let items = fetchedResultsController.object(at: indexPath)

            let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! DayTaskViewCell
            configure(cell: cell, for: indexPath)
            if indexPath.item == 0 {
                cell.shapeLayer.removeFromSuperlayer()
                
            } else if indexPath.item == (tableView.numberOfSections - 1) {
                
            }
            return cell
    }
    
    func compateDates() {
        let calendar = Calendar.current
//        let hour = calendar.component(.hour, from: items.inTime ?? Date())
//        tableView.insertRows(at: <#T##[IndexPath]#>, with: <#T##UITableView.RowAnimation#>)
//        let nextTime = calendar.component(.hour, from: nextItem?.inTime ?? Date())
        
//        if hour < nextTime {
//
//            print("HOUR: \(indexPath.row)")
//            //        }
//            //промежуток времени
//            //        if hour > nextItemHour  {
//            //
//            //
//        } else {
        
        
        //        if indexPath.row == 1 {
        //            let cell2 = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        //                                  cell2.textLabel?.text = "HER"
        //                                  return cell2
        //        }
                
        //        if equals(indexA: indexPath, indexB: indexPath) {
        //            let cell2 = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        //                       cell2.textLabel?.text = "HER"
        //                       return cell2
        //        } else {
                
        
//        if indexPath.row == fetchedResultsController.fetchedObjects?.count {
//            print("EQUALS")
//        }
    }
    
    func equals(indexA: IndexPath, indexB: IndexPath) -> Bool {
        let calendar = Calendar.current
        let items = fetchedResultsController.object(at: indexA)
        let hour = calendar.component(.hour, from: items.inTime ?? Date())
        let nextItem = fetchedResultsController.object(at: indexB)
        let nextHour = calendar.component(.hour, from: nextItem.inTime ?? Date())
        let difference = hour - nextHour
//        let formatter = DateFormatter()
//        formatter.dateFormat = "yyyy/MM/dd HH:mm"
//        let xmas = formatter.for
//        let newYear = formatter.date(from: nextItem.inTime!)
//        print("DIFFERENCE: \(difference)")
        return (nextItem.inTime?.timeIntervalSince1970.asMinutes())! - (items.inTime?.timeIntervalSinceNow.asMinutes())! > 30 ? true : false
        }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let item = fetchedResultsController.object(at: indexPath).task else { return }
               let vc = AddEditCardViewController()
               vc.coreDataStack = coreDataStack
               vc.taskDetail = item
               present(vc, animated: true)
    }
}


extension DayTasksViewController {
    func inspectAction() -> UIAction {
        return UIAction(title: NSLocalizedString("InspectTitle", comment: ""),
                        image: UIImage(systemName: "arrow.up.square")) { action in
           
        }
    }
        
    func duplicateAction() -> UIAction {
        return UIAction(title: NSLocalizedString("DuplicateTitle", comment: ""),
                        image: UIImage(systemName: "plus.square.on.square")) { action in
           
        }
    }
    func deleteAction() -> UIAction {
        return UIAction(title: NSLocalizedString("DeleteTitle", comment: ""),
                        image: UIImage(systemName: "trash"),
                        attributes: .destructive) { action in
//           self.performDelete()
        }
    }
}
//MARK: UIContextMenuInteractionDelegate
extension DayTasksViewController: UIContextMenuInteractionDelegate {
    
    
func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
    let configuration = UIContextMenuConfiguration(identifier: NSString(""), previewProvider: nil) { (elements) -> UIMenu? in
        
      
        guard self.myDayLabel != nil else { return nil }
        let inspectAction = self.inspectAction()
        let duplicateAction = self.duplicateAction()
        let deleteAction = self.deleteAction()
        let editMenu = UIMenu(title: NSLocalizedString("EditTitle", comment: ""),
                              children: [duplicateAction, deleteAction])
        return UIMenu(title: "", children: [inspectAction, editMenu])
    }
    return configuration
    
}
    
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, previewForHighlightingMenuWithConfiguration configuration: UIContextMenuConfiguration) -> UITargetedPreview? {
        let parameters = UIPreviewParameters()
        parameters.backgroundColor = UIColor.clear
        let visibleRect = myDayLabel.bounds.insetBy(dx: -10, dy: -10)
        let visiblePath = UIBezierPath(roundedRect: visibleRect, cornerRadius: 10.0)
        parameters.visiblePath = visiblePath
        return UITargetedPreview(view: myDayLabel, parameters: parameters)
    }
    
}

//MARK: NSFetchedResultsControllerDelegate
extension DayTasksViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .automatic)
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .automatic)
        case .update:
            let cell = tableView.cellForRow(at: indexPath!) as! DayTaskViewCell
            configure(cell: cell, for: indexPath!)
            
        case .move:
            tableView.deleteRows(at: [indexPath!], with: .automatic)
            tableView.insertRows(at: [newIndexPath!], with: .automatic)
        @unknown default:
            print("Unexpected NSFetchesultChangeType")
        }
    }
    
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
}


extension Date {
    static func - (lhs: Date, rhs: Date) -> TimeInterval {
        return lhs.timeIntervalSinceReferenceDate - rhs.timeIntervalSinceReferenceDate
    }
}
extension TimeInterval {
    func asMinutes() -> Double { return self / (60.0) }
}


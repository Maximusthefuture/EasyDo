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
        let sort = NSSortDescriptor(key: #keyPath(DailyItems.inTime), ascending: true)
        fetchRequest.sortDescriptors = [sort]
        let fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: coreDataStack.managedContext,
            sectionNameKeyPath: nil,
            cacheName: nil)
        
        return fetchedResultsController
    }()

    var tableView = UITableView()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView)
        tableView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom:  view.bottomAnchor, trailing: view.trailingAnchor, padding: .init(top: 40, left: 0, bottom: 0, right: 0))
        myDayLabelInit()
        navigationController?.navigationBar.isHidden = true
        view.backgroundColor = .white
        
        do {
          try fetchedResultsController.performFetch()

        } catch let err as NSError {
          print("cannot fetch", err)
        }
        tableView.register(DayTaskViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.backgroundColor = .white
        tableView.delegate = self
        tableView.dataSource = self
        addButtonInit()
    }
    
    
    fileprivate func myDayLabelInit() {
        view.addSubview(myDayLabel)
        myDayLabel.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: tableView.topAnchor, trailing: nil, padding: .init(top: 40, left: 16, bottom: 0, right: 0))
        myDayLabel.setTitle("My day", for: .normal)
        myDayLabel.titleLabel?.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        myDayLabel.setTitleColor(.black, for: .normal)
        let interaction = UIContextMenuInteraction(delegate: self)
        self.myDayLabel.addInteraction(interaction)
        //MARK: TODO
        let menu = UIMenu(title: "", options: .destructive, children: [
            UIAction(title: "Projects")  { _ in
                let vc = ViewController()
                vc.coreDataStack = self.coreDataStack
                //                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true)
            },
            UIAction(title: "????") { _ in
            }
        ])
        myDayLabel.menu = menu
        myDayLabel.showsMenuAsPrimaryAction = true
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
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            let fetchRequest = DailyItems.fetchRequest()
            let item = try? coreDataStack.managedContext.fetch(fetchRequest)
            coreDataStack.managedContext.delete(item![indexPath.row])
            coreDataStack.saveContext()
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! DayTaskViewCell
                let items = fetchedResultsController.object(at: indexPath)
                let dateFormatter = DateFormatter()
                dateFormatter.dateStyle = .none
                dateFormatter.timeStyle = .short
                dateFormatter.dateFormat = "HH:mm"
                cell.timeLabel.text = dateFormatter.string(from: items.inTime ?? Date())
                //        cell.backgroundColor = .red
                cell.taskLabel.text = items.task?.title
                if indexPath.item == 0 {
                    cell.shapeLayer.removeFromSuperlayer()
        
                } else if indexPath.item == (tableView.numberOfSections - 1) {
        
                }
                return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let item = fetchedResultsController.object(at: indexPath).task else { return }
               let vc = AddDetailViewController()
               vc.coreDataStack = coreDataStack
               vc.taskDetail = item
               present(vc, animated: true)
    }
}

extension DayTasksViewController: UIContextMenuInteractionDelegate {
    
func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
    let configuration = UIContextMenuConfiguration(identifier: NSString(""), previewProvider: nil) { (elements) -> UIMenu? in
        guard self.myDayLabel != nil else { return nil }
        let menu = UIMenu(title: "HI", options: .destructive, children: [
            UIAction(title: "Hello", attributes: .disabled, state: .mixed)  { _ in
                
            },
            UIAction(title: "Projects", attributes: .destructive, state: .on) { _ in
            }
        ])
        return menu
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


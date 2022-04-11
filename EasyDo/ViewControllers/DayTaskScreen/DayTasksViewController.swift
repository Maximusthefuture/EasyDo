//
//  DayTasksViewController.swift
//  EasyDo
//
//  Created by Maximus on 04.01.2022.
//

import UIKit
import CoreData
import SwiftUI


class DayTasksViewController: UIViewController {
    private let reuseIdentifier = "Cell"
    //MARK: ?????
    let container = DependencyContainer()
    
    var dayTaskViewModel: DayTaskViewModelProtocol?
    
    
    init(viewModel: DayTaskViewModelProtocol) {
        self.dayTaskViewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let addButton: UIButton = {
        let button = UIButton()
        button.setTitle("+ Add Card", for: .normal)
        button.layer.cornerRadius = 10
        button.backgroundColor = .blue
        button.addTarget(self, action: #selector(goToProjectList), for: .touchUpInside)
        return button
    }()
    
    let viewWithCorners = ViewWithCorners()
    
    lazy var isAddMyDay: Bool = false
    var myDayLabel = UIButton()
    var tableView = UITableView()
    
    let emptyLabel: UIButton = {
        let button = UIButton()
        button.setTitle("NOTHING HERE Add item +", for: .normal)
        button.backgroundColor = .blue
        button.layer.cornerRadius = 10
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(handleEmptyLabelTap), for: .touchUpInside)
        return button
    }()
    var weeklyPickerCollectionView = HDayPickerUICollectionView()
    var fetchRequest: NSFetchRequest<DailyItems>?
    
    lazy var selectionGenerator = UISelectionFeedbackGenerator()
    
    lazy var fetchedResultsController:
    NSFetchedResultsController<DailyItems> = {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day, .month, .weekday], from: Date())
        var date = calendar.date(from: components)
        let sort = NSSortDescriptor(key: #keyPath(DailyItems.inTime.timeIntervalSince1970), ascending: true)
        fetchRequest?.sortDescriptors = [sort]
        fetchRequest?.predicate = NSPredicate(format: "%K == %@", #keyPath(DailyItems.inDate), Date().onlyDate as NSDate)
        guard let fetchRequest = fetchRequest,
              let coreDataStack = dayTaskViewModel?.coreDataStack else { return NSFetchedResultsController() }
        
        let fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: coreDataStack.managedContext,
            sectionNameKeyPath: nil,
            cacheName: nil)
        return fetchedResultsController
    }()
    
    var stackView: UIStackView?
    var array = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
    //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        fetchRequest = DailyItems.fetchRequest()
        weeklyPickerCollectionView.delegate = self
        myDayLabelInit()
        initStackViewDayWeek()
        
        initWeeklyDayPickerCollection()
        weeeklyGoalViewTest()
        tableViewInit()
        navigationController?.navigationBar.isHidden = true
        emptyLabelInit()
        weeklyPickerCollectionView.dayTaskViewModel = dayTaskViewModel
        
        do {
            try fetchedResultsController.performFetch()
            
        } catch let err as NSError {
            print("cannot fetch", err)
        }
        
        fetchedResultsController.delegate = self
        addButtonInit()
    }
    
    //MARK: TODO
    fileprivate func weeeklyGoalViewTest() {
        view.addSubview(viewWithCorners)
        viewWithCorners.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: nil, bottom: myDayLabel.bottomAnchor, trailing: view.trailingAnchor,padding: .init(top: 0, left: 30, bottom: 0, right: 16), size: .init(width: 200, height: 40))
        viewWithCorners.label.text = dayTaskViewModel?.weeklyGoalTitle
        viewWithCorners.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapWeeklyGoal)))
    }
    
    fileprivate func initStackViewDayWeek() {
        stackView = UIStackView()
        for dayOfWeek in array {
            let label = UILabel()
            label.text = dayOfWeek
            stackView?.addArrangedSubview(label)
        }
        view.addSubview(stackView!)
        stackView?.axis = .horizontal
        stackView?.distribution = .fillEqually
        stackView?.anchor(top: myDayLabel.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 0, left: 8, bottom: 0, right: 8))
    }
    
    @objc func handleTapWeeklyGoal() {
        var edit = ""
        let alert = UIAlertController(title: dayTaskViewModel?.weeklyGoalTitle, message: dayTaskViewModel?.weekltyGoalDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: { alert in
            self.dismiss(animated: true)
        }))
        if dayTaskViewModel!.isHaveWeeklyItem() {
            edit = "Edit"
        } else {
            edit = "Add"
            alert.addTextField { textField in
                textField.placeholder = "Title"
                
            }
            alert.addTextField { textField in
                textField.placeholder = "Description"
            }
        }
        alert.addAction(UIAlertAction(title: edit, style: .default, handler: { [weak self] action in
            if action.title == "Edit" {
                self?.showEditingAlert()
            } else {

                self?.dayTaskViewModel?.saveWeeklyGoalItem(title: alert.textFields!.first!.text, description: alert.textFields![1].text)
            }
            
        }))
        
        self.present(alert, animated: true, completion: nil)
    
    }
    
    func showEditingAlert() {
        let newEditingAlert = UIAlertController(title: "Editing", message: "", preferredStyle: .alert)
        newEditingAlert.addTextField { textField in
            
        }
        newEditingAlert.addTextField { textField in
            
        }
        newEditingAlert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: { alert in
            self.dismiss(animated: true)
        }))
       
        newEditingAlert.addAction(UIAlertAction(title: "Save", style: .default, handler: { [weak self] action in
            self?.dayTaskViewModel?.saveWeeklyGoalItem(title: newEditingAlert.textFields!.first!.text, description: newEditingAlert.textFields![1].text)
            self?.viewWithCorners.label.text = newEditingAlert.textFields!.first!.text
        }))
        present(newEditingAlert, animated: true, completion: nil)
    }
 
    fileprivate func emptyLabelInit() {
        //        emptyLabel.text = " "
        view.addSubview(emptyLabel)
        emptyLabel.centerInSuperview()
        emptyLabel.isHidden = true
    }
    
    //MARK: TODO
    @objc func handleEmptyLabelTap() {
        print("handle here")
        //push with animation????
    }
    
    fileprivate func tableViewInit() {
        view.addSubview(tableView)
        tableView.anchor(top: weeklyPickerCollectionView.view.bottomAnchor, leading: view.leadingAnchor, bottom:  view.bottomAnchor, trailing: view.trailingAnchor, padding: .init(top: 16, left: 0, bottom: 0, right: 0))
        tableView.register(DayTasksViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        //        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.backgroundColor = .white
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 500
        
    }
    
    fileprivate func initWeeklyDayPickerCollection() {
        view.addSubview(weeklyPickerCollectionView.view)
        weeklyPickerCollectionView.view.anchor(top: stackView?.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0),size: .init(width: 0, height: 60))
    }
    
    fileprivate func myDayLabelInit() {
        view.addSubview(myDayLabel)
        myDayLabel.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 40, left: 16, bottom: 0, right: 0))
        myDayLabel.setTitle("My day", for: .normal)
        myDayLabel.titleLabel?.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        myDayLabel.setTitleColor(.black, for: .normal)
        let interaction = UIContextMenuInteraction(delegate: self)
        myDayLabel.showsMenuAsPrimaryAction = true
        self.myDayLabel.addInteraction(interaction)
        contextMenuLabel()
    }
    
    fileprivate func contextMenuLabel() {
        //MARK: TODO
        let menu = UIMenu(title: "", options: .destructive, children: [
            UIAction(title: "Projects")  { _ in
                let vc = ProjectsListViewController()
                //                vc.coreDataStack = dayTaskViewModel?.coreDataStack
                self.present(vc, animated: true)
            },
            UIAction(title: "????") { [weak self] _ in
                self?.fetchRequest?.predicate = nil
                self?.fetchAndReload()
            }
        ])
        let duplicateAction = self.duplicateAction()
        //        let deleteAction = self.deleteAction()
        //Submenu
        let mainMenu = UIMenu(title: "", children: [duplicateAction, menu])
        myDayLabel.menu = mainMenu
    }
    
    //MARK: ADD to external file
    fileprivate func addButtonInit() {
        view.addSubview(addButton)
        addButton.anchor(top: nil, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor, padding: .init(top: 0, left: 16, bottom: 0, right: 16),size: CGSize(width: 0, height: 60))
        
    }
    
    //MARK: Move to VM
    func isCurrentHour(date: Date) -> Bool {
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let currentHour = calendar.component(.hour, from: Date())
        return hour == currentHour
    }
    
    //MARK: Change this to addEditVC
    //then add project selection when card create
    @objc fileprivate func goToProjectList(sender: UIButton) {
        let vc = container.makeProjectListViewController()
        self.isAddMyDay = true
        vc.isAddMyDay = self.isAddMyDay
        present(vc, animated: true)
    }
    
    
    //MARK: DELETE
    func deleteAll() {
        guard let fetchRequest = fetchRequest else {
            return
        }
        let item = try? dayTaskViewModel?.coreDataStack?.managedContext.fetch(fetchRequest)
        guard let item = item else { return }
        for i in item {
            dayTaskViewModel?.coreDataStack?.managedContext.delete(i)
        }
        dayTaskViewModel?.coreDataStack?.saveContext()
    }
    
    let image = UIImage(systemName: "trash")?.withTintColor(.red, renderingMode: .alwaysOriginal)
    
}

extension DayTasksViewController: HDayPickerUICollectionViewDelegate {
    func filterTasksByDate(didSelectPredicate: NSPredicate?, sortDescriptor: NSSortDescriptor?) {
        guard let fetchRequest = fetchRequest else { return }
        fetchRequest.predicate = nil
        fetchRequest.predicate = didSelectPredicate
        if let sort = sortDescriptor {
            fetchRequest.sortDescriptors = [sort]
        }
        fetchAndReload()
    }
}
extension DayTasksViewController {
    
    fileprivate func checkIsItemsEmpty() {
        guard let isFetchedControllerNotEmpty = fetchedResultsController.fetchedObjects?.isEmpty else { return }
        if  isFetchedControllerNotEmpty {
            emptyLabel.isHidden = false
        } else {
            emptyLabel.isHidden = true
        }
    }
    
    func fetchAndReload() {
        try? fetchedResultsController.performFetch()
        checkIsItemsEmpty()
        tableView.reloadData()
    }
    
}

extension DayTasksViewController: UITableViewDataSource, UITableViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        addButton.isHidden = true
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        addButton.isHidden = false
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 0
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //When we have time difference, change count?????
        //or change section count?? use section intead of new cell???
        return fetchedResultsController.sections![section].numberOfObjects
    }
    
    //MARK: Move to cell????
    func configure(cell: UITableViewCell, for indexPath: IndexPath) {
        guard let cell = cell as? DayTasksViewCell else { return }
        let items = fetchedResultsController.object(at: indexPath)
        
        //MARK: MOve to cell or VM?
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .short
        dateFormatter.dateFormat = "HH:mm"
        cell.taskLabel.text = items.task?.title
        cell.taskDescription.text = items.task?.taskDescription
        cell.tagView.label.text = dateFormatter.string(from: items.inTime ?? Date())
        if indexPath.row != 1 && indexPath.row != 0 {
            cell.tagView.isHidden = true
            cell.taskDescription.isHidden = true
            cell.taskDescription.text = ""
            cell.tagView.label.text = ""
        } else {
            cell.tagView.isHidden = false
            cell.taskDescription.isHidden = false
        }
    }
    
    func letsInsert() {
        let index = IndexPath(row: 1, section: 0)
        tableView.insertRows(at: [index], with: .automatic)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! DayTasksViewCell
        configure(cell: cell, for: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let item = fetchedResultsController.object(at: indexPath).task else { return }
        let vc = container.addEditTaskViewController(task: item, state: .edit, currentProject: item.project)
        present(vc, animated: true)
    }
    
    
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction =  UIContextualAction(style: .destructive, title: nil) { [unowned self] (action, swipeButtonView, completion) in
            guard let fetchRequest = self.fetchRequest  else { return }
            self.dayTaskViewModel?.deleteItem(indexPath: indexPath.row, fetchRequest: fetchRequest)
            completion(true)
        }
        let largeFont = UIFont.systemFont(ofSize: 60)
        let configuration = UIImage.SymbolConfiguration(font: largeFont)
        let image = UIImage(systemName: "trash", withConfiguration: configuration)?.withTintColor(.red, renderingMode: .alwaysOriginal)
        deleteAction.image = image
        deleteAction.backgroundColor = .white
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let moveToNextDayAction =  UIContextualAction(style: .destructive, title: nil) { (action, swipeButtonView, completion) in
            guard let fetchRequest = self.fetchRequest  else { return }
            self.dayTaskViewModel?.moveToNextDay(indexPath: indexPath.row, fetchRequest: fetchRequest)
            completion(true)
        }
        let largeFont = UIFont.systemFont(ofSize: 60)
        let configuration = UIImage.SymbolConfiguration(font: largeFont)
        let image = UIImage(systemName: "arrow.right", withConfiguration: configuration)?.withTintColor(.blue, renderingMode: .alwaysOriginal)
        moveToNextDayAction.image = image
        
        moveToNextDayAction.backgroundColor = .white
        return UISwipeActionsConfiguration(actions: [moveToNextDayAction])
    }
}

//MARK: UIContextMenuInteractionDelegate
extension DayTasksViewController: UIContextMenuInteractionDelegate {
    
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        let configuration = UIContextMenuConfiguration(identifier: NSString(utf8String: "Menu"), previewProvider: nil) { (elements) -> UIMenu? in
            let inspectAction = self.inspectAction()
            let duplicateAction = self.duplicateAction()
            let deleteAction = self.deleteAction()
            let editMenu = UIMenu(title: NSLocalizedString("EditTitle", comment: ""),
                                  children: [duplicateAction, deleteAction])
            return UIMenu(title: "Project", children: [inspectAction, editMenu])
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

extension DayTasksViewController {
    func inspectAction() -> UIAction {
        return UIAction(title: NSLocalizedString("InspectTitle", comment: ""),
                        image: UIImage(systemName: "arrow.up.square")) { action in
            
        }
    }
    
    func duplicateAction() -> UIAction {
        return UIAction(title: NSLocalizedString("DuplicateTitle", comment: ""),
                        image: UIImage(systemName: "plus.square.on.square")) { action in
            print("DUPLICATE")
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








//
//  AddDetailViewController.swift
//  EasyDo
//
//  Created by Maximus on 03.01.2022.
//

import UIKit




class AddDetailViewController: UIViewController, IsNeedToAddDayTaskDelegate {
    
    func isShowButton(vc: DayTasksViewController, show: Bool) {
        addButton.isHidden = false
        print("SHOW: \(show)")
        vc.dayTaskDelegate = self
    }

    
    let cardName: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Enter card title"
        tf.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        return tf
    }()
    
    let cardDescription: UITextView = {
        let tf = UITextView()
        tf.font = UIFont.systemFont(ofSize: 13)
        tf.textContainer.maximumNumberOfLines = 2
        tf.textContainer.lineBreakMode = .byTruncatingTail
        tf.text = "Some description here tap to change"
        tf.isEditable = true
        //        tf.layer.masksToBounds = true
        //        tf.layer.backgroundColor = UIColor.blue.cgColor
        
        return tf
    }()
    
    
    var task: Task?
    var isAddMyDay: Bool?
    var addButton = UIButton()
    
    var currentProject: Project?
    var coreDataStack: CoreDataStack?
    var dayVC: DayTasksViewController?
    
    fileprivate func addButtonInit() {
        view.addSubview(addButton)
        addButton.anchor(top: nil, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor, padding: .init(top: 0, left: 16, bottom: 0, right: 16),size: CGSize(width: 0, height: 60))
        addButton.setTitle("+ Add Card", for: .normal)
        addButton.layer.cornerRadius = 10
        addButton.backgroundColor = .blue
        addButton.addTarget(self, action: #selector(addCardToDayTask), for: .touchUpInside)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(close))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneCreatingEditing))
        view.addSubview(cardName)
        view.addSubview(cardDescription)
        cardName.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 0, left: 16, bottom: 0, right: 0))
        cardDescription.anchor(top: cardName.bottomAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, padding: .init(top: 16, left: 16, bottom: 0, right: 16))
        addButtonInit()
        addButton.isHidden = true
        dayVC = DayTasksViewController()
        dayVC?.dayTaskDelegate = self
        guard let isAddMyDay = isAddMyDay else { return }
        if isAddMyDay {
           addButton.isHidden = false
        }
        cardName.text = task?.title
        cardDescription.text = task?.taskDescription
        
        
    }
    
    @objc func close() {
        dismiss(animated: true)
    }
    
    @objc fileprivate func doneCreatingEditing(sender: UIBarButtonItem) {
        print("Done editing save")
        initCoreDataDummyData()
//        navigationController?.popViewController(animated: true)
        dismiss(animated: true)
    }
    
    @objc fileprivate func addCardToDayTask(sender: UIButton) {
        //add task to new db?
        print("ADD TASK: \(task?.title)")
        guard let coreDataStack = coreDataStack else { return }
        var dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .short
        let dailyItem = DailyItems(context: coreDataStack.managedContext)
        dailyItem.task = task
        dailyItem.inTime = Date()
        coreDataStack.saveContext()
        
    }
    
    
    func initCoreDataDummyData() {
        if let coreDataStack = coreDataStack {
            let task = Task(context: coreDataStack.managedContext)
            task.tags = ["No tag"]
            task.mainTag = "No tag"
            task.title = cardName.text
            task.taskDescription = cardDescription.text
            if let project = currentProject,
               let tasks = project.tasks?.mutableCopy() as? NSMutableOrderedSet {
                tasks.add(task)
                project.tasks = tasks
            }
            coreDataStack.saveContext()
//            collectionView.reloadData()
//            changeDelegate = self
        }
        
        
    }
    
    

}
//
//extension AddDetailViewController: IsNeedToAddDayTaskDelegate {
//    func isShowButton(show: Bool) {
//
//    }
//
//
//}

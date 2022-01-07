//
//  AddDetailViewController.swift
//  EasyDo
//
//  Created by Maximus on 03.01.2022.
//

import UIKit




class AddEditCardViewController: UIViewController {
    

    let cardName: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Enter card title"
        tf.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        return tf
    }()
    
    let cardDescription: UITextView = {
        let tf = UITextView()
        tf.font = UIFont.systemFont(ofSize: 13)
        tf.textContainer.maximumNumberOfLines = 3
        tf.textContainer.lineBreakMode = .byTruncatingTail
        tf.text = "Some description here tap to change"
        tf.isEditable = true
        //        tf.layer.masksToBounds = true
        //        tf.layer.backgroundColor = UIColor.blue.cgColor
        
        return tf
    }()
    
    
    
    var isAddMyDay: Bool?
    var addButton = UIButton()
    let cellId = "CellID"
    let propertiesCell = "PropertiesCell"
    let attachmentsCell = "attachmentsCell"
    var currentProject: Project?
    var coreDataStack: CoreDataStack?
    var dayVC: DayTasksViewController?
    var taskDetail: Task?
    var tableView = UITableView()

    fileprivate func initViews() {
        view.addSubview(cardName)
        view.addSubview(cardDescription)
        cardName.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 0, left: 16, bottom: 0, right: 0))
        cardDescription.anchor(top: cardName.bottomAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, padding: .init(top: 16, left: 16, bottom: 0, right: 16))
        
    }
    
    //MARK: Init tableView
    fileprivate func initTableView() {
        view.addSubview(tableView)
        tableView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        tableView.register(AddEditCardPropertiesViewCell.self, forCellReuseIdentifier: propertiesCell)
        tableView.register(AttachmentsCardViewCell.self, forCellReuseIdentifier: attachmentsCell)
        
    }
    
    lazy var header: UIView = {
        let header = UIView()
        header.addSubview(cardName)
        header.addSubview(cardDescription)
        header.backgroundColor = .yellow
        cardName.anchor(top: header.topAnchor, leading: header.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 0, left: 16, bottom: 0, right: 0))
        cardDescription.anchor(top: cardName.bottomAnchor, leading: header.leadingAnchor, bottom: header.bottomAnchor, trailing: header.trailingAnchor, padding: .init(top: 16, left: 16, bottom: 0, right: 16))
        return header
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(close))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneCreatingEditing))
//        initViews()
        addButtonInit()
        initTableView()
        
        addButton.isHidden = true
        guard let isAddMyDay = isAddMyDay else { return }
        if isAddMyDay {
           addButton.isHidden = false
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cardName.text = taskDetail?.title
        cardDescription.text = taskDetail?.taskDescription
    }
    
    @objc func close() {
        dismiss(animated: true)
    }
    
    @objc fileprivate func doneCreatingEditing(sender: UIBarButtonItem) {
        print("Done editing save")
        initCoreDataDummyData()
        dismiss(animated: true)
        
    }
    
    fileprivate func addButtonInit() {
        view.addSubview(addButton)
        addButton.anchor(top: nil, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor, padding: .init(top: 0, left: 16, bottom: 0, right: 16),size: CGSize(width: 0, height: 60))
        addButton.setTitle("+ Add Card", for: .normal)
        addButton.layer.cornerRadius = 10
        addButton.backgroundColor = .blue
        addButton.addTarget(self, action: #selector(addCardToDayTask), for: .touchUpInside)
    }
    
    @objc fileprivate func addCardToDayTask(sender: UIButton) {
        if let coreDataStack = coreDataStack {
            let dailyItem = DailyItems(context: coreDataStack.managedContext)
            dailyItem.task = taskDetail
            dailyItem.inTime = Date()
            taskDetail?.mainTag = "In Progress"
            coreDataStack.saveContext()
            dismiss(animated: true)
        } else {
            print("NULL NULL NULL")
        }
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
        }
    }
    
    class HeaderLabel: UILabel {
        override func drawText(in rect: CGRect) {
            super.drawText(in: rect.insetBy(dx: 16, dy: 0))
        }
    }

}

extension AddEditCardViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 0
        } else if section == 1 {
            return 3
        }
        
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
       let headerLabel = HeaderLabel()
    switch section {
    case 0: return header
    case 1: headerLabel.text = "Properties"
    case 2: headerLabel.text = "Attachments"
   
    default:
     headerLabel.text = "TO-DO"
    }
//         return header
        return headerLabel
    }
    
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //AddEditCardPropertiesViewCell()
        if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: propertiesCell, for: indexPath) as! AddEditCardPropertiesViewCell
            cell.backgroundColor = .red
            cell.view.backgroundColor = .black
            return cell
        } else if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: attachmentsCell, for: indexPath) as! AttachmentsCardViewCell
            cell.selectionStyle = .none
            tableView.allowsSelection = false
//            tableView.separatorStyle = .none
            
            return cell
        }
        else  {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
            cell.backgroundColor = .blue
            return cell
        }
       
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 150
        
        } else {
            return 40
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 2 {
            return 150
        }
        return 100
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

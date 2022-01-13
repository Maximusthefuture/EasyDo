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
    
    //MARK: Init views
    fileprivate func initViews() {
        view.addSubview(cardName)
        view.addSubview(cardDescription)
        cardName.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 0, left: 16, bottom: 0, right: 0))
        cardDescription.anchor(top: cardName.bottomAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, padding: .init(top: 16, left: 16, bottom: 0, right: 16))
        
    }
    
    //MARK: Init tableView
    fileprivate func initTableView() {
        view.addSubview(tableView)
        tableView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor)
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
//        header.backgroundColor = .yellow
        cardName.anchor(top: header.topAnchor, leading: header.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 0, left: 16, bottom: 0, right: 0))
        cardDescription.anchor(top: cardName.bottomAnchor, leading: header.leadingAnchor, bottom: header.bottomAnchor, trailing: header.trailingAnchor, padding: .init(top: 16, left: 16, bottom: 20, right: 16))
        return header
    }()
    
    let seeAllButton: UIButton = {
        let b = UIButton()
//        b.backgroundColor = .brown
        b.setTitleColor(.black, for: .normal)
        b.setTitle("See all", for: .normal)
        b.addTarget(self, action: #selector(handleSeeAllAttachments), for: .touchUpInside)
        return b
    }()
    
    private var bottomSheetTransitionDelegate: UIViewControllerTransitioningDelegate?
    
    //MARK: TODO Bottom Sheet when we can add items? First image then can add 
    @objc private func handleSeeAllAttachments() {
        let vc = AttachmentsViewController(initialHeight: 300)
        bottomSheetTransitionDelegate = BottomSheetTransitioningDelegate(factory: self)
        vc.modalPresentationStyle = .custom
        vc.transitioningDelegate = bottomSheetTransitionDelegate
        present(vc, animated: true)
        print("SEE ALL")
    }
    
    lazy var attachmentsHeader: UIView = {
        let headerLabel = HeaderLabel()
        let properties = UIView()
        properties.addSubview(seeAllButton)
        properties.addSubview(headerLabel)
        headerLabel.anchor(top: properties.topAnchor, leading: properties.leadingAnchor, bottom: properties.bottomAnchor, trailing: nil, size: .init(width: 200, height: 0))
        headerLabel.text = "Attachments"
        seeAllButton.anchor(top: properties.topAnchor, leading: nil, bottom: properties.bottomAnchor, trailing: properties.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 16))
        return properties
        
    }()
   
    
    let propertiesArray = ["Pomodoro count", "Label", "Due Date"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        definesPresentationContext = true
        view.backgroundColor = .white
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(close))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneCreatingEditing))
//        initViews()
        
        initTableView()
        addButtonInit()
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cardName.text = taskDetail?.title
        cardDescription.text = taskDetail?.taskDescription
        addButton.isHidden = true
        guard let isAddMyDay = isAddMyDay else { return }
        if isAddMyDay {
           addButton.isHidden = false
        }
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
        addButton.backgroundColor = .red
        addButton.addTarget(self, action: #selector(addCardToDayTask), for: .touchUpInside)
    }
    
    
    var date: Date?
    
    @objc fileprivate func addCardToDayTask(sender: UIButton) {
        let vc = PickTimeViewController(initialHeight: 300)
        
        bottomSheetTransitionDelegate = BottomSheetTransitioningDelegate(factory: self)
        vc.modalPresentationStyle = .custom
        vc.transitioningDelegate = bottomSheetTransitionDelegate
        present(vc, animated: true)
       
        vc.changeDate = { [weak self] date in
            self?.date = date
        }
        
        vc.dataIsSaved = { [weak self] in
            if let coreDataStack = self?.coreDataStack {
                let dailyItem = DailyItems(context: coreDataStack.managedContext)
                dailyItem.task = self?.taskDetail
                guard let date = self?.date else {
                    return
                }
                dailyItem.inTime = date
                self?.taskDetail?.mainTag = "In Progress"
                coreDataStack.saveContext()
            } else {
                print("NULL NULL NULL")
            }
            self?.presentingViewController?.dismiss(animated: true)
        }
    }
    
    func initCoreDataDummyData() {
        if let coreDataStack = coreDataStack {
            let task = Task(context: coreDataStack.managedContext)
            task.tags = ["No tag", "Productivity", "Motivation"]
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
}

extension AddEditCardViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 0
        } else if section == 1 {
            return propertiesArray.count
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
        case 2: return attachmentsHeader
            
        default:
            headerLabel.text = "TO-DO"
        }
        return headerLabel
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("IndexPath: ", indexPath.row)
        if indexPath.row == 2 {
            
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: propertiesCell, for: indexPath) as! AddEditCardPropertiesViewCell
            let propepties = propertiesArray[indexPath.row]
            cell.label.text = propepties
            cell.selectionStyle = .none
            tableView.separatorStyle = .none
            cell.accessoryType = .disclosureIndicator
//            cell.delegate = self
            if indexPath.row == 2 {
                cell.datePicker.isHidden = false
            }
            return cell
        } else if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: attachmentsCell, for: indexPath) as! AttachmentsCardViewCell
            cell.selectionStyle = .none
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
            return 100
        
        } else {
            return 40
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 2 {
            return 150
        }
        return 80
    }
}


//MARK: BottomSheetPresentationControllerFactory
extension AddEditCardViewController: BottomSheetPresentationControllerFactory {
    func makeBottomSheetPresentationController(presentedViewController: UIViewController?, presentingViewController: UIViewController?) -> BottomSheetPresentationController {
        .init(presentedViewController: presentedViewController!, presenting: presentingViewController, dissmisalHandler: self)
    }
    
    
}

//MARK: BottomSheetModalDissmisalHandler
extension AddEditCardViewController: BottomSheetModalDissmisalHandler {
    func performDismissal(animated: Bool) {
        presentedViewController?.dismiss(animated: animated)
       
    }
}

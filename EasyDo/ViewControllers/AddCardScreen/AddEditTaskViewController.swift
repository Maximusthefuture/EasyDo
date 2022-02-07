//
//  AddDetailViewController.swift
//  EasyDo
//
//  Created by Maximus on 03.01.2022.
//

import UIKit

enum AddEditTaskState {
    case new
    case edit
}


class AddEditTaskViewController: UIViewController {

    var vmFactory = AddEditViewModelFactory()
    var enumProp: Properties?
    //Move to VM?
    var tableManager: AddEditTableManager = AddEditTableManager()
    
    
    init(viewModel: AddEditCardViewModelProtocol) {
        self.addEditCardViewModel = viewModel
        super.init(nibName: nil, bundle: nil)
     
    }
 
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let cardName: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Enter card title"
        tf.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        tf.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
        return tf
    }()
    
    let cardDescription: UITextView = {
        let tf = UITextView()
        tf.font = UIFont.systemFont(ofSize: 13)
        tf.textContainer.maximumNumberOfLines = 4
        tf.textContainer.lineBreakMode = .byTruncatingTail
        tf.text = "Some description here tap to change"
        tf.isEditable = true
        tf.layer.cornerRadius = 10
        tf.backgroundColor = .init(white: 0.5, alpha: 0.1)
        return tf
    }()
    
    var addEditCardViewModel: AddEditCardViewModelProtocol?
    var isAddMyDay: Bool?
    let cellId = "CellID"
    let propertiesCell = "PropertiesCell"
    let attachmentsCell = "attachmentsCell"
    var currentProject: Project?
    var dayVC: DayTasksViewController?
    //Need to move to VM?
//    var taskDetail: Task?
    var tableView = UITableView()
    
    //cannot use withount lazy, Is it because the initialization happened before, and doesnt work
    lazy var saveButton: UIBarButtonItem = {
        var button = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneCreatingEditing))
        return button
    }()
    
    var editButton: UIButton = {
       let button = UIButton()
        button.setTitle("Edit", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(doneCreatingEditing), for: .touchUpInside)
        return button
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //MARK: IF CurrentProject nil???
        view.addSubview(editButton)
        editButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: nil, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 16, left: 0, bottom: 0, right: 8))
        editButton.isHidden = true
        setupEndEditingGesture()
        setupAddEditViewModelObserver()
        cardDescription.delegate = self
        view.backgroundColor = .white
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(close))
        navigationItem.rightBarButtonItem = saveButton
//        cardName.delegate = self
        initCardNameAndDescription()
        initTableView()
        
        
//        tableManager.attachTable(tableView)
//        tableManager.displayProperties(properties: propertiesArray)
//        tableManager.displayAttachments(attachments: propertiesArray)
//        tableManager.displayTodo()
//        tableManager.didDueDateTapped = { f in
//            print(f)
//        }
//        tableManager.didPomodoroTapped = { pomodoro in
//            print(pomodoro)
//        }
        

       
    }
    
    //MARK: Init tableView
    fileprivate func initTableView() {
        
        view.addSubview(tableView)
        tableView.anchor(top: cardDescription.bottomAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(TodoViewCell.self, forCellReuseIdentifier: String.init(describing: TodoViewCell.self))
        tableView.register(AddEditCardPropertiesViewCell.self, forCellReuseIdentifier: propertiesCell)
//        tableView.register(AddEditCardPropertiesViewCell.self, forCellReuseIdentifier: String.init(describing: AddEditCardPropertiesViewCell.self))
        tableView.register(AttachmentsCardViewCell.self, forCellReuseIdentifier: attachmentsCell)
        tableView.register(DueDateCell.self, forCellReuseIdentifier: String.init(describing: DueDateCell.self))
        //        tableView.isScrollEnabled = false
        
    }
    
    @objc func handleTextChange(textField: UITextField) {
        addEditCardViewModel?.cardName = textField.text
    }
    
    var addButton: UIButton = {
        var b = UIButton()
        //MARK: CHANGE ICON +
        b.setTitle("+", for: .normal)
        b.setTitleColor(.blue, for: .normal)
        b.titleLabel?.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        b.addTarget(self, action: #selector(addCardToDayTask), for: .touchUpInside)
        return b
    }()
    
    func initCardNameAndDescription() {
        view.addSubview(cardName)
        view.addSubview(cardDescription)
        view.addSubview(addButton)
        cardName.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 20, left: 16, bottom: 0, right: 0))
        cardDescription.anchor(top: cardName.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 16, left: 16, bottom: 0, right: 16), size: .init(width: 0, height: 70))
        addButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: nil, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 16, left: 0, bottom: 0, right: 8))
    }
    
    let seeAllButton: UIButton = {
        let b = UIButton()
        b.setTitleColor(.black, for: .normal)
        b.setTitle("See all", for: .normal)
        b.addTarget(self, action: #selector(handleSeeAllAttachments), for: .touchUpInside)
        return b
    }()
    
    //MARK: TODO Bottom Sheet when we can add items? First image then can add
    @objc private func handleSeeAllAttachments() {
        let vc = AttachmentsViewController(initialHeight: 300)
        
        present(vc, animated: true)
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
    
    let propertiesArray = ["Pomodoro", "Label", "Due date"]
    
    func setupAddEditViewModelObserver() {
        saveButton.isEnabled = false
        addEditCardViewModel?.bindableIsFormValidObserver.bind({ [weak self] isFormValid in
            guard let isFormValid = isFormValid else {
                return
            }
            self?.saveButton.isEnabled = isFormValid
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cardName.text = addEditCardViewModel?.cardName
        cardDescription.text = addEditCardViewModel?.cardDescription
        addButton.isHidden = true
        guard let isAddMyDay = isAddMyDay else { return }
        if isAddMyDay {
            addButton.isHidden = false
        }
    }
   
    
    fileprivate func setupEndEditingGesture() {
        var tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleEndEditingGesture))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)  
    }
    
    @objc func handleEndEditingGesture(tapGesture: UITapGestureRecognizer) {
        self.view.endEditing(true)
    
    }
    
    @objc func close() {
        dismiss(animated: true)
    }
    
    let errorLabel: UIAlertController = {
        let alert = UIAlertController(title: "Error", message: "Message", preferredStyle: .alert)
        return alert
    }()
    
    @objc fileprivate func doneCreatingEditing(sender: UIBarButtonItem) {
        print("Done editing save")
         try? addEditCardViewModel?.updateCreateTask()
         dismiss(animated: true)
    }
    
    @objc fileprivate func addCardToDayTask(sender: UIButton) {
        let vc = PickTimeViewController(initialHeight: 300)
        vc.coreDataStack = addEditCardViewModel?.coreDataStack
        present(vc, animated: true)
        vc.dataSavedWithDate = { [weak self] time, date in
            self?.addEditCardViewModel?.taskDetail = self?.addEditCardViewModel?.taskDetail
            self?.addEditCardViewModel?.addCardToDayTask(time: time, date: date)
            self?.presentingViewController?.dismiss(animated: true)
            
        }
    }
    
    var myDate: Date?
    var tagsArray = [String]()
    
    @objc func datePickerChange(datePicker: UIDatePicker) {
        print("Datepicker: \(datePicker.date)")
        addEditCardViewModel?.dueDate = datePicker.date
    }
  
}

extension AddEditTaskViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return propertiesArray.count
        }
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerLabel = HeaderLabel()
        switch section {
        case 0: headerLabel.text = "Properties"
        case 1: return attachmentsHeader
        default:
            headerLabel.text = "TO-DO"
        }
        return headerLabel
    }
    
    fileprivate func presentToCardAddTagsVM() {
        //MARK: TODO add textField with color picker max 2 tags.
        let vc = CardAddTagsViewController(initialHeight: 200)
        vc.taskDetail = addEditCardViewModel?.taskDetail
        vc.refreshDelegate = self
        present(vc, animated: true)
    }
    
    fileprivate func presentToPomodoroCountVM() {
        let vc = PomodoroCountViewController(initialHeight: 50, viewModel: vmFactory.pomodoroViewModel)
        present(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("IndexPath: ", indexPath.row)
        if indexPath.row == 1 {
            presentToCardAddTagsVM()
        } else if indexPath.row == 0 {
            presentToPomodoroCountVM()
        }
    }
    
    enum Properties: Int {
        case pomodoro = 0
        case label
        case dueDate
    }
    
    //Если я захочу что-то добавить? Мне придется менять это?
    func configPropertiesCells(cell: AddEditCardPropertiesViewCell, properties: Properties, indexPathRow: Int) {
        let index = properties.rawValue == indexPathRow
        if index {
            switch properties.rawValue {
            case 0:
                cell.datePicker.isHidden = true
                cell.pomodoroCount.isHidden = false
                
            case 1:
                cell.stackView.isHidden = false
                
            case 2:
                cell.datePicker.isHidden = false
                
                
            default:
                print("default")
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if indexPath.row == 2 {
                let date = Date(timeIntervalSince1970: 0)
                let cell = tableView.dequeueReusableCell(withIdentifier: String.init(describing: DueDateCell.self), for: indexPath) as! DueDateCell
                cell.datePicker.addTarget(self, action: #selector(datePickerChange), for: .editingDidEnd)
                cell.initDueDateTask(task: addEditCardViewModel?.taskDetail, isHaveDueDate: addEditCardViewModel?.taskDetail?.dueDate == date)
                if isAddMyDay ?? false {
                    cell.deadLineCheckbox.isUserInteractionEnabled = false
                }
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: propertiesCell, for: indexPath) as! AddEditCardPropertiesViewCell
                let propepties = propertiesArray[indexPath.row]
                cell.label.text = propepties
                tableView.separatorStyle = .none
                cell.initTask(initialTask: addEditCardViewModel?.taskDetail)
                
                switch indexPath.row {
                case 0: enumProp = .pomodoro
                case 1: enumProp = .label
                case 2: enumProp = .dueDate
                default:
                    print("default =)")
                }
                if let enumProp = enumProp {
                    configPropertiesCells(cell: cell, properties: enumProp, indexPathRow: indexPath.row)
                }
                return cell
            }
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: attachmentsCell, for: indexPath) as! AttachmentsCardViewCell
            cell.selectionStyle = .none
            return cell
        }
        else  {
            let cell = tableView.dequeueReusableCell(withIdentifier: String.init(describing: TodoViewCell.self), for: indexPath) as! TodoViewCell
//            cell.backgroundColor = .blue
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

extension AddEditTaskViewController: RefreshTagsDelegate {
    func refreshTags(tag: String) {
        let indexPath = IndexPath(item: 1, section: 0)
        addEditCardViewModel?.tagsArray.append(tag)
        self.tableView.reloadRows(at: [indexPath], with: .none)
    }
}

extension AddEditTaskViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        self.addEditCardViewModel?.cardDescription = textView.text
//        self.addButton.isHidden = false
        self.addButton.isHidden = true
        self.editButton.isHidden = false
    }
    
//    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
////        tapGesture.cancelsTouchesInView = false
//        self.view.endEditing(true)
//        return true
//    }
}

//extension AddEditTaskViewController: UITextFieldDelegate {
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        self.view.endEditing(true)
//        return true
//    }
//}


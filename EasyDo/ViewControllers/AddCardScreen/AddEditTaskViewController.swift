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
    //MARK: ?????
    
    lazy var addEditViewModel = AddEditCardViewModel()
    
    private var viewModel: ViewModelBased?
    var enumProp: Properties?
    
    
    //MARK: ??????
    init(viewModel: ViewModelBased, task: Task) {
        self.viewModel = viewModel
        self.taskDetail = task
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
    //MARK: SET frame?
    let cardDescription: UITextView = {
        let tf = UITextView()
        tf.font = UIFont.systemFont(ofSize: 13)
        tf.textContainer.maximumNumberOfLines = 4
        tf.textContainer.lineBreakMode = .byTruncatingTail
        tf.text = "Some description here tap to change"
        tf.isEditable = true
        tf.layer.cornerRadius = 10
        tf.backgroundColor = .init(white: 0.5, alpha: 0.1)
        
        //        tf.layer.masksToBounds = true
        //        tf.layer.backgroundColor = UIColor.blue.cgColor
        
        return tf
    }()
    
    var addEditCardViewModel: AddEditCardViewModelProtocol?
    var isAddMyDay: Bool?
    //    var addButton = UIButton()
    let cellId = "CellID"
    let propertiesCell = "PropertiesCell"
    let attachmentsCell = "attachmentsCell"
    var currentProject: Project?
    var coreDataStack: CoreDataStack?
    var dayVC: DayTasksViewController?
    var taskDetail: Task?
    var tableView = UITableView()
    var saveButton: UIBarButtonItem  = {
       var button =  UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneCreatingEditing))
        return button
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //MARK: IF CurrentProject nil???
        if let coreDataStack = coreDataStack {
            addEditCardViewModel = AddEditCardViewModel(coreDataStack: coreDataStack, currentProject: currentProject)
        }
        setupAddEditViewModelObserver()
        cardDescription.delegate = self
        view.backgroundColor = .white
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(close))
        navigationItem.rightBarButtonItem = saveButton
        initCardNameAndDescription()
        initTableView()
        setupEndEditingGesture()
    }
    
    //MARK: Init tableView
    fileprivate func initTableView() {
        
        view.addSubview(tableView)
        tableView.anchor(top: cardDescription.bottomAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        tableView.register(AddEditCardPropertiesViewCell.self, forCellReuseIdentifier: propertiesCell)
        tableView.register(AttachmentsCardViewCell.self, forCellReuseIdentifier: attachmentsCell)
        tableView.register(DueDateCell.self, forCellReuseIdentifier: "Due date")
        
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
    
    func  initCardNameAndDescription() {
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
    
    let propertiesArray = ["Pomodoro", "Label", "Due Date"]
    
    func setupAddEditViewModelObserver() {
        addEditCardViewModel?.bindableIsFormValidObserver.bind({ isFormValid in
            guard let isFormValid = isFormValid else {
                return
            }
            self.saveButton.isEnabled = isFormValid
            
        })
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
    
    fileprivate func setupEndEditingGesture() {
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleEndEditingGesture)))
    }
    
    @objc func handleEndEditingGesture(tapGesture: UITapGestureRecognizer) {
        self.view.endEditing(true)
        tapGesture.cancelsTouchesInView = false
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
        do {
            
            //MARK: TODO
            addEditCardViewModel?.cardDescription = cardDescription.text
            try addEditCardViewModel?.createNewTask()
            dismiss(animated: true)
        } catch {
            errorLabel.message = error.localizedDescription
            self.present(errorLabel, animated: true)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                self.errorLabel.dismiss(animated: true)
            }
        }
    }
    
    @objc fileprivate func addCardToDayTask(sender: UIButton) {
        let vc = PickTimeViewController(initialHeight: 300)
        
        present(vc, animated: true)
        vc.dataSavedWithDate = { [weak self] time, date in
            self?.addEditCardViewModel?.taskDetail = self?.taskDetail
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
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("IndexPath: ", indexPath.row)
        if indexPath.row == 1 {
            //MARK: TODO add textField with color picker max 2 tags.
            let vc = CardAddTagsViewController(initialHeight: 200)
            vc.taskDetail = taskDetail
            vc.coreData = coreDataStack
            vc.refreshDelegate = self
            present(vc, animated: true)
        } else if indexPath.row == 0 {
//            let vc = PomodoroCountViewController(initialHeight: 200)
//            present(vc, animated: true)
          
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
                cell.stepper.isHidden = false
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
                let cell = tableView.dequeueReusableCell(withIdentifier: "Due date", for: indexPath) as! DueDateCell
                cell.timeLabel.text = "2020-19-12, 20:00"
                cell.datePicker.addTarget(self, action: #selector(datePickerChange), for: .editingDidEnd)
                cell.initDueDateTask(task: taskDetail)
                if isAddMyDay ?? false {
                    cell.deadLineCheckbox.isUserInteractionEnabled = false
                }
                let date = Date(timeIntervalSince1970: 0)
                if taskDetail?.dueDate == date {
                    cell.datePicker.isHidden = true
                    cell.deadLineCheckbox.toggle()
                    cell.deadLineCheckbox.isUserInteractionEnabled = false
                } else {
                    cell.datePicker.isHidden = false
                    cell.deadLineCheckbox.isChecked = false
                }
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: propertiesCell, for: indexPath) as! AddEditCardPropertiesViewCell
                let propepties = propertiesArray[indexPath.row]
                cell.label.text = propepties
                cell.selectionStyle = .none
                tableView.separatorStyle = .none
                cell.accessoryType = .disclosureIndicator
                cell.initTask(initialTask: taskDetail)
                //cell.delegate = self
                switch indexPath.row {
                case 0: enumProp = .pomodoro
                case 1: enumProp = .label
                    //            case 2: enumProp = .dueDate
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
        
    }
}


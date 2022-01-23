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
        tf.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
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

    
    //MARK: Init tableView
    fileprivate func initTableView() {
        
        view.addSubview(tableView)
        tableView.anchor(top: cardDescription.bottomAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        tableView.register(AddEditCardPropertiesViewCell.self, forCellReuseIdentifier: propertiesCell)
        tableView.register(AttachmentsCardViewCell.self, forCellReuseIdentifier: attachmentsCell)
        tableView.isScrollEnabled = false
        
    }
    
    @objc func handleTextChange(textField: UITextField) {
        addEditCardViewModel?.cardName = textField.text
    }
    
    var addButton: UIButton = {
       var b = UIButton()
        b.setTitle("++", for: .normal)
        b.setTitleColor(.blue, for: .normal)
        b.titleLabel?.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        b.addTarget(self, action: #selector(addCardToDayTask), for: .touchUpInside)
        return b
    }()
    
    func  initCardNameAndDescription() {
        var stackView = UIStackView(arrangedSubviews: [cardName, addButton])
        view.addSubview(cardName)
        view.addSubview(cardDescription)
        view.addSubview(addButton)
        cardName.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 20, left: 16, bottom: 0, right: 0))
        cardDescription.anchor(top: cardName.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 16, left: 16, bottom: 0, right: 16), size: .init(width: 0, height: 50))
        
        addButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: nil, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 16, left: 0, bottom: 0, right: 8))
    }
    
    let seeAllButton: UIButton = {
        let b = UIButton()
        b.setTitleColor(.black, for: .normal)
        b.setTitle("See all", for: .normal)
        b.addTarget(self, action: #selector(handleSeeAllAttachments), for: .touchUpInside)
        return b
    }()
    
    private var bottomSheetTransitionDelegate: UIViewControllerTransitioningDelegate?
    
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
   
    //MARK: Viewmodel?
    func validateCardName(cardName: String) throws {
        guard cardName.count < 18  else { throw Errors.CardNameValidationError.tooLong }
        guard cardName.count > 3  else { throw Errors.CardNameValidationError.tooShort }
    }
    
    let propertiesArray = ["Pomodoro count", "Label", "Due Date"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //MARK: IF CurrentProject nil???
        if let coreDataStack = coreDataStack {
            addEditCardViewModel = AddEditCardViewModel(coreDataStack: coreDataStack, currentProject: currentProject)
        }
       
        view.backgroundColor = .white
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(close))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneCreatingEditing))
        initCardNameAndDescription()
        initTableView()
        setupEndEditingGesture()
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
            try validateCardName(cardName: cardName.text ?? "")
            createNewTask()
            dismiss(animated: true)
        } catch {
            print("ERROR", error.localizedDescription)
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
    
    func createNewTask() {
        addEditCardViewModel?.createNewTask()
    }
    
    @objc func datePickerChange(datePicker: UIDatePicker) {
        addEditCardViewModel?.dueDate = datePicker.date
    }
}

extension AddEditCardViewController: UITableViewDelegate, UITableViewDataSource {
    
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
        }
        
    }
    enum Properties: Int {
        case pomodoro = 0
        case label
        case dueDate
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: propertiesCell, for: indexPath) as! AddEditCardPropertiesViewCell
            let propepties = propertiesArray[indexPath.row]
            cell.label.text = propepties
            cell.selectionStyle = .none
            tableView.separatorStyle = .none
            cell.accessoryType = .disclosureIndicator
            cell.initTask(initialTask: taskDetail)
            var enumProp = Properties.pomodoro
//            cell.delegate = self
//            switch enumProp {
                
//            case .pomodoro:
//                cell.datePicker.isHidden = true
//            case .label:
//                cell.stackView.isHidden = false
//            case .dueDate:
//                cell.datePicker.isHidden = false
//                cell.datePicker.addTarget(self, action: #selector(datePickerChange), for: .editingDidEnd)
//            }
            if indexPath.row == 0 {
                cell.datePicker.isHidden = true
            }
            if indexPath.row == 1 {
                cell.stackView.isHidden = false
            }
            if indexPath.row == 2 {
                cell.datePicker.isHidden = false
                cell.datePicker.addTarget(self, action: #selector(datePickerChange), for: .editingDidEnd)
}
////                var date = Date(timeIntervalSinceReferenceDate: TimeInterval(1000))
////                cell.initTask(initialTask: taskDetail)
////                cell.datePicker.date = date
//            }
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

extension AddEditCardViewController: RefreshTagsProtocol {
    func refreshTags(tag: String) {
        let indexPath = IndexPath(item: 1, section: 0)
        addEditCardViewModel?.tagsArray.append(tag)
        self.tableView.reloadRows(at: [indexPath], with: .none)
    }
}

//extension

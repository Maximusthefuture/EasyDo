//
//  CreateProjectVC.swift
//  EasyDo
//
//  Created by Maximus on 11.01.2022.
//

import Foundation
import UIKit


class CreateProjectVC: ResizableViewController {
    
    private var currentHeight: CGFloat
    var coreDataStack: CoreDataStack?
    
    let addProjectButton: UIButton = {
       let button = UIButton()
        button.layer.cornerRadius = 10
        button.setTitle("Add project", for: .normal)
        button.backgroundColor = .red
        button.addTarget(self, action: #selector(handleAddProject), for: .touchUpInside)
        return button
    }()
    
    let stackView: UIStackView = {
       let stv = UIStackView()
        stv.axis = .horizontal
        stv.spacing = 10
        stv.distribution = .fillEqually
        return stv
    }()
    
    let addTagsButton: UIButton = {
       let button = UIButton()
        button.setImage(UIImage(systemName: "add"), for: .normal)
        button.backgroundColor = .blue
        button.addTarget(self, action: #selector(handleAddTagsButton), for: .touchUpInside)
        
        return button
    }()
    
    override init(initialHeight: CGFloat) {
        currentHeight = initialHeight
        super.init(initialHeight: initialHeight)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let projectNameTextField: CustomTextField = {
       let tf = CustomTextField(padding: 24)
        tf.placeholder = "Enter project name"
        tf.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
       
        return tf
    }()
    
    let padding: CGFloat = 16
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.9682769179, green: 0.9684478641, blue: 1, alpha: 1)
        view.resignFirstResponder()
        setupEndEditingGesture()
        initViews()
        setupNotificationObserver()
    }
    
    fileprivate func initViews() {
//        var scrollView = UIScrollView(frame: .init(x: 0, y: 0, width: view.bounds.width, height: 100))
        view.addSubview(addProjectButton)
        view.addSubview(projectNameTextField)
       
        view.addSubview(addTagsButton)
        view.addSubview(stackView)
//        scrollView.addSubview(stackView)
        addProjectButton.anchor(top: nil, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor,padding: .init(top: 0, left: padding, bottom: 0, right: padding), size: .init(width: 0, height: 60))
       
        projectNameTextField.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: padding, left: padding, bottom: padding, right: padding))
        
        addTagsButton.anchor(top: projectNameTextField.bottomAnchor, leading: nil, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 16, left: 0, bottom: 0, right: 0))
        stackView.anchor(top: projectNameTextField.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: addTagsButton.trailingAnchor, padding: .init(top: 16, left: 0, bottom: 0, right: 30))
//        stackView.anchor(top: scrollView.topAnchor, leading: scrollView.leadingAnchor, bottom: scrollView.bottomAnchor, trailing: scrollView.trailingAnchor, padding: .init(top: 16, left: 0, bottom: 0, right: 30))
//        scrollView.backgroundColor = .red
        
        stackView.backgroundColor = .gray
        var tagView = TagUIView()
        var tagView2 = TagUIView()
        tagView.backgroundColor = .red
        tagView.label.text = "No tag"
        tagView2.backgroundColor = .yellow
        tagView2.label.text = "In progress"
        var tagView3 = TagUIView()
        tagView3.backgroundColor = .red
        tagView3.label.text = "Done"
        stackView.addArrangedSubview(tagView)
        stackView.addArrangedSubview(tagView2)
        stackView.addArrangedSubview(tagView3)

    }
    
    @objc func handleAddTagsButton() {
        var tagView = TagUIView()
        tagView.backgroundColor = UIColor().randomColor()
        stackView.addArrangedSubview(tagView)
    }
    
    fileprivate func setupNotificationObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyBoardHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func handleKeyboardShow(notification: Notification) {
        guard let value = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyBoardFrame = value.cgRectValue
        let bottomSpace = view.frame.height - addProjectButton.frame.origin.y - addProjectButton.frame.height
        let difference =  keyBoardFrame.height - bottomSpace
        self.view.transform = CGAffineTransform(translationX: 0, y: -difference - 8)
        print("OBSERVERL: \(keyBoardFrame)")
    }
    
    @objc func handleKeyBoardHide() {
        self.view.transform = .identity
    }
    
    fileprivate func setupEndEditingGesture() {
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleEndEditingGesture)))
    }
    
    @objc func handleEndEditingGesture(tapGesture: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    //How to reload tableview previous vc
    @objc func  handleAddProject(_ sender: UIButton) {
        guard let coreDataStack = coreDataStack else {
            return
        }
        if let projectName = projectNameTextField.text {
            let project = Project(context: coreDataStack.managedContext)
            project.title = projectNameTextField.text
            project.tags = ["No tag", "In Progress", "Done"]
            coreDataStack.saveContext()
            print("ADDED", projectName)
        } else {
            return
        }
        dismiss(animated: true)
    }
    
   @objc func handleTextChange(_ tf: UITextField) {
        
    }
}



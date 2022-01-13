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
        initViews()
    }
    
   
    
    fileprivate func initViews() {
//        var scrollView = UIScrollView(frame: .init(x: 0, y: 0, width: view.bounds.width, height: 100))
        view.addSubview(addProjectButton)
        view.addSubview(projectNameTextField)
       
        view.addSubview(addTagsButton)
        view.addSubview(stackView)
//        scrollView.addSubview(stackView)
        addProjectButton.anchor(top: nil, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor,padding: .init(top: 0, left: padding, bottom: 0, right: padding), size: .init(width: 0, height: 60))
        addProjectButton.setTitle("Add project", for: .normal)
        projectNameTextField.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: padding, left: padding, bottom: padding, right: padding))
        addProjectButton.backgroundColor = .red
        addProjectButton.addTarget(self, action: #selector(handleAddProject), for: .touchUpInside)
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



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
        view.addSubview(addProjectButton)
        view.addSubview(projectNameTextField)
        addProjectButton.anchor(top: nil, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor,padding: .init(top: 0, left: padding, bottom: 0, right: padding), size: .init(width: 0, height: 60))
        addProjectButton.setTitle("Add project", for: .normal)
        projectNameTextField.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: padding, left: padding, bottom: padding, right: padding))
        addProjectButton.backgroundColor = .red
        addProjectButton.addTarget(self, action: #selector(handleAddProject), for: .touchUpInside)
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



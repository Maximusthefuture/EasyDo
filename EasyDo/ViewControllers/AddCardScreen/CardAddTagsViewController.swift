//
//  CardAddTagsViewController.swift
//  EasyDo
//
//  Created by Maximus on 13.01.2022.
//

import Foundation
import UIKit

class CardAddTagsViewController: ResizableViewController {
    
    let tagsNameTextField: CustomTextField = {
       let tf = CustomTextField(padding: 24)
        tf.placeholder = "Enter tag name"
        tf.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
        return tf
    }()
    
    var refreshTags: ((String) -> ())?
    var taskDetail: Task?
    var coreData: CoreDataStack?
    
    let stackView: UIStackView = {
       let stv = UIStackView()
        stv.axis = .horizontal
        stv.spacing = 10
        stv.distribution = .fillEqually
        return stv
    }()
    
    let addTagsButton: UIButton = {
       let button = UIButton()
//        button.setImage(UIImage(systemName: "add"), for: .normal)
        button.setTitle("+", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 32)
        button.setTitleColor(.black, for: .normal)
//        button.backgroundColor = .blue
        button.addTarget(self, action: #selector(handleAddTagsButton), for: .touchUpInside)
        return button
    }()
    
    let padding: CGFloat = 16
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.9722431302, green: 0.972392261, blue: 1, alpha: 1)
        view.addSubview(tagsNameTextField)
        view.addSubview(addTagsButton)
        view.addSubview(stackView)
        initTask()
        tagsNameTextField.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: padding, left: padding, bottom: padding, right: padding))
        addTagsButton.anchor(top: tagsNameTextField.bottomAnchor, leading: nil, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 16, left: 0, bottom: 0, right: 0))
        stackView.anchor(top: tagsNameTextField.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: addTagsButton.trailingAnchor, padding: .init(top: 16, left: 30, bottom: 0, right: 30), size: .init(width: 0, height: 40))
        setupNotificationObserver()
        //MARK: TODO when want to rename tag show textField
        if isStackViewFull(stackView: stackView) {
            addTagsButton.isHidden = true
            tagsNameTextField.isHidden = true
            stackView.transform = CGAffineTransform(translationX: 0, y: -60)
        }
       
    }
    
    @objc func handleTextChange(_ tf: UITextField) {
        if tf.text!.count < 1 {
            print("EMPTY")
        }
     }
    
    func initTask() {
        guard let count = taskDetail?.tags else { return }
        for title in count {
            if stackView.subviews.count == (taskDetail?.tags?.count)! {
                break
            }
            let tagView =  TagUIView()
            
            tagView.label.text = title
            tagView.backgroundColor = UIColor().randomColor()
            
            tagView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapTag)))
            stackView.addArrangedSubview(tagView)
           
            
        }
    }
    
    fileprivate func setupNotificationObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyBoardHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func handleKeyboardShow(notification: Notification) {
        guard let value = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyBoardFrame = value.cgRectValue
        let bottomSpace = view.frame.height - stackView.frame.origin.y - stackView.frame.height
        let difference =  keyBoardFrame.height - bottomSpace
        self.view.transform = CGAffineTransform(translationX: 0, y: -difference - 8)
        print("OBSERVERL: \(keyBoardFrame)")
    }
    
    @objc func handleKeyBoardHide() {
        self.view.transform = .identity
    }
    
    func isStackViewFull(stackView: UIStackView) -> Bool{
        return stackView.subviews.count == 2 ?  true : false
    }
    
    @objc func handleTapTag(gesture: UITapGestureRecognizer) {
        print("CLICKED", gesture.description)
        stackView.removeArrangedSubview(gesture.view!)
        gesture.view?.removeFromSuperview()
        
        //How delete from coredata?
        //show textfield when stackvewisubviews count < 2
    }
    
    @objc func handleAddTagsButton(sender: UIButton) {
        var tagView = TagUIView()
        tagView.backgroundColor = UIColor().randomColor()
        tagView.label.text = tagsNameTextField.text
        
        if isStackViewFull(stackView: stackView) {
            sender.isHidden = true
        }
        
        if tagsNameTextField.text!.count < 1 {
            tagsNameTextField.placeholder = "ENTER TAG NAME"
            UIView.animate(withDuration: 0.5, delay: 0, options: .autoreverse) {
                self.tagsNameTextField.transform = CGAffineTransform(scaleX: 3, y: 2)
                self.tagsNameTextField.transform = .identity
            }
        } else {
            taskDetail?.tags?.append(tagsNameTextField.text ?? "")
            stackView.addArrangedSubview(tagView)
            refreshTags?(tagsNameTextField.text ?? "")
            coreData?.saveContext()
            tagsNameTextField.text = nil
           
           
            
        }
    }
}

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
    
    var refreshTags: (() -> ())?
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
            let tagView =  TagUIView(frame: CGRect(origin: CGPoint.zero, size: .init(width: 100, height: 20)))
            
            tagView.label.text = title
            tagView.backgroundColor = UIColor().randomColor()
            tagView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapTag)))
            stackView.addArrangedSubview(tagView)
           
            
        }
    }
    
    @objc func handleTapTag(tag: TagUIView) {
        print("clicked", tag.label.text)
        stackView.removeArrangedSubview(tag)
    }
    
    @objc func handleAddTagsButton(sender: UIButton) {
        var tagView = TagUIView()
        tagView.backgroundColor = UIColor().randomColor()
        tagView.label.text = tagsNameTextField.text
        
        if stackView.subviews.count == 2 {
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
            coreData?.saveContext()
            tagsNameTextField.text = nil
            stackView.addArrangedSubview(tagView)
            refreshTags?()
            
        }
    }
}

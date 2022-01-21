//
//  AppRowCollectionViewCell.swift
//  EasyDo
//
//  Created by Maximus on 27.12.2021.
//

import UIKit

class TasksCollectionViewCell: UICollectionViewCell {
    
    var iconView: UIImageView = {
        let image = UIImageView()
        let label = UIImage(systemName: "paperplane.fill")
        
        image.image = label
        image.heightAnchor.constraint(equalToConstant: 20).isActive = true
        image.widthAnchor.constraint(equalToConstant: 20).isActive = true
        return image
    }()
    
    let title: UILabel = {
        var label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textColor = .black
        
        return label
    }()
    
//    //One more collectionview?
//    var tagView: TagUIView = {
//        var view = TagUIView()
//        view.backgroundColor = #colorLiteral(red: 0.8789672256, green: 0.9762962461, blue: 0.9438448548, alpha: 1)
//        view.label.textColor = #colorLiteral(red: 0.3214970827, green: 0.8934875727, blue: 0.7464131117, alpha: 1)
//        return view
//    }()
    
 
    
    
    let roundedView: UIView = {
        var view = UIView()
        view.layer.cornerRadius = 16
        view.backgroundColor = .white
//        view.layer.shadowColor = UIColor.gray.cgColor
//        view.layer.shadowOpacity = 10
//        view.layer.shadowOffset = .zero
//        view.layer.shadowRadius = 10
//        view.layer.masksToBounds = true
        return view
    }()
    
    func config(label: String) {
        title.text = label
    }
   
    
     let tagF = TagUIView(frame: CGRect(origin: CGPoint.zero, size: .init(width: 50, height: 20)))
//        tagF.backgroundColor = .red
   
    
    var stackView: UIStackView = {
        let stackView =  UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        return stackView
    }()
    
    func addOneMoreTag(view: UIView) {
        
        stackView.addArrangedSubview(view)
    }
    
   
    
    func initStackView(task: Task) {
        
    }
    
    var task: Task?
    
    func initTask(initialTask: Task?) {
        task = initialTask
        guard let count = task?.tags else { return }
        for title in count {
            if stackView.subviews.count == (task?.tags?.count)! {
                break
            }
            let tagView =  TagUIView()
            tagView.label.text = title
            tagView.backgroundColor = UIColor().randomColor()
            stackView.addArrangedSubview(tagView)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.cornerRadius = 16
       
       
//        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
//        addGestureRecognizer(panGesture)
        contentView.addSubview(roundedView)
        contentView.addSubview(title)
//        contentView.addSubview(tagView)
        contentView.addSubview(iconView)
//        stackView.addArrangedSubview(tagView)
        contentView.addSubview(stackView)
        
       
        roundedView.translatesAutoresizingMaskIntoConstraints = false
        roundedView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        roundedView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20).isActive = true
        roundedView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        roundedView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        roundedView.clipsToBounds = true
        
        
//        tagF.backgroundColor = .yellow
//        tagF.label.text = "FFFF"
//        stackView.addArrangedSubview(tagF)
//        stackView.addArrangedSubview(tagView)
//        stackView.addArrangedSubview(tagF)
       
        stackView.anchor(top: nil, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 16, bottom: 40, right: 16))
        
//        stackView.addArrangedSubview(tagView)
       
//        roundedView.layer.masksToBounds = true
        iconView.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: title.leadingAnchor, padding: .init(top: 20, left: 16, bottom: 0, right: 0))
        title.anchor(top: topAnchor, leading: iconView.trailingAnchor, bottom: nil, trailing: nil, padding: .init(top: 16, left: 16, bottom: 0, right: 0))
        //collection view?
        //MARK: TODO????
        
        
        backgroundColor = #colorLiteral(red: 0.9682769179, green: 0.9684478641, blue: 1, alpha: 1)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        stackView = UIStackView()
        title.text = nil
    }
    
//    @objc func handlePan(_ gesture: UIPanGestureRecognizer) {
//        let translation = gesture.translation(in: nil)
//        let degree: CGFloat = translation.x / 20
//        let angle = degree * .pi / 180
//        let rotationTransformation = CGAffineTransform(rotationAngle: angle)
//        self.transform = rotationTransformation.translatedBy(x: translation.x, y: translation.y)
//        print("x", translation.x)
//        if translation.x > 120 {
////            delegateDelete?.delete(cell: self)
//        }
//
//    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
       
        
       
        
       
    }
    
}

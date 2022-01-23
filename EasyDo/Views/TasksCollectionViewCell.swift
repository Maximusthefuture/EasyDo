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
        return view
    }()
  
    var arrayOfTagView = [TagUIView]()
    
    var tagView: TagUIView = {
        let tag = TagUIView()
        return tag
    }()
    var tagView2: TagUIView = {
        let tag = TagUIView()
        return tag
    }()
    
    
    
//    var task: Task?
    
    func initTask(task: Task?) {
        guard let count = task?.tags else { return }
        if count.count == 0 {
            stackView?.removeFromSuperview()
            
        } else {
            let pairs = zip(task?.tags?.first ?? "", task!.tags!.dropFirst())
            print("PAIRS: \(pairs)")
            task?.tags?.compactMap { tags in
//                if stackView.subviews.count >= 2 {
//                    return
//                }
                
                    
                
                
                tagView.label.text = tags
                tagView.backgroundColor = UIColor().randomColor()
                tagView2.label.text = tags
                tagView2.backgroundColor = UIColor().randomColor()
//                stackView.addArrangedSubview(tagView)
                
            }
//            tagView.label.text = task?.tags.map { $0.first } ?? ""
//            tagView.backgroundColor = UIColor().randomColor()
            
        }
//        if count.count != 0 {
//            for title in count {
//                let tagView = TagUIView()
//                if stackView.subviews.count == (task?.tags?.count)! {
//                    break
//                }
//
//                    tagView.label.text = title
//                    tagView.backgroundColor = UIColor().randomColor()
//
//                    stackView.addArrangedSubview(tagView)
//
//
//            }
//        } else {
//            stackView.removeFromSuperview()
//        }
//        print("Init task TaskCollectionView task: \(task?.title) taskTags: \(task?.tags)")
    }
    
    var stackView: UIStackView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.cornerRadius = 16
       stackView = UIStackView(arrangedSubviews: [self.tagView, tagView2])
        contentView.addSubview(roundedView)
        contentView.addSubview(title)
        //        contentView.addSubview(tagView)
        contentView.addSubview(iconView)
        //        stackView.addArrangedSubview(tagView)
        roundedView.addSubview(stackView!)
        
        
        roundedView.translatesAutoresizingMaskIntoConstraints = false
        roundedView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        roundedView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20).isActive = true
        roundedView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        roundedView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        roundedView.clipsToBounds = true
        
        stackView?.axis = .horizontal
        stackView?.distribution = .fillEqually
        stackView?.spacing = 10
        stackView?.anchor(top: nil, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 16, bottom: 40, right: 16))
        
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
        title.text = nil
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
}

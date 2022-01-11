//
//  DataTableViewCell.swift
//  EasyDo
//
//  Created by Maximus on 08.12.2021.
//

import UIKit

protocol DeleteThatShit {
    func delete(cell: DataTableViewCell)
}

class DataTableViewCell: UITableViewCell {
    
    var delegateDelete: DeleteThatShit?
    
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
    
    let tagView: TagUIView = {
        var view = TagUIView()
        view.backgroundColor = #colorLiteral(red: 0.8789672256, green: 0.9762962461, blue: 0.9438448548, alpha: 1)
        view.label.textColor = #colorLiteral(red: 0.3214970827, green: 0.8934875727, blue: 0.7464131117, alpha: 1)
        return view
    }()
    
    let roundedView: UIView = {
        var view = UIView()
        view.layer.cornerRadius = 16
        view.backgroundColor = .white
        view.layer.shadowColor = UIColor.gray.cgColor
        view.layer.shadowOpacity = 10
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 10
        view.layer.masksToBounds = true
        return view
    }()
    
    func config(label: String) {
        title.text = label
    }
    
    //MARK: ADD ALL POMODOROS!
    
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        roundedView.translatesAutoresizingMaskIntoConstraints = false
        roundedView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        roundedView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20).isActive = true
        roundedView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        roundedView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        roundedView.clipsToBounds = true
        
 
        
    }
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
  
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        self.layer.cornerRadius = 16
//        addGestureRecognizer(panGesture)
//        contentView.addSubview(title)
        addSubview(roundedView)
        addSubview(title)
        
       
//        roundedView.layer.masksToBounds = true
        addSubview(tagView)
//        addSubview(iconView)
        
        title.anchor(top: topAnchor, leading: leadingAnchor , bottom: nil, trailing: nil)
//        iconView.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: title.leadingAnchor, padding: .init(top: 20, left: 16, bottom: 0, right: 0))
        
        //collection view?
//        tagView.label.text = "Tag here"
//        tagView.anchor(top: nil, leading: leadingAnchor, bottom: bottomAnchor, trailing: nil, padding: .init(top: 0, left: 16, bottom: 40, right: 0))

//        title.translatesAutoresizingMaskIntoConstraints = false
//        title.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
//        title.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
//        title.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
        
        backgroundColor = #colorLiteral(red: 0.9682769179, green: 0.9684478641, blue: 1, alpha: 1)
        
       
        
    }
    
    var completion: (() -> ())?
    
    @objc func handlePan(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: nil)
        let degree: CGFloat = translation.x / 20
        let angle = degree * .pi / 180
        let rotationTransformation = CGAffineTransform(rotationAngle: angle)
        self.transform = rotationTransformation.translatedBy(x: translation.x, y: translation.y)
        print("x", translation.x)
        if translation.x > 120 {
            delegateDelete?.delete(cell: self)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
 
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

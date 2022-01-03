//
//  ProjectsViewCell.swift
//  EasyDo
//
//  Created by Maximus on 27.12.2021.
//

import UIKit

class ProjectsViewCell: UICollectionViewCell {
    
    
    let tagView: TagUIView = {
        var view = TagUIView()
        view.backgroundColor = #colorLiteral(red: 0.8898780942, green: 0.8974478841, blue: 0.9981856942, alpha: 1)
        view.label.textColor = #colorLiteral(red: 0.5596068501, green: 0.5770205855, blue: 1, alpha: 1)
        return view
    }()
    
  
    
    let horizontalController = TagsHorizontalController()
   
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(horizontalController.view)
        addSubview(tagView)
    
        
        tagView.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 20, left: 18, bottom: 0, right: 0))
        horizontalController.view.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 60, left: 0, bottom: 80, right: 0))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

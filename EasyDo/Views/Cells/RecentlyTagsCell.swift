//
//  RecentlyTagsCell.swift
//  EasyDo
//
//  Created by Maximus on 28.01.2022.
//

import Foundation
import UIKit

class RecentlyTagsCell: UICollectionViewCell {
    
    let tagsUIView = TagUIView()
//
//    let label: UILabel = {
//       let label = UILabel()
//        return label
//    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(tagsUIView)
        tagsUIView.centerInSuperview()
        tagsUIView.backgroundColor = UIColor().randomColor()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
    }
}

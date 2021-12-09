//
//  DataTableViewCell.swift
//  EasyDo
//
//  Created by Maximus on 08.12.2021.
//

import UIKit

class DataTableViewCell: UITableViewCell {
    
    let title: UILabel = {
        var label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textColor = .blue
        
        return label
    }()
    
    let roundedView: UIView = {
        var view = UIView()
        return view
    }()
    
    func config(label: String) {
        title.text = label
    }
    
    override func layoutSubviews() {
       
        contentView.frame = contentView.frame.inset(by: .init(top: 10, left: 10, bottom: 10, right: 10))
        
    }
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(title)
        title.translatesAutoresizingMaskIntoConstraints = false
        title.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        title.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        title.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
        backgroundColor = .red
        
        
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

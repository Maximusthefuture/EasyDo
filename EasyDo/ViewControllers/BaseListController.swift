//
//  BaseViewController.swift
//  EasyDo
//
//  Created by Maximus on 27.12.2021.
//

import Foundation

import UIKit

class BaseListController: UICollectionViewController {
    
    init() {
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}

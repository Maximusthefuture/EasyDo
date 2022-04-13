//
//  HorizontalAttachmentsController.swift
//  EasyDo
//
//  Created by Maximus on 07.01.2022.
//

import Foundation
import UIKit


class HorizontalAttachmentsController: BaseListController, UICollectionViewDelegateFlowLayout {
    
    let cellId = "HorizontalViewCell"
    
    //viewModel here
    var viewModel: AttachmentsViewModel?
    var image: UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .brown
      
        collectionView.register(AttachmentsHorizontallViewCell.self, forCellWithReuseIdentifier: cellId)
        
        if let layout = collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
        }
        
        viewModel?.getAttachments { data in
            print("Data count", data?.first?.images?.count)
            self.image = UIImage(data: data?.first?.images?.first ?? Data())
            self.collectionView.reloadData()
        }
 
       
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.attachmetsImages?.count ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! AttachmentsHorizontallViewCell
        cell.imageView.image = image
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: 160, height: 100)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("ITEM")
    }
    
}

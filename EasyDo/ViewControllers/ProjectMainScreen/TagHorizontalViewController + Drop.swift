//
//  TagHorizontalViewController + Drop.swift
//  EasyDo
//
//  Created by Maximus on 25.01.2022.
//

import Foundation
import UIKit
import SwiftUI


extension TagsHorizontalController: UICollectionViewDropDelegate {
    
    func collectionView(_ collectionView: UICollectionView, canHandle session: UIDropSession) -> Bool {
        return session.canLoadObjects(ofClass: NSString.self)
    }
    
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
//        let isSelf = (session.localDragSession?.localContext as? UICollectionView) == collectionView
        if collectionView.hasActiveDrag {
            return UICollectionViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
        }
        return UICollectionViewDropProposal(operation: .copy, intent: .insertAtDestinationIndexPath)
        
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        let destinationIndexPath: IndexPath
        
        if let indexPath = coordinator.destinationIndexPath {
            destinationIndexPath = indexPath
        } else {
            let row = collectionView.numberOfItems(inSection: 0)
            destinationIndexPath = IndexPath(item: row - 1, section: 0)
        }
        if coordinator.proposal.operation == .move {
            self.reorderItems(coordinator: coordinator, destinationIndexPath: destinationIndexPath, collectionView: collectionView)
        }
        if coordinator.proposal.operation == .copy {
            self.copyItems(coordinator: coordinator, destinationIndexPath: destinationIndexPath, collectionView: collectionView)
        }
        
//        if let collection = coordinator.session.localDragSession?.localContext as? UICollectionView,
//           let tasks = (collection.dataSource as? TagsHorizontalController)?.tasksList,
//           let items = coordinator.session.localDragSession?.items {
//            //            print(tasks.description)
//            print(items.debugDescription)
//            var indexPaths = [IndexPath]()
//            var indexes = [Int]()
//
//            for item in items {
//                if let indexPath = item.localObject as? IndexPath {
//                    let index = indexPath.item
//                    indexes += [index]
//                    indexPaths += [indexPath]
//                }
//            }
//
//            collection.performBatchUpdates({
//                collection.deleteItems(at: indexPaths)
//                (collection.dataSource as? TagsHorizontalController)?.tasksList =
//                tasks.enumerated()
//                    .filter({  !indexes.contains($0.offset)
//
//                    }).map { $0.element}
//            })

//        }
        
    }
}

extension TagsHorizontalController {
    private func copyItems(coordinator: UICollectionViewDropCoordinator, destinationIndexPath: IndexPath, collectionView: UICollectionView) {
        
        collectionView.performBatchUpdates({
            var indexPaths = [IndexPath]()
            for (index, item) in coordinator.items.enumerated() {
                //MARK: Now I'm copying item and change tag, need to delete prev item ASAP and then copy or something
                let indexPath = IndexPath(row: destinationIndexPath.row + index, section: destinationIndexPath.section)
                if collectionView === collectionView {
                    //MARK: ERROR Thread 1: Fatal error: Negative Array index is out of range
                    if tasksList!.count <= 0 {
                        tasksList?.append(item.dragItem.localObject as! Task)
                    } else {
                        self.tasksList?.insert(item.dragItem.localObject as! Task, at: indexPath.item)
                    }
                    changeTag(indexPath: indexPath.item)
                    
                }
                indexPaths.append(indexPath)
            }
            
            collectionView.insertItems(at: indexPaths)
        })
        
    }
}

extension TagsHorizontalController {
    func reorderItems(coordinator: UICollectionViewDropCoordinator, destinationIndexPath: IndexPath, collectionView: UICollectionView) {
        //MARK: REORDER ITEMS AND SAVE???
        if let item = coordinator.items.first,
           let sourceIndexPath = item.sourceIndexPath {
            collectionView.performBatchUpdates ({
                //?????????????? ???? ???????? ????????????? ?????????? ?????????? ?????????????????
//                var tasks =  self.tasksList
                print("SOURCE", sourceIndexPath.item)
                tasksList?.remove(at: sourceIndexPath.item)
                tasksList?.insert(item.dragItem.localObject as! Task, at: destinationIndexPath.item)

                collectionView.deleteItems(at: [sourceIndexPath])
                collectionView.insertItems(at: [destinationIndexPath])
            }, completion: nil)
            
            coordinator.drop(item.dragItem, toItemAt: destinationIndexPath)

        }
    }
}



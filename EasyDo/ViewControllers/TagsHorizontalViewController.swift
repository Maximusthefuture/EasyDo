//
//  TagsHorizontalViewCell.swift
//  EasyDo
//
//  Created by Maximus on 27.12.2021.
//

import UIKit

class TagsHorizontalController: BaseListController, UICollectionViewDelegateFlowLayout {

    var tasksList: [Task]?
    //Project????
    weak var changeDelegate: ChangeTagDelegate?
    var project: Project?
    var coreDataStack: CoreDataStack?
    var controller = ProjectMainViewController()
//    var coreDataStack = CoreDataStack(modelName: "EasyDo")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(TasksCollectionViewCell.self, forCellWithReuseIdentifier: "apps")
        collectionView.backgroundColor = #colorLiteral(red: 0.9682769179, green: 0.9684478641, blue: 1, alpha: 1)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.dragDelegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "apps", for: indexPath) as! TasksCollectionViewCell
        let task = tasksList?[indexPath.row]
        cell.title.text = task?.title
        cell.tagView.label.text = task?.tags?[0]
        return cell
}
    
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        guard let task = project?.tasks?[indexPath.item] as? Task else { return }
        guard let taskss = tasksList?[indexPath.item] else { return }
//        coreDataStack?.managedContext.delete(taskss)
        //delegate? reload collection view in maincontroller???˘
//        tasksList?[indexPath.row].title = "In Progress Here"
//        tasksList?[indexPath.row].mainTag = "In Progress"
//        changeDelegate?.mainTagChanged()
//        coreDataStack?.saveContext()
//        collectionView.deleteItems(at: [indexPath])
//        collectionView.reloadItems(at: [indexPath])
        
        let vc = AddDetailViewController()
//        vc.currentProject = project
        vc.cardName.text = taskss.title
        present(vc, animated: true)
    }
    
    func dragItems(at indexPath: IndexPath) -> [UIDragItem] {
        if let cell = collectionView.cellForItem(at: indexPath) as? TasksCollectionViewCell {
            let dragItem = UIDragItem(itemProvider: NSItemProvider(object: cell.title.text as! NSString))
            dragItem.localObject = indexPath
            return [dragItem]
        } else {
            return []
        }
    }
    
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tasksList?.count ?? 0
    }
    
    let topBottomPadding: CGFloat = 12
    let lineSpacing: CGFloat = 10
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let height = (view.frame.height - 2 * topBottomPadding - 2 * lineSpacing) / 2
        return .init(width: view.frame.width - 16 , height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 20, left: 8, bottom: 10, right: 8)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return lineSpacing
    }
}

extension TagsHorizontalController: UICollectionViewDragDelegate {
    
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        session.localContext = collectionView
        return dragItems(at: indexPath)
    }

}

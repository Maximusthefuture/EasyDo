//
//  TagsHorizontalViewCell.swift
//  EasyDo
//
//  Created by Maximus on 27.12.2021.
//

import UIKit
protocol TagChangeDelegate: AnyObject {
    func changeTag(tag: String)
}

class TagsHorizontalController: BaseListController, UICollectionViewDelegateFlowLayout {

    var tasksList: [Task]?
    var currentProject: Project?
    var coreDataStack: CoreDataStack?
    var controller = ProjectMainViewController()
    var isAddMyDay: Bool?
    var currentTag: Int?
    var changeTagClosure: ((Int) -> Void)?
    weak var tagChangeDelegate: TagChangeDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(TasksCollectionViewCell.self, forCellWithReuseIdentifier: "apps")
        collectionView.backgroundColor = #colorLiteral(red: 0.9682769179, green: 0.9684478641, blue: 1, alpha: 1)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.dragDelegate = self
        collectionView.dropDelegate = self
        collectionView.dragInteractionEnabled = true
        tagChangeDelegate = self
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("IS PRESENTED: \(self.isBeingPresented)")
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("IS PRESENTED: \(self.isBeingPresented)")
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "apps", for: indexPath) as! TasksCollectionViewCell
        let task = tasksList?[indexPath.row]
        cell.title.text = task?.title
        if let task = task {
            cell.initTask(task: task)
        }
        return cell
}
    
    var didSelectHandler: ((Task) -> ())?
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let tasks = tasksList?[indexPath.item] else { return }
        didSelectHandler?(tasks)
    }
    
    func dragItems(at indexPath: IndexPath) -> [UIDragItem] {
        let item = tasksList?[indexPath.row]
        let dragItem = UIDragItem(itemProvider: NSItemProvider(object: item?.title as! NSString))
        dragItem.localObject = item
        return [dragItem]
    }
    
    func changeTag(indexPath: Int) {
        
//        completion(1)
        let task = self.currentProject?.tasks?[indexPath] as! Task
        let tag = self.currentProject?.tags?[1]
        task.mainTag = "In Progress"
        self.coreDataStack?.saveContext()
        changeTagClosure = { value in
            print(value)
        }
        
        
    }
   
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tasksList?.count ?? 0
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
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

extension TagsHorizontalController: TagChangeDelegate {
    func changeTag(tag: String) {
        print("myTag", tag)
    }
}


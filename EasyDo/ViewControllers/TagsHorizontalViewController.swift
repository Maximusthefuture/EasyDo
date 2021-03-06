//
//  TagsHorizontalViewCell.swift
//  EasyDo
//
//  Created by Maximus on 27.12.2021.
//

import UIKit


class TagsHorizontalController: BaseListController, UICollectionViewDelegateFlowLayout {
    
    var tasksList: [Task]?
    var coreDataStack: CoreDataStack?
//    var controller = ProjectMainViewController()
    var isAddMyDay: Bool?
    var currentTag: Int?
    var changeTagClosure: ((Int) -> Void)?
    var tagsArray: [String]?
   
//    init(coreDataStack: CoreDataStack) {
//        self.coreDataStack = coreDataStack
//        super.init()
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(TasksCollectionViewCell.self, forCellWithReuseIdentifier: "apps")
        collectionView.backgroundColor = #colorLiteral(red: 0.9682769179, green: 0.9684478641, blue: 1, alpha: 1)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.dragDelegate = self
        collectionView.dropDelegate = self
        collectionView.dragInteractionEnabled = true
     
        
        NotificationCenter.default.addObserver(self, selector: #selector(tagChangeNotificationReceived), name: Notification.Name("Tag"), object: nil)
       
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
        if indexPath == -1 {
            tasksList?[0].mainTag = tagsArray?[currentIndexTag!]
        } else {
            tasksList?[indexPath].mainTag = tagsArray?[currentIndexTag!]
        }
        
        self.coreDataStack?.saveContext()
        collectionView.reloadData()
    }
    
    var currentIndexTag: Int?
    
    @objc func tagChangeNotificationReceived(_ notification: NSNotification) {
        currentIndexTag = notification.object as? Int
        print(currentIndexTag)
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




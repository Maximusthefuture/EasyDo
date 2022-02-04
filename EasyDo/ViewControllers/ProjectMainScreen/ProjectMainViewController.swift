//
//  ProjectViewController.swift
//  EasyDo
//
//  Created by Maximus on 27.12.2021.
//

import UIKit
import CoreData

protocol ChangeTagDelegate: AnyObject {
    func mainTagChanged()
}

private let reuseIdentifier = "Cell"

class ProjectMainViewController: BaseListController, UICollectionViewDelegateFlowLayout {
    
    weak var changeDelegate: ChangeTagDelegate?
    var addButton = UIButton()
    var viewModel: ProjectViewModel?
    var currentProject: Project?
    var coreDataStack: CoreDataStack?
    var isAddMyDay: Bool?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(goBack))
//        collectionView.dragDelegate = self
//        collectionView.dropDelegate = self
//        collectionView.dragInteractionEnabled = true
        addButtonInit()
        collectionView.backgroundColor = #colorLiteral(red: 0.9682769179, green: 0.9684478641, blue: 1, alpha: 1)
        navigationItem.title = currentProject?.title
//        if let layout = collectionViewLayout as? UICollectionViewFlowLayout {
//            layout.scrollDirection = .horizontal
//        }
        collectionView.collectionViewLayout = createLayout()
        collectionView.isScrollEnabled = false
    }
    
    var changeTagClosure: ((Int) -> Void)?

    func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout {
            (sectionIndex: Int, layoutEnviroment: NSCollectionLayoutEnvironment) ->
            NSCollectionLayoutSection? in
            
            let item1 = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9), heightDimension: .fractionalHeight(0.8)))
            let group1 = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9), heightDimension: .absolute(self.collectionView.bounds.height)), subitems: [item1])
            let section = NSCollectionLayoutSection(group: group1)
            
            //Decorationviews?
            section.contentInsets = .init(top: 0, leading: 16, bottom: 0, trailing: 16)
            section.orthogonalScrollingBehavior = .groupPaging
            section.visibleItemsInvalidationHandler = {  (visibleItems, offset, env) in

                var index: Int?
                switch offset.x {
                case 0...300:
                    index = 0
                case 300...500:
                    index = 1
                default:
                    index = 2
                }
                
                //Using notificationCenter to observe Project tags change
                NotificationCenter.default.post(name: Notification.Name("Tag"), object: index)
                
            }
            return section
        }
        return layout
        
    }
 
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("VIEW WILL APPEAR")
        collectionView.reloadData()
        collectionView.register(ProjectsViewCell.self, forCellWithReuseIdentifier: "AppsViewCell")
    }

    @objc func goBack(sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    func deleteAll() {
        coreDataStack?.managedContext.delete(currentProject!)
        coreDataStack?.saveContext()
    }
   
    
    fileprivate func addButtonInit() {
        view.addSubview(addButton)
        addButton.anchor(top: nil, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor, padding: .init(top: 0, left: 16, bottom: 0, right: 16),size: CGSize(width: 0, height: 60))
        addButton.setTitle("+ Create card", for: .normal)
        addButton.layer.cornerRadius = 10
        addButton.backgroundColor = .blue
        addButton.addTarget(self, action: #selector(addNewCardButton), for: .touchUpInside)
    }
    
    func dragItems(at indexPath: IndexPath, collectionView: UICollectionView) -> [UIDragItem] {
        let cell = collectionView.cellForItem(at: indexPath) as! ProjectsViewCell
        let item = collectionView == collectionView ? currentProject?.tasks?[indexPath.row] : cell.horizontalController.tasksList?[indexPath.row]
//        let item = currentProject?.tasks?[indexPath.row] as! Task
        let dragItem = UIDragItem(itemProvider: NSItemProvider(object: item as! NSString))
        dragItem.localObject = item
        return [dragItem]
    }

    @objc private func addNewCardButton(button: UIButton) {
        var task = Task(context: coreDataStack!.managedContext)
        let vc = AddEditTaskViewController(viewModel: AddEditCardViewModel(), task: task, state: .new)
        let navController = UINavigationController(rootViewController: vc)
        vc.coreDataStack = coreDataStack
        vc.currentProject = currentProject
        navController.modalPresentationStyle = .fullScreen
        present(navController, animated: true)
        
    }
 
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return currentProject?.tags?.count ?? 0
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    var currentTag: Int?
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AppsViewCell", for: indexPath) as! ProjectsViewCell
        
        let filter = currentProject?.tasks?.filter{
            ($0 as! Task).mainTag == currentProject?.tags?[indexPath.row] }
        
        cell.tagView.label.text = currentProject?.tags?[indexPath.item]
        cell.horizontalController.currentProject = currentProject
        cell.horizontalController.isAddMyDay = self.isAddMyDay
        cell.horizontalController.tasksList = filter as? [Task]
        cell.horizontalController.changeTagClosure = changeTagClosure
        cell.horizontalController.coreDataStack = coreDataStack
        cell.horizontalController.tagsArray = currentProject?.tags
        cell.horizontalController.collectionView.reloadData()
        
        cell.horizontalController.didSelectHandler = { [weak self] task in
            let vc = AddEditTaskViewController(viewModel: AddEditCardViewModel(), task: task, state: .edit)
            vc.isAddMyDay = self?.isAddMyDay
            vc.taskDetail = task
            vc.coreDataStack = self?.coreDataStack
            self?.navigationController?.present(vc, animated: true)
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
       
        return .init(width: view.frame.width - 48, height: view.safeAreaLayoutGuide.layoutFrame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}



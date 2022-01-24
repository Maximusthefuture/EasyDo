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
       
        addButtonInit()
        collectionView.backgroundColor = #colorLiteral(red: 0.9682769179, green: 0.9684478641, blue: 1, alpha: 1)
        
        navigationItem.title = currentProject?.title
//        if let layout = collectionViewLayout as? UICollectionViewFlowLayout {
//            layout.scrollDirection = .horizontal
//        }
        
        collectionView.collectionViewLayout = createLayout()
    }
    
    
    func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout {
            (sectionIndex: Int, layoutEnviroment: NSCollectionLayoutEnvironment) ->
            NSCollectionLayoutSection? in
            
            let item1 = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9), heightDimension: .fractionalHeight(0.7)))
            let group1 = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9), heightDimension: .absolute(self.collectionView.bounds.height)), subitems: [item1])
            let section = NSCollectionLayoutSection(group: group1)
            section.orthogonalScrollingBehavior = .groupPaging
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        [self.parentViewController presentViewController:viewController animated:YES completion:nil];
      
       
    }

    
    @objc func goBack(sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
//    func initCoreDataDummyData() {
//        if let coreDataStack = coreDataStack {
//            let task = Task(context: coreDataStack.managedContext)
//            task.tags = ["No tag"]
//            task.mainTag = "Done"
//            task.title = "HEllo title"
//            task.taskDescription = "MY NEW TASK"
//            if let project = currentProject,
//               let tasks = project.tasks?.mutableCopy() as? NSMutableOrderedSet {
//                tasks.add(task)
//                project.tasks = tasks
//            }
//            coreDataStack.saveContext()
//            collectionView.reloadData()
//            changeDelegate = self
//        }
//
//
//    }

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
    
    
    
    @objc private func addNewCardButton(button: UIButton) {
        let vc = AddEditCardViewController(viewModel: AddEditCardViewModel())
        let navController = UINavigationController(rootViewController: vc)
        vc.coreDataStack = coreDataStack
        vc.currentProject = currentProject
        navController.modalPresentationStyle = .fullScreen
        present(navController, animated: true)
        
    }
 
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return currentProject?.tags?.count ?? 0
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AppsViewCell", for: indexPath) as! ProjectsViewCell
        let filter = currentProject?.tasks?.filter{ ($0 as! Task).mainTag == currentProject?.tags?[indexPath.row]}
        print("filter?.count: \(filter?.count)")
        
        cell.tagView.label.text = currentProject?.tags?[indexPath.item]
        cell.horizontalController.project = currentProject
        cell.horizontalController.isAddMyDay = self.isAddMyDay
        cell.horizontalController.tasksList = filter as? [Task]
        cell.horizontalController.coreDataStack = coreDataStack
        cell.horizontalController.collectionView.reloadData()
        cell.horizontalController.changeDelegate = changeDelegate
        cell.horizontalController.didSelectHandler = { [weak self] task in
            let vc = AddEditCardViewController(viewModel: AddEditCardViewModel())
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

extension ProjectMainViewController: ChangeTagDelegate {
    func mainTagChanged() {
        print("delegate here!!!")
//        collectionView.reloadData()
    }
    
    
}


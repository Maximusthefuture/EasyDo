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
        collectionView.register(ProjectsViewCell.self, forCellWithReuseIdentifier: "AppsViewCell")
        navigationItem.title = currentProject?.title
        if let layout = collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
        }
        
//       initCoreDataDummyData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("VIEW WILL APPEAR")
        collectionView.reloadData()
    }
    
    @objc func goBack(sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    func initCoreDataDummyData() {
        if let coreDataStack = coreDataStack {
            let task = Task(context: coreDataStack.managedContext)
            task.tags = ["No tag"]
            task.mainTag = "Done"
            task.title = "HEllo title"
            task.taskDescription = "MY NEW TASK"
            if let project = currentProject,
               let tasks = project.tasks?.mutableCopy() as? NSMutableOrderedSet {
                tasks.add(task)
                project.tasks = tasks
            }
            coreDataStack.saveContext()
            collectionView.reloadData()
            changeDelegate = self
        }
        
        
    }

    func deleteAll() {
        coreDataStack?.managedContext.delete(currentProject!)
        coreDataStack?.saveContext()
    }
   
    
    fileprivate func addButtonInit() {
        view.addSubview(addButton)
        addButton.anchor(top: nil, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor, padding: .init(top: 0, left: 16, bottom: 0, right: 16),size: CGSize(width: 0, height: 60))
        addButton.setTitle("+ Add Card", for: .normal)
        addButton.layer.cornerRadius = 10
        addButton.backgroundColor = .blue
        addButton.addTarget(self, action: #selector(addNewCardButton), for: .touchUpInside)
    }
    
    
    
    @objc private func addNewCardButton(button: UIButton) {
//        initCoreDataDummyData()
////        deleteAll()
//        collectionView.reloadData()
        
        let vc = AddEditCardViewController()
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
//        cell.backgroundColor = #colorLiteral(red: 0.9682769179, green: 0.9684478641, blue: 1, alpha: 1)
//        let projects = fetchedResultController.object(at: indexPath)
//        guard let tasks = currentProject?.tasks.map({ $0 }) as? Task else { return cell}
//        let filterTasksByTag = currentProject?.tasks?.filter { _ in
//            tasks.mainTag == currentProject?.tags?[indexPath.row]
//
//        }
        
        let filter = currentProject?.tasks?.filter{ ($0 as! Task).mainTag == currentProject?.tags?[indexPath.row]}
        print("filter?.count: \(filter?.count)")
        
        cell.tagView.label.text = currentProject?.tags?[indexPath.item]
        cell.horizontalController.project = currentProject
        cell.horizontalController.isAddMyDay = self.isAddMyDay
        cell.horizontalController.tasksList = filter as? [Task]
        cell.horizontalController.coreDataStack = coreDataStack
        cell.horizontalController.collectionView.reloadData()
        cell.horizontalController.changeDelegate = changeDelegate
      
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width - 48, height: view.safeAreaLayoutGuide.layoutFrame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    
//    fileprivate func someOfCoreData() {
//        let projectFetch: NSFetchRequest<Project> = Project.fetchRequest()
//        let task = Task(context: coreDataStack!.managedContext)
//        task.tags = ["No tag"]
//        task.mainTag = "No tag"
//        task.taskDescription = "ffffff"
//        do {
//            let results = try coreDataStack.managedContext.fetch(projectFetch)
//            if results.isEmpty {
//                currentProject = Project(context: coreDataStack.managedContext)
//                currentProject?.title = "Hello project data"
//                currentProject?.tags = ["No tag", "In Progress", "Done"]
//                currentProject?.tasks = [task]
//                if let project = currentProject,
//                   let tasks = project.tasks?.mutableCopy() as? NSMutableOrderedSet {
//                    tasks.add(task)
//                    project.tasks = tasks
//                }
//                coreDataStack.saveContext()
//            } else {
//                currentProject = results.first
//            }
//        } catch let error as NSError {
//
//        }
//    }
}

extension ProjectMainViewController: ChangeTagDelegate {
    func mainTagChanged() {
        print("delegate here!!!")
        collectionView.reloadData()
    }
    
    
}


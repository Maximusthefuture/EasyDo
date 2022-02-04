//
//  ProjectViewController.swift
//  EasyDo
//
//  Created by Maximus on 27.12.2021.
//

import UIKit
import CoreData

private let reuseIdentifier = "Cell"

class ProjectMainViewController: BaseListController, UICollectionViewDelegateFlowLayout {
    
    var addButton = UIButton()
    var viewModel: ProjectMainViewModelProtocol?
    var isAddMyDay: Bool?
    
    init(viewModel: ProjectMainViewModelProtocol) {
        self.viewModel = viewModel
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(goBack))
        addButtonInit()
        collectionView.backgroundColor = #colorLiteral(red: 0.9682769179, green: 0.9684478641, blue: 1, alpha: 1)
        navigationItem.title = viewModel?.currentProject?.title
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
    
//    func deleteAll() {
//        coreDataStack?.managedContext.delete(currentProject!)
//        coreDataStack?.saveContext()
//    }
   
    
    fileprivate func addButtonInit() {
        view.addSubview(addButton)
        addButton.anchor(top: nil, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor, padding: .init(top: 0, left: 16, bottom: 0, right: 16),size: CGSize(width: 0, height: 60))
        addButton.setTitle("+ Create card", for: .normal)
        addButton.layer.cornerRadius = 10
        addButton.backgroundColor = .blue
        addButton.addTarget(self, action: #selector(addNewCardButton), for: .touchUpInside)
    }
    
//    func dragItems(at indexPath: IndexPath, collectionView: UICollectionView) -> [UIDragItem] {
//        let cell = collectionView.cellForItem(at: indexPath) as! ProjectsViewCell
//        let item = collectionView == collectionView ? currentProject?.tasks?[indexPath.row] : cell.horizontalController.tasksList?[indexPath.row]
////        let item = currentProject?.tasks?[indexPath.row] as! Task
//        let dragItem = UIDragItem(itemProvider: NSItemProvider(object: item as! NSString))
//        dragItem.localObject = item
//        return [dragItem]
//    }
    
   
    @objc private func addNewCardButton(button: UIButton) {
        let container = DependencyContainer()
        let vc = container.addEditTaskViewController(task: nil, state: .new, currentProject: viewModel?.currentProject)
        let navController = UINavigationController(rootViewController: vc)
        navController.modalPresentationStyle = .fullScreen
        present(navController, animated: true)
        
    }
 
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.currentProject?.tags?.count ?? 0
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    var currentTag: Int?
    let container = DependencyContainer()
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AppsViewCell", for: indexPath) as! ProjectsViewCell
        
        let filter = viewModel?.currentProject?.tasks?.filter{
            ($0 as! Task).mainTag == viewModel?.currentProject?.tags?[indexPath.row] }
        
        cell.tagView.label.text = viewModel?.currentProject?.tags?[indexPath.item]
//        cell.horizontalController.currentProject = viewModel?.currentProject
        cell.horizontalController.isAddMyDay = self.isAddMyDay
        cell.horizontalController.tasksList = filter as? [Task]
        cell.horizontalController.changeTagClosure = changeTagClosure
        cell.horizontalController.coreDataStack = viewModel?.coreDataStack
        cell.horizontalController.tagsArray = viewModel?.currentProject?.tags
        cell.horizontalController.collectionView.reloadData()
        
        cell.horizontalController.didSelectHandler = { [weak self] task in
            let vc = self?.container.addEditTaskViewController(task: task, state: .edit, currentProject: task.project)
            vc?.isAddMyDay = self?.isAddMyDay
            if let vc = vc {
                self?.navigationController?.present(vc, animated: true)
            }
           
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



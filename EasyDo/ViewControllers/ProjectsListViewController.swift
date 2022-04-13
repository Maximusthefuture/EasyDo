//
//  ViewController.swift
//  EasyDo
//
//  Created by Maximus on 03.12.2021.
//

import UIKit
import MobileCoreServices
import CoreData

//MARK: DELETE
class ProjectsListViewController: UIViewController {
    //In viewmodel?
    var tableView: UITableView!
    var model = Model()
    var label = UILabel()
    var addButton = UIButton()
    var tagView = TagUIView()
    var isAddMyDay: Bool?
    var viewModel: ProjectListViewModelProtocol?
    var fetchRequest: NSFetchRequest<Project>?
    var projects: [Project] = []
//    var coreDataStack: CoreDataStack?
    
    init(viewModel: ProjectListViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.9682769179, green: 0.9684478641, blue: 1, alpha: 1)
        navigationItem.title = "Projects"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: nil)
        tableViewInit()
        labelInit()
        fetchRequest = Project.fetchRequest()
//        fetchAndReload()
        viewModel?.fetchAndReload()
//        tagViewInit()
        addButtonInit()
//        print("BOOLEAN IS: \(isAddMyDay)")
//        let task = Task(context: coreDataStack.managedContext)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("VIEW WILL APEAR")
        tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("VIEW DID APEAR")
        tableView.reloadData()
    }
    
    func fetchAndReload() {
        guard let fetchRequest = fetchRequest else {
          return
        }
        do {
            if let coreDataStack = viewModel?.coreDataStack {
                projects = try coreDataStack.managedContext.fetch(fetchRequest)
              tableView.reloadData()
            }
            
        } catch let err as NSError {
          print("err while fetching: ", err)
        }
    }
    
    fileprivate func labelInit() {
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        label.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        label.font = UIFont.systemFont(ofSize: 32, weight: .heavy)
    }
    
    
    fileprivate func tagViewInit() {
        tagView.translatesAutoresizingMaskIntoConstraints = false
        tagView.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 16).isActive = true
        tagView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        tagView.label.text = "IN-PROGRESS"
        tagView.backgroundColor = #colorLiteral(red: 0.8898780942, green: 0.8974478841, blue: 0.9981856942, alpha: 1)
        tagView.backgroundColor = .blue
    }
    
    
    
    fileprivate func addButtonInit() {
        addButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        addButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        addButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        addButton.setTitle("Create new project", for: .normal)
        addButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        addButton.layer.cornerRadius = 10
        addButton.backgroundColor = .blue
        addButton.addTarget(self, action: #selector(addProject), for: .touchUpInside)
        
    }
    private var bottomSheetTransitionDelegate: UIViewControllerTransitioningDelegate?
    
    @objc func addProject(sender: UIButton) {
        let vc = CreateProjectVC(initialHeight: 300)
        vc.coreDataStack = viewModel?.coreDataStack
        present(vc, animated: true)
    }
    
    func deleteAll() {
        guard let coreDataStack = viewModel?.coreDataStack else {
            return
        }
        let fetchRequest = Project.fetchRequest()
        let item = try? coreDataStack.managedContext.fetch(fetchRequest)
        guard let item = item else { return }
        for i in item {
            coreDataStack.managedContext.delete(i)
        }
//            let item = DailyItems(context: coreDataStack.managedContext)

            coreDataStack.saveContext()
    }
 
    
    fileprivate func tableViewInit() {
        //        navigationController?.navigationBar.isTranslucent = true
        tableView = UITableView()
        tableView.register(DataTableViewCell.self, forCellReuseIdentifier: "Cell")
        view.addSubview(tableView)
        view.addSubview(label)
        view.addSubview(addButton)
        view.addSubview(tagView)
        tableView.anchor(top: tagView.bottomAnchor, leading: view.leadingAnchor, bottom: addButton.topAnchor, trailing: view.trailingAnchor, padding: .init(top: 10, left: 0, bottom: 0, right: 0))
        tableView.backgroundColor = #colorLiteral(red: 0.9682769179, green: 0.9684478641, blue: 1, alpha: 1)
        tableView.dragDelegate = self
        tableView.dragInteractionEnabled = true
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsHorizontalScrollIndicator = false
        tableView.showsVerticalScrollIndicator = false
        tableView.allowsSelection = true
        tableView.separatorStyle = .none
        
    }
    
    @objc func tableViewPanGesture(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: nil)
        print("translation: \(translation.x) y : \(translation.y)")
        let degree: CGFloat = translation.x / 20
        let angle = degree * .pi / 180
        let rotationTransformation = CGAffineTransform(rotationAngle: angle)
        view.transform = rotationTransformation.translatedBy(x: translation.x, y: translation.y)
    }
    
    func dragItems(at indexPath: IndexPath) -> [UIDragItem] {
        if let cell = tableView.cellForRow(at: indexPath) as? DataTableViewCell {
            let dragItem = UIDragItem(itemProvider: NSItemProvider(object: cell.title.text as! NSString))
            dragItem.localObject = indexPath
            return [dragItem]
        } else {
            return []
        }
    }
}

extension ProjectsListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.projects.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! DataTableViewCell
        let project = viewModel?.projects[indexPath.row]
        cell.title.text = project?.title
                cell.config(label: project?.title ?? "zopa")
        cell.delegateDelete = self
        cell.selectionStyle = .none
//        var myIndexPath = IndexPath(item: indexPath.row, section: 0)
        cell.completion = {
//            tableView.deleteRows(at: [myIndexPath], with: .automatic)
            cell.removeFromSuperview()
        }
        
        return cell
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
       
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("DID SELECT")
        let container = DependencyContainer()
        let vc = container.makeProjectMainViewController(currentProject: viewModel?.projects[indexPath.row])
        vc.isAddMyDay = self.isAddMyDay
        
        let navBar = UINavigationController(rootViewController: vc)
        navBar.modalPresentationStyle = .fullScreen
        present(navBar, animated: true)
    }
}

extension ProjectsListViewController: DeleteThatShit {
    
    func delete(cell: DataTableViewCell) {
//        cell.removeFromSuperview()
        print("HERE WE COME")
//        tableView.deleteRows(at: <#T##[IndexPath]#>, with: <#T##UITableView.RowAnimation#>)
    }
}

extension ProjectsListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }
}







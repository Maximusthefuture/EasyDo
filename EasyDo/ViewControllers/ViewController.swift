//
//  ViewController.swift
//  EasyDo
//
//  Created by Maximus on 03.12.2021.
//

import UIKit
import MobileCoreServices

class ViewController: UIViewController {
    //In viewmodel?
    var tableView: UITableView!
    var model = Model()
    var label = UILabel()
    var button = UIButton()
    var addButton = UIButton()
    var tagView = TagUIView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.9682769179, green: 0.9684478641, blue: 1, alpha: 1)
        navigationItem.title = "Interview Q"
        navigationController?.navigationBar.prefersLargeTitles = true
        tableViewInit()
//        tableView.panGestureRecognizer.addTarget(self, action: #selector(tableViewPanGesture))
        button.setTitle("In Progress", for: .normal)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        label.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        label.font = UIFont.systemFont(ofSize: 32, weight: .heavy)
        tagView.translatesAutoresizingMaskIntoConstraints = false
        tagView.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 16).isActive = true
        tagView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        tagView.label.text = "IN-PROGRESS"
        tagView.backgroundColor = #colorLiteral(red: 0.8898780942, green: 0.8974478841, blue: 0.9981856942, alpha: 1)
//        tagView.backgroundColor = .blue
        button.setTitleColor(#colorLiteral(red: 0.5596068501, green: 0.5770205855, blue: 1, alpha: 1), for: .normal)
        button.layer.cornerRadius = 10
        addButtonInit()

    }
    
    
    fileprivate func addButtonInit() {
        addButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        addButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        addButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        addButton.setTitle("+ Add Card", for: .normal)
        addButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        addButton.layer.cornerRadius = 10
        addButton.backgroundColor = .blue
    }
 
    
    fileprivate func tableViewInit() {
        //        navigationController?.navigationBar.isTranslucent = true
        tableView = UITableView()
        tableView.register(DataTableViewCell.self, forCellReuseIdentifier: "Cell")
        view.addSubview(tableView)
        view.addSubview(label)
        view.addSubview(button)
        view.addSubview(addButton)
        view.addSubview(tagView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: tagView.bottomAnchor, constant: 24).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        tableView.bottomAnchor.constraint(equalTo: addButton.topAnchor, constant: -16).isActive = true
        tableView.backgroundColor = #colorLiteral(red: 0.9682769179, green: 0.9684478641, blue: 1, alpha: 1)
        tableView.dragDelegate = self
        //        tableView.dropDelegate = self
        tableView.dragInteractionEnabled = true
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsHorizontalScrollIndicator = false
        tableView.showsVerticalScrollIndicator = false
        tableView.allowsSelection = false
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


extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.placeNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! DataTableViewCell
        
//        cell.config(label: array[indexPath.row])
        cell.title.text = model.placeNames[indexPath.row]
        cell.delegateDelete = self
        var myIndexPath = IndexPath(item: indexPath.row, section: 0)
        cell.completion = {
//            tableView.deleteRows(at: [myIndexPath], with: .automatic)
            cell.removeFromSuperview()
        }
        
        return cell
    }
}

extension ViewController: DeleteThatShit {
    
    func delete(cell: DataTableViewCell) {
//        cell.removeFromSuperview()
        print("HERE WE COME")
//        tableView.deleteRows(at: <#T##[IndexPath]#>, with: <#T##UITableView.RowAnimation#>)
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
//    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
////        UIContextualAction
//        return nil
//    }
    
//    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
//        return true
//    }
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
}






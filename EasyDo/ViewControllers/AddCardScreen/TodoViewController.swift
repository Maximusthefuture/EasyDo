//
//  TodoViewController.swift
//  EasyDo
//
//  Created by Maximus on 03.02.2022.
//

import Foundation
import UIKit

class TodoViewController: UITableViewController {
    var currentTask: Task?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(TodoListCell.self, forCellReuseIdentifier: String.init(describing: TodoListCell.self))
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String.init(describing: TodoListCell.self), for: indexPath) as! TodoListCell
        cell.textLabel?.text = "TEXT HERE"
        return cell
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
        //currentTask.todoItems.count
    }
}

//
//  ViewController.swift
//  EasyDo
//
//  Created by Maximus on 03.12.2021.
//

import UIKit

class ViewController: UIViewController {
    //In viewmodel?
    var tableView: UITableView!
    
    
    var array =  ["Dasdasdas", "dasdasdasd", "fsdfsdfsdfdsf", "fsdfsdfdsfsdf", "eqweqweqweqw"]
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.9682769179, green: 0.9684478641, blue: 1, alpha: 1)
//        navigationItem.title = "All Projects"
        var label = UILabel()
        var button = UIButton()
        var addButton = UIButton()
        tableView = UITableView()
        tableView.register(DataTableViewCell.self, forCellReuseIdentifier: "Cell")
        view.addSubview(tableView)
        view.addSubview(label)
        view.addSubview(button)
        view.addSubview(addButton)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: button.bottomAnchor, constant: 24).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        tableView.bottomAnchor.constraint(equalTo: addButton.topAnchor, constant: -16).isActive = true
        tableView.backgroundColor = #colorLiteral(red: 0.9682769179, green: 0.9684478641, blue: 1, alpha: 1)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsHorizontalScrollIndicator = false
        tableView.showsVerticalScrollIndicator = false
        tableView.allowsSelection = false
        tableView.separatorStyle = .none
        
        button.setTitle("In Progress", for: .normal)
        label.text = "Interview Q"
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        label.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        label.font = UIFont.systemFont(ofSize: 32, weight: .heavy)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 16).isActive = true
        button.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        button.backgroundColor = #colorLiteral(red: 0.8898780942, green: 0.8974478841, blue: 0.9981856942, alpha: 1)
        
        
        
        button.setTitleColor(#colorLiteral(red: 0.5596068501, green: 0.5770205855, blue: 1, alpha: 1), for: .normal)
        button.layer.cornerRadius = 10
        addButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        addButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        addButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        addButton.setTitle("+ Add Card", for: .normal)
        addButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        addButton.layer.cornerRadius = 10
        addButton.backgroundColor = .blue

    }


}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! DataTableViewCell
        
//        cell.config(label: array[indexPath.row])
        cell.title.text = "TEST"
        return cell
    }
    
    
    
    
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
}




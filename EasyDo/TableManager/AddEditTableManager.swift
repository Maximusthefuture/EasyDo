//
//  AddEditTableManager.swift
//  EasyDo
//
//  Created by Maximus on 03.02.2022.
//

import Foundation
import UIKit

/*
 
 В случае нескольких секций мы можем использовать configuratorsDataSource: [[Configurator]], где чтобы получить доступ к первомой строке второй секции необходимо будет обратиться соответственно configuratorsDataSource[1][0].
 */

final class AddEditTableManager: NSObject, AddEditTableManagerProtocol {
    
    var didPomodoroTapped: ((String) -> Void)?
    var didTagTapped: ((String) -> Void)?
    var didDueDateTapped: ((String) -> Void)?
    private var table: UITableView?
    
    func attachTable(_ tableView: UITableView) {
        self.table = tableView
        table?.dataSource = self
        table?.delegate = self
    }
    
    private var configuratorDataSource: [CellConfigurator] = []
    
    private func createPropertiesConfigurator(_ model: Task) -> CellConfigurator {
        let configurator = AddEditPropertiesConfigurator()
        configurator.model = model
        return configurator
    }
    
    func displayProperties(properties: [Task]) {
        
        let output: [CellConfigurator] = properties.compactMap { createPropertiesConfigurator($0) }
        self.configuratorDataSource = output
        table?.reloadData()
    }
 
}

extension AddEditTableManager: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        configuratorDataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let configurator = configuratorDataSource[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: configurator.reuseId, for: indexPath)
        configurator.setupCell(cell)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentConfigurator = configuratorDataSource[indexPath.row]
        switch currentConfigurator.cellType {
            
        case .properties:
            self.didPomodoroTapped?("pomodoro")
        case .dueDate: break
            
        case .attachments: break
            
        case .todo: break
            
        }
    }
    
    
}

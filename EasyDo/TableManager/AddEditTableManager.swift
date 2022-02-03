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
    
    lazy var attachmentsHeader: UIView = {
        let headerLabel = HeaderLabel()
        let properties = UIView()
//        properties.addSubview(seeAllButton)
        properties.addSubview(headerLabel)
        headerLabel.anchor(top: properties.topAnchor, leading: properties.leadingAnchor, bottom: properties.bottomAnchor, trailing: nil, size: .init(width: 200, height: 0))
        headerLabel.text = "Attachments"
//        seeAllButton.anchor(top: properties.topAnchor, leading: nil, bottom: properties.bottomAnchor, trailing: properties.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 16))
        return properties
        
    }()
    
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
    //for sections
    private var configuratorSection: [[CellConfigurator]] = []
    
    private func createPropertiesConfigurator(_ model: String) -> CellConfigurator {
        let configurator = AddEditPropertiesConfigurator()
        configurator.model = model
        return configurator
    }
    
    func displayProperties(properties: [String]) {
        
        let output: [CellConfigurator] = properties.compactMap { createPropertiesConfigurator($0) }
        self.configuratorSection[0] = output
        table?.reloadData()
    }
 
}

extension AddEditTableManager: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return configuratorSection.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return configuratorSection[0].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let configurator = configuratorSection[0][indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: configurator.reuseId, for: indexPath)
        configurator.setupCell(cell)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentConfigurator = configuratorSection[0][indexPath.row]
        switch currentConfigurator.cellType {
            
        case .properties:
            self.didPomodoroTapped?("pomodoro")
        case .dueDate: break
            
        case .attachments: break
            
        case .todo: break
            
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 100
        } else {
            return 40
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 2 {
            return 150
        }
        return 80
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerLabel = HeaderLabel()
        switch section {
        case 0: headerLabel.text = "Properties"
        case 1: return attachmentsHeader
        default:
            headerLabel.text = "TO-DO"
        }
        return headerLabel
    }
    
   
    
    
}

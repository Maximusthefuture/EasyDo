//
//  AddEditTableManagerProtocol.swift
//  EasyDo
//
//  Created by Maximus on 03.02.2022.
//

import Foundation
import UIKit

protocol AddEditTableManagerProtocol: AnyObject {
    func attachTable(_ tableView: UITableView)
    
    
    var didPomodoroTapped: ((String) -> Void)? { get set }
    var didTagTapped: ((String) -> Void)? { get set }
    var didDueDateTapped: ((String) -> Void)? { get set }
}

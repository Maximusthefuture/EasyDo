//
//  ProjectViewModel.swift
//  EasyDo
//
//  Created by Maximus on 27.12.2021.
//

import Foundation


class ProjectViewModel {
    
    var projects: Project? {
        didSet {
            setModel(project: projects)
        }
    }
    
    var closure: ((Project?) -> ())?

    private func setModel(project: Project?) {
        closure?(project)
    }
    
}

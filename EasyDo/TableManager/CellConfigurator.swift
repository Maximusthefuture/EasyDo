//
//  CellConfigurator.swift
//  EasyDo
//
//  Created by Maximus on 03.02.2022.
//


import UIKit

protocol CellConfigurator {
    var reuseId: String { get }
    var cellType: AddEditCardCellType { get }
    func setupCell(_ cell: UIView)
}

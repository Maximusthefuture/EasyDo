//
//  PomodoroCountViewModel.swift
//  EasyDo
//
//  Created by Maximus on 01.02.2022.
//

import Foundation

protocol PomodoroCountViewModelProtocol {
    var pomodoroCount: Bindable<Int> { get}
    func setPomodoroCount()
}

struct PomodoroCountViewModel: PomodoroCountViewModelProtocol {
    var pomodoroCount = Bindable<Int>(0)
    
    
    
    func setPomodoroCount() {
        pomodoroCount.value! += 1
    }
}

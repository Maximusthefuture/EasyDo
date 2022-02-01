//
//  PomodoroCountViewModel.swift
//  EasyDo
//
//  Created by Maximus on 01.02.2022.
//

import Foundation

struct PomodoroCountViewModel {
    var pomodoroCount = Bindable<Int>(0)
    
    
    
    func setPomodoroCount() {
        pomodoroCount.value! += 1
    }
}

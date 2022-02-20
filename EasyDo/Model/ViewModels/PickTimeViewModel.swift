//
//  PickTimeViewModel.swift
//  EasyDo
//
//  Created by Maximus on 20.02.2022.
//

import Foundation


enum PickDate {
    case today
    case tommorow
    case datePicker
}

protocol PickTimeViewModelProtocol {
    
}


class PickTimeViewModel: PickTimeViewModelProtocol {
    
    var bindableDate = Bindable<Date>(Date())
    var bindableTime = Bindable<Date>(Date())
    
    
    
    func setPickerTime(date: Date, datePicker: PickDate) {
        bindableDate.value = date.tommorow
    }
    
}

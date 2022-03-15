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
    var bindableNotificationAccess = Bindable<Bool>(false)
    
    
    
    func setPickerTime(date: Date, datePicker: PickDate) -> Date {
        bindableDate.value = date.tommorow
        return date.tommorow
    }
    
}

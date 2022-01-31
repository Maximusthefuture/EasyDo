//
//  Bindable.swift
//  EasyDo
//
//  Created by Maximus on 31.01.2022.
//

import Foundation

class Bindable<T> {
    var value: T? {
        didSet {
          observer?(value)
        }
    }
    
    init(_ value: T) {
        self.value = value
    }
    
    var observer: ((T?) -> Void)?
    
    func bind(_ observer: @escaping (T?) -> Void) {
        self.observer = observer
    }
}

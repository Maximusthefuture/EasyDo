//
//  Errors.swift
//  EasyDo
//
//  Created by Maximus on 23.01.2022.
//

import Foundation


//class?

class Errors: Error {
    
    enum CardNameValidationError: Error {
        case tooShort
        case tooLong
        
    }
}



extension Errors.CardNameValidationError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .tooLong:
            return NSLocalizedString("Card name is too long", comment: "")

        case .tooShort:
            return NSLocalizedString("Card name is too short", comment: "")

        }
    }
}


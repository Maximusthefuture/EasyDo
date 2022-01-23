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


struct Validator<Value> {
    let closure: (Value) throws -> Void
    
   
}

struct ValidationError: LocalizedError {
    let message: String
    var errorDescription: String? { return message }
}

func validate<T>(_ value: T, using validator: Validator<T>) throws {
    try validator.closure(value)
}

func validate(
    _ condition: @autoclosure () -> Bool,
    errorMessage messageExpression: @autoclosure () -> String
) throws {
    guard condition() else {
        let message = messageExpression()
        throw ValidationError(message: message)
    }
}

extension Validator where Value == String {
    static var password: Validator {
        return Validator { string in
            try validate(string.count >= 7, errorMessage: "Password")
        }
    }
}



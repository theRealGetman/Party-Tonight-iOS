//
//  ValidationService.swift
//  PartyTonight
//
//  Created by Igor Kasyanenko on 29.11.16.
//  Copyright © 2016 Igor Kasyanenko. All rights reserved.
//

import Foundation
enum ValidationResult:Error {
    case ok(message: String)
    case empty
    case validating
    case failed(message: String)
}




class ValidationService {
    // validation
    
    static let minPasswordCount = 5
    
//    static func validateEmail(_ username: String) -> ValidationResult {
//        if username.characters.count == 0 {
//            return .empty
//        }
//        
//        
//        // this obviously won't be
//        if username.rangeOfCharacter(from: CharacterSet.alphanumerics.inverted) != nil {
//            return .failed(message: "Username can only contain numbers or digits")
//        }
//        
//        return .ok(message: "Email acceptable")
//    }
    
    static func validate(password: String) -> ValidationResult {
        let numberOfCharacters = password.characters.count
        if numberOfCharacters == 0 {
            return .empty
        }
        
        if numberOfCharacters < minPasswordCount {
            return .failed(message: "Password must be at least \(minPasswordCount) characters")
        }
        
        return .ok(message: "Password acceptable")
    }
    
    static func validateRepeatedPassword(_ password: String, repeatedPassword: String) -> ValidationResult {
        if repeatedPassword.characters.count == 0 {
            return .empty
        }
        
        if repeatedPassword == password {
            return .ok(message: "Password repeated")
        }
        else {
            return .failed(message: "Password different")
        }
    }
    
    static func validate(quantity:String?) -> Bool{
        guard let qStr = quantity,
            let q = Int(qStr) else {
                return false;
        }
        return q > 0;
        
    }
    
    static func validate(price:String?) -> Bool{
        guard let pStr = price,
            let p = Double(pStr) else {
                return false;
        }
        return p >= 0;
        
    }
    
    
   static func validate(email:String?) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
    
    
}

extension ValidationResult {
    var isValid: Bool {
        switch self {
        case .ok:
            return true
        default:
            return false
        }
    }
}

extension ValidationResult: CustomStringConvertible {
    
    var description: String {
        switch self {
        case .ok(let val):
            return  val;
        case .empty:
            return "empty";
        case .validating:
            return  "validating";
        case .failed(let val):
            return  val;
            //default: return "Undefined error";
            
        }
    }
}

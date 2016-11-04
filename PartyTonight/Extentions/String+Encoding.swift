//
//  String+Encoding.swift
//  PartyTonight
//
//  Created by Igor Kasyanenko on 04.11.16.
//  Copyright © 2016 Igor Kasyanenko. All rights reserved.
//

import Foundation
extension String {
    
    func fromBase64() -> String? {
        guard let data = Data(base64Encoded: self) else {
            return nil
        }
        
        return String(data: data, encoding: .utf8)
    }
    
    func toBase64() -> String {
        return Data(self.utf8).base64EncodedString()
    }
}

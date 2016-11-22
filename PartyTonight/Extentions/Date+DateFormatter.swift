//
//  Date+DateFormatter.swift
//  PartyTonight
//
//  Created by Igor Kasyanenko on 17.11.16.
//  Copyright © 2016 Igor Kasyanenko. All rights reserved.
//

import Foundation
extension Date {
    func string(format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}

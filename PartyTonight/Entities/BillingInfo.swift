//
//  BillingInfo.swift
//  PartyTonight
//
//  Created by Igor Kasyanenko on 11.11.16.
//  Copyright © 2016 Igor Kasyanenko. All rights reserved.
//

import Foundation
import ObjectMapper

class BillingInfo: Mappable {
    var cardNumber: String?
    
    
    required init?(map: Map){
        
    }
    
    init(cardNumber: String) {
        self.cardNumber = cardNumber;
    }
    
    func mapping(map: Map) {
        cardNumber <- map["card_number"]
    }
}

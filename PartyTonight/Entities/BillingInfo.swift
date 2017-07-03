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
    var billingEmail:String?
    
    required init?(map: Map){
        
    }
    
    init(cardNumber: String, billingEmail: String) {
        self.cardNumber = cardNumber;
        self.billingEmail = billingEmail;
    }
    
    func mapping(map: Map) {
        cardNumber <- map["card_number"]
        billingEmail <- map["billing_email"]
    }
}

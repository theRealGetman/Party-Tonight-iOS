//
//  Transaction.swift
//  PartyTonight
//
//  Created by Igor Kasyanenko on 08.05.17.
//  Copyright © 2017 Igor Kasyanenko. All rights reserved.
//

import Foundation
import ObjectMapper

class Transaction : Mappable {

    var id:Int?
    var payKey:String?
    var serviceTax:Double?
    var customerBillingEmail: String?
    var serviceBillingEmail:String?
    var order:[Booking] = []
    
    required init?(map: Map){
        
    }
    
    init(sharedCart:SharedCart){
        order = sharedCart.bookings;
    }
    
    init(id: Int?, payKey: String?,  customerBillingEmail: String?, serviceBillingEmail: String?, serviceTax:Double?) {
        self.id = id
        self.payKey = payKey
        self.customerBillingEmail = customerBillingEmail
        self.serviceBillingEmail = serviceBillingEmail
        self.serviceTax = serviceTax
        
    }
    
    func mapping(map: Map) {
        id                       <- map["id_transaction"]
        payKey                   <- map["pay_key"]
        customerBillingEmail     <- map["customer_billing_email"]
        serviceBillingEmail      <- map["service_billing_email"]
        order                    <- map["order"]
        serviceTax               <- map["service_tax"]

    }
    
    
    
}

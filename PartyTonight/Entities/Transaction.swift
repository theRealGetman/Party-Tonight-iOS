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
    //
    //    var id:Int?
    //    var eventId: Int?
    //    var payKey:String?
    //    var billingEmail:String?
    //    var subtotal: Double?
    //    var customerEmail: String?
    //
    
    //
    var id:Int?
    var payKey:String?
    var sellerBillingEmail:String?
    var customerBillingEmail: String?
    var subtotal: Double?
    var serviceBillingEmail:String?
    var serviceTax:Double?
    var order:[Booking] = []
    
    required init?(map: Map){
        
    }
    
    init(sharedCart:SharedCart){
        order = sharedCart.bookings;
    }
    
    init(id: Int?, payKey: String?, sellerBillingEmail: String?, customerBillingEmail: String?, subtotal: Double?, serviceBillingEmail: String?, serviceTax: Double?) {
        self.id = id
        self.payKey = payKey
        self.sellerBillingEmail = sellerBillingEmail
        self.customerBillingEmail = customerBillingEmail
        self.subtotal = subtotal
        self.serviceBillingEmail = serviceBillingEmail
        self.serviceTax = serviceTax
    }
    
    func mapping(map: Map) {
        id                       <- map["id_transaction"]
        sellerBillingEmail       <- map["seller_billing_email"]
        payKey                   <- map["pay_key"]
        customerBillingEmail     <- map["customer_billing_email"]
        subtotal                 <- map["subtotal"]
        serviceBillingEmail      <- map["service_billing_email"]
        serviceTax               <- map["service_tax"]
        order                    <- map["order"]
    }
    
    
    
}

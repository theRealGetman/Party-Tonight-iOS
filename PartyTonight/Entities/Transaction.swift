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
    var eventId: Int?
    var payKey:String?
    var billingEmail:String?
    var subtotal: Double?
    var customerEmail: String?
    
    
    required init?(map: Map){
        
    }
    
    init(id:Int?,eventId: Int?, payKey:String?, billingEmail:String?, subtotal: Double?, customerEmail: String?){

    }
    
    func mapping(map: Map) {
        id            <- map["id_transaction"]
        eventId       <- map["id_event"]
        payKey        <- map["pay_key"]
        billingEmail  <- map["billing_email"]
        subtotal      <- map["subtotal"]
        customerEmail <- map["customer_email"]
    }
    
    
    
}

//
//  Booking.swift
//  PartyTonight
//
//  Created by Igor Kasyanenko on 06.05.17.
//  Copyright © 2017 Igor Kasyanenko. All rights reserved.
//

import Foundation
import ObjectMapper

class Booking : Mappable {
    
    var subtotal: Double?
    var sellerBillingEmail:String?
    var idEvent: Int?
    var bottles: [BookedBottle]?
    var ticket: Ticket?
    var table: BookedTable?
    
    required init?(map: Map){
        
    }
    
    init(idEvent:Int?,  bottles:[BookedBottle], ticket: Ticket?, table:BookedTable?,  subtotal: Double? = 0, sellerBillingEmail:String? = ""){
        self.idEvent = idEvent;
        self.bottles = bottles;
        self.ticket = ticket;
        self.table = table;
        
        self.subtotal = subtotal
        self.sellerBillingEmail = sellerBillingEmail
        
    }
    
    func mapping(map: Map) {
        idEvent     <- map["id_event"]
        bottles     <- map["bottles"]
        ticket      <- map["ticket"]
        table       <- map["table"]
        sellerBillingEmail       <- map["sellerBillingEmail"]
        subtotal                 <- map["subtotal"]
       
    }
    
    
}

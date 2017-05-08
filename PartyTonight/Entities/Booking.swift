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
    
        var idEvent: Int?
        var bottles: [BookedBottle]?
        var ticket: Ticket?
        var table: BookedTable?
        
        required init?(map: Map){
            
        }
        
        init(idEvent:Int?,  bottles:[BookedBottle], ticket: Ticket?, table:BookedTable?){
            self.idEvent = idEvent;
            self.bottles = bottles;
            self.ticket = ticket;
            self.table = table;
        }
        
        func mapping(map: Map) {
            idEvent     <- map["id_event"]
            bottles     <- map["bottles"]
            ticket      <- map["table"]
            table       <- map["ticket"]
        }
    

}

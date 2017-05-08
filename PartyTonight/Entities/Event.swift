//
//  Event.swift
//  PartyTonight
//
//  Created by Igor Kasyanenko on 11.11.16.
//  Copyright © 2016 Igor Kasyanenko. All rights reserved.
//

import Foundation
import ObjectMapper

class Event : Mappable {

    var id: Int?
    var clubName,location,clubCapacity,partyName,zipCode: String?
    var date: Date?
    var photos:[Photo]?
    var bottles: [Bottle]?
    var tickets: [Ticket]?
    var tables: [Table]?
    
    required init?(map: Map){
        
    }
    
    init(clubName: String,dateTime:Date,location:String,zipCode:String?,clubCapacity:String,ticketsPrice:String,partyName:String, tables:[Table], bottles:[Bottle], photos: [Photo]){
        self.clubName = clubName;
        self.date = dateTime;
        self.location = location;
        self.zipCode = zipCode;
        self.clubCapacity = clubCapacity;
        self.tickets = [Ticket(price: ticketsPrice)]
        self.partyName = partyName;
        self.tables = tables;
        self.bottles = bottles;
        self.photos = photos;
        
    }
    
    func mapping(map: Map) {
        id           <- map["id_event"]
        clubName     <- map["club_name"]
        location     <- map["location"]
        clubCapacity <- map["club_capacity"]
        partyName    <- map["party_name"]
        zipCode      <- map["zip_code"]
        date         <- (map["date"], DateTransform())
        //date       <- map["date"]
        bottles      <- map["bottles"]
        tickets      <- map["tickets"]
        tables       <- map["tables"]
        photos       <- map["photos"]
        
    }
 
}


class Table:Mappable {
    var price,type,available,booked:String?
    var id:Int?
    init() {
        
    }
    
    required init?(map: Map){
        
    }
    init(price:String?,type:String?, available: String?, booked:String? = nil){
        self.price = price;
        self.type = type;
        self.available = available;
        self.booked = booked
    }
    
    func mapping(map: Map) {
        id        <- map["id_table"]
        price     <- map["price"]
        type      <- map["type"]
        available <- map["available"]
        booked    <- map["booked"]
    }

}

class Ticket:Mappable{
    var id:Int?
    var price:String?
    var type:String?
    var available: String? = "0"
    var booked: String? = "0"
    
    init(price: String) {
        self.price = price;
    }
    
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        id        <- map["id_ticket"]
        price     <- map["price"]
        available <- map["available"]
        booked    <- map["booked"]
    }
}

class Bottle:Mappable{
    var price,type,available, booked:String?
    var id:Int?
    
    init(price:String?,type:String?, available: String?, booked: String? = "0"){
        self.price = price;
        self.type = type;
        self.available = available;
        self.booked = booked
    }

    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        id <- map["id_bottle"]
        price     <- map["price"]
        type      <- map["type"]
        available <- map["available"]
        booked    <- map["booked"]
    }
}

class Revenue: Mappable{
    var revenue:String?
    init(revenue: String) {
        self.revenue = revenue;
    }
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        revenue <- map["revenue"]
    }
}

class Total: Mappable{
    var withdrawn,ticketsSales,bottleSales,tableSales,refunds: String?
    
    required init?(map: Map){
        
    }
    
    init() {
        
    }
    
    func mapping(map: Map) {
        withdrawn    <- map["withdrawn"]
        ticketsSales <- map["ticketsSales"]
        bottleSales  <- map["bottleSales"]
        tableSales   <- map["tableSales"]
        refunds      <- map["refunds"]
    }
}


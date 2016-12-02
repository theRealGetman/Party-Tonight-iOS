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
//    {
//    "club_name":"234f",
//    "date":"date and time here",
//    "location":"df",
//    "club_capacity":"2ewd",
//    "party_name":"partymaker tonight",(unique) or you will get 401(+ http staus forbidden)
//    "zip_code":"43253",
//    "bottles":
//    [{ "type":"водка", "prise":"prise", "available":"343"}]
//    ,
//    "tickets":[{
//    "price":"34543$"
//    }],
//    "tables":[{
//    "price":"34535$",
//    "available":"3232",
//    "type":"typetaable"
//    }]
//    }
//    /maker/event/create
//    + header x-auth-token
//    successful response 201(created)
    
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
    
    
    
    required init?(map: Map){
        
    }
    init(price:String?,type:String?, available: String?){
        self.price = price;
        self.type = type;
        self.available = available;
    }
    
    func mapping(map: Map) {
        price     <- map["price"]
        type      <- map["type"]
        available <- map["available"]
        booked    <- map["booked"]
    }

}

class Ticket:Mappable{
    var price:String?
    
    init(price: String) {
        self.price = price;
    }
    
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        price     <- map["price"]
    }
}

class Bottle:Mappable{
    var price,type,available, booked:String?
    
    
    init(price:String?,type:String?, available: String?){
        self.price = price;
        self.type = type;
        self.available = available;
    }

    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
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


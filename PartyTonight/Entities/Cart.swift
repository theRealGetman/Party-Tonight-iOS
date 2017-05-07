//
//  Cart.swift
//  PartyTonight
//
//  Created by Igor Kasyanenko on 05.05.17.
//  Copyright © 2017 Igor Kasyanenko. All rights reserved.
//

import Foundation
import ObjectMapper
enum CartError:Error {
    case BookedAvailable
    case NothingBooked
    case AboveLimit
}

class BookedBottle: Mappable {
    
    //    "id_event": 3,
    //    "bottles": [{
    //    "title": "Small",
    //    "amount": 4,
    //    "price": 10.0
    //    }, {
    //    "title": "Big",
    //    "amount": 5,
    //    "price": 25.0
    //    }],
    //    "table": null,
    //    "ticket": null
    
    
    required init?(map: Map){
    
    }
    
    func mapping(map: Map) {
        price    <- map["price"]
        type     <- map["title"]
        booked   <- map["amount"]
        id       <- map["id"]
        
    }
    
    var price = "0",type = "", booked = 0
    var id:Int = 0
    
    init(id:Int, price:String, type:String,booked:Int) {
        self.id = id
        self.price = price
        self.type = type
        self.booked = booked
    }
    
    convenience init?(bottle:Bottle) {
        if let id = bottle.id, let price = bottle.price, let type = bottle.type, let booked = Int(bottle.booked ?? "0") {
            self.init(id: id,price: price,type: type,booked: booked)
        }else {
            return nil
        }
    }
}

class BookedTable: Mappable{
    var price = "0",type = "", booked = 0
    var id:Int = 0
    
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        price    <- map["price"]
        type     <- map["type"]
        id       <- map["id"]
        
    }
    

    
    init(id:Int, price:String, type:String,booked:Int) {
        self.id = id
        self.price = price
        self.type = type
        self.booked = booked
    }
    
    convenience init?(table:Table) {
        if let id = table.id, let price = table.price, let type = table.type, let booked = Int(table.booked ?? "0") {
            self.init(id: id,price: price,type: type,booked: booked)
        }else {
            return nil
        }
    }
}

class SharedCart{
    private static var instance:SharedCart = SharedCart()
    static var shared:SharedCart {
        get {
            return instance
        }
        set(newVal){
            instance = newVal
        }
    }
    
    private var allCarts:[Int:Cart] = [Int:Cart]()
    
    func clear()  {
        allCarts.removeAll()
    }
    
    var carts:[Int:Cart] {
        get{
            return allCarts
        }
        
        set(newVal) {
            allCarts = newVal
        }
    }
    
    
    subscript(ind: Int?) -> Cart {
        
        get {
            let index = ind ?? 0
            if let cart = allCarts[index] {
                return cart
            }else{
                let cart = Cart()
                allCarts[index] = cart
                return cart
            }
            
            
            // return an appropriate subscript value here
        }
        set(newValue) {
            let index = ind ?? 0
            allCarts[index] = newValue
            allCarts[index]?.eventId = index
            // perform a suitable setting action here
        }
    }
    
    
    var asArray:[Cart] {
        get{
            return  Array(allCarts.values.map{ $0 })
        }
    }
    
    var bookings: [Booking] {
        get{
            return allCarts.map({ (key, value) -> Booking in
                return value.booking
            })
            
        }
        
        set(newVal){
            clear()
            for booking in newVal{
                if let idEvent = booking.idEvent {
                    self[idEvent].booking = booking
                }
            }
            
        }
    }


}

class Cart {
//    private static var instance:Cart = Cart()
//    static var shared:Cart {
//        get {
//            return instance
//        }
//        set(newVal){
//            instance = newVal
//        }
//    }
    
    
    var eventId:Int = 0
    var ticket:Ticket?
    private var bottles:[BookedBottle] = []
    private var tables:[BookedTable] = []
    private var limit = (table: 1, bottle: 0)
    
    
    
    
    var bookedBottles:[BookedBottle] {
        get {
            return bottles
        }
    }
    
    var bookedTables:[BookedTable]{
        get {
            return tables
        }
    }
    
    var total:Double {
        get {
            var sum = 0.0
            for item in bookedTables{
               sum += Double(item.booked) * (Double(item.price) ?? 0.0)
            }
            
            for item in bottles{
                 sum += Double(item.booked) * (Double(item.price) ?? 0.0)
            }
            return sum
        }
    }
    
    var booking: Booking {
        get{
           return Booking(idEvent: eventId, bottles: bookedBottles, ticket: ticket, table: bookedTables.first)
            
        }
        
        set(newVal){
            if let id = newVal.idEvent{
                eventId = id
            }
           
            bottles = newVal.bottles ?? []
            tables = newVal.table != nil ? [newVal.table!] : []
            ticket = newVal.ticket
            
        }
    }
    
    func clear(){
        ticket = nil
        bottles.removeAll()
        tables.removeAll()
    }
    
    func clearTables() {
        tables.removeAll()
        
    }
    
    
    
    func add(bottles:[Bottle]) throws {
        
        if(limit.bottle > 0 && bottles.count + self.bookedBottles.count > limit.bottle){
            throw CartError.AboveLimit
        }
        
        let bookedBottles = bottles.flatMap({ (b) -> BookedBottle? in
            
            return BookedBottle(bottle: b)
        }).flatMap { $0 }
        
        for bottle in bottles {
            if(Int(bottle.booked ?? "0")! <= 0){
                throw CartError.NothingBooked
            }
            
            print("bottle id \(bottle.id)")
            if let foundBottle = get(bottleById: bottle.id) {
                
                if(Int(bottle.booked ?? "0")! + foundBottle.booked > Int(bottle.available ?? "0")! ){
                    throw CartError.BookedAvailable
                }
                
                foundBottle.booked += Int(bottle.booked!)!
            } else{
                
                if(Int(bottle.booked ?? "0")! > Int(bottle.available ?? "0")!){
                    throw CartError.BookedAvailable
                }
                if let bookedBottle = BookedBottle(bottle: bottle){
                    self.bottles.append(bookedBottle)
                }
                
            }
        }
        
        
        //self.bottles.append(contentsOf: bookedBottles)
    }
    
    func add(tables:[Table]) throws {
        
        if(limit.table > 0 && tables.count + self.bookedTables.count > limit.table){
            throw CartError.AboveLimit
        }
        
        
        let bookedTables = tables.flatMap({ (b) -> BookedTable? in
            
            return BookedTable(table: b)
        }).flatMap { $0 }
        
        for table in tables {
            if(Int(table.booked ?? "0")! <= 0){
                throw CartError.NothingBooked
            }
            if let foundTable = get(tableById: table.id) {
                //print(" foundTable.booked \(foundTable.booked) table.available  \(table.available ) table.available \(table.available)")
                if(Int(table.booked ?? "0")! + foundTable.booked > Int(table.available ?? "0")! ){
                    throw CartError.BookedAvailable
                }
            } else{
                
                if(Int(table.booked ?? "0")! > Int(table.available ?? "0")!){
                    throw CartError.BookedAvailable
                }
            }
        }
        
        
        self.tables.append(contentsOf: bookedTables)
    }
    
    
    func get(bottleById id: Int?) -> BookedBottle? {
        for bottle in bottles {
            if(bottle.id == id){
               return bottle
            }
        }
        return nil
//        return bottles.first(where: { (bottle) -> Bool in
//            bottle.id == id
//        })
    }
    
    func get(tableById id: Int?) -> BookedTable? {
        return tables.first(where: { (table) -> Bool in
            table.id == id
        })
    }
    
}

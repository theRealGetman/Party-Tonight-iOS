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
    case WrongData
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
    var price = 0.0,type = "", booked = 0
    var id:Int = 0
    
    func mapping(map: Map) {
        price    <- map["price"]
        type     <- map["title"]
        booked   <- map["amount"]
        id       <- map["id_bottle"]
        
    }
    
   
    
    init(id:Int, price:Double, type:String,booked:Int) {
        self.id = id
        self.price = price
        self.type = type
        self.booked = booked
    }
    
    convenience init?(bottle:Bottle) {
        if let id = bottle.id, let price = bottle.price, let type = bottle.type, let booked = Int(bottle.booked ?? "0") {
            self.init(id: id,price: Double(price) ?? 0,type: type,booked: booked)
        }else {
            return nil
        }
    }
}

class BookedTable: Mappable{
    var price = 0.0,type = "", booked = 0
    var id:Int = 0
    
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        price    <- map["price"]
        type     <- map["type"]
        id       <- map["id_table"]
        booked = 1
        
    }
    
    
    
    init(id:Int, price:Double, type:String,booked:Int) {
        self.id = id
        self.price = price
        self.type = type
        self.booked = booked
    }
    
    convenience init?(table:Table) {
        if let id = table.id, let price = table.price, let type = table.type, let booked = Int(table.booked ?? "0") {
            self.init(id: id,price: Double(price) ?? 0,type: type,booked: booked)
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
    
    var total:Double {
        get {
            var sum:Double = 0
            for (_,cart) in carts{
                sum += cart.total
            }
            return sum
        }
    }
    
    
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
                cart.eventId = index
                return cart
            }else{
                let cart = Cart()
                cart.eventId = index
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
                //value.booking.idEvent = key
                let booking = value.booking
                return booking
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
    var bookedTicket:Ticket?
    private var bottles:[BookedBottle] = []
    private var tables:[BookedTable] = []
    private var limit = (table: 1, bottle: 0)
    
    var ticket:Ticket? {
        get{
            return bookedTicket
        }
        set(newVal){
            if let booked = newVal?.booked , let available = newVal?.available, let price = newVal?.price{
                if let booked = Int(booked), let available = Int(available){
                    if (available - booked > 0){
                        let newTicket = Ticket(id: newVal?.id, price: newVal?.price, type: newVal?.type, available: newVal?.available, booked: newVal?.booked)
                        self.bookedTicket = newTicket
                        bookedTicket?.booked = "1"
                        return
                    }else{
                        DefaultWireframe.presentAlert("No tickets available")
                    }
                }
            }
            
            self.bookedTicket = nil
        }
    }
    
    
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
                sum += (Double(item.booked) ?? 0.0) * (Double(item.price) ?? 0.0)
            }
            
            for item in bookedBottles{
                sum += (Double(item.booked) ?? 0.0) * (Double(item.price) ?? 0.0)
            }
            if let ticketPrice = ticket?.price{
                sum += Double(ticketPrice) ?? 0
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
            }else{
                print("eventId for booking not found")
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
            guard let booked = Int(bottle.booked ?? "0"), let _ = Int(bottle.available ?? "0") else{
                throw CartError.WrongData
            }
            if(booked <= 0){
                throw CartError.NothingBooked
            }
            
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
        for table in tables {
            if(table.id == id){
                return table
            }
        }
        return nil
        //        return tables.first(where: { (table) -> Bool in
        //            table.id == id
        //        })
    }
    
}

//
//  User.swift
//  PartyTonight
//
//  Created by Igor Kasyanenko on 31.10.16.
//  Copyright © 2016 Igor Kasyanenko. All rights reserved.
//

import Foundation
import ObjectMapper

class User : Mappable{

    var id: Int?
    var username: String?
    var phoneNumber: String?
    var email: String?
    var emergencyContact: String?
    var password: String?
    var enable: Bool?
    var updatedDate: Date?
    var createdDate: Date?
    var role: Int?
    var billingInfo: BillingInfo?
    
    
//    {
//        "idUser": 0,
//        "userName": "name",(unique)
//        "phoneNumber": "0345353",
//        "email": "g54mail.com",(unique)
//        "emergencyContact": "contact",
//        "password": "7",
//        "enable": false,
//        "updatedDate": null,
//        "createdDate": null,
//        "role": null,
//        "billing": {
//            
//            "card_number": "5634"(unique)
//            
//        }
//    }
    
    
    init(email: String, password: String){
        self.email = email;
        self.password = password;
    }
    
    init(username:String, phone:String, email:String, billingInfo:BillingInfo, emergencyContact:String, password:String){
        self.username = username;
        self.phoneNumber = phone;
        self.email = email;
        self.billingInfo = billingInfo;
        self.emergencyContact = emergencyContact;
        self.password = password;
    }
    
    required init?(map: Map) {
        
    }
    
    // Mappable
    func mapping(map: Map) {
        id                <- map["idUser"]
        username          <- map["userName"]
        phoneNumber       <- map["phoneNumber"]
        email             <- map["email"]
        emergencyContact  <- map["emergencyContact"]
        password          <- map["password"]
        enable            <- map["enable"]
        updatedDate       <- (map["updatedDate"], DateTransform())
        createdDate       <- (map["createdDate"], DateTransform())
        role              <- map["role"]
        billingInfo       <- map["billing"]
        
    }
}



class BillingInfo: Mappable {
    var cardNumber: String?
    
    
    required init?(map: Map){
        
    }
    
    init(cardNumber: String) {
        self.cardNumber = cardNumber;
    }
    
    func mapping(map: Map) {
        cardNumber <- map["card_number"]
    }
}

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
    var address:String?
    var birthday:String?
    var phoneNumber: String?
    var email: String?
    var emergencyContact: String?
    var password: String?
    var enable: Bool?
    var updatedDate: Date?
    var createdDate: Date?
    var role: Int?
    var billingInfo: BillingInfo?
    
    init(email: String, password: String){
        self.email = email;
        self.password = password;
    }
    
    init(username:String?,  address:String?, birthday: String?, phone:String?, email:String?, billingInfo:BillingInfo?, emergencyContact:String?, password:String?){
        self.username = username;
        self.address = address;
        self.birthday = birthday;
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
        birthday          <- map["birthday"]
        address           <- map["address"]
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



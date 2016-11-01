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
    var billingInfo: String?
    var emergencyContact: String?
    var password: String?
    var enable: Bool?
    var updatedDate: Date?
    var createdDate: Date?
    var idRole: Int?
    var idBilling: Int?
    
    required init?(map: Map) {
        
    }
    
    // Mappable
    func mapping(map: Map) {
        id                <- map["id_user"]
        username          <- map["user_name"]
        phoneNumber       <- map["phone_number"]
        email             <- map["email"]
        billingInfo       <- map["billing_info"]
        emergencyContact  <- map["emergency_contact"]
        password          <- map["password"]
        enable            <- map["enable"]
        updatedDate       <- (map["updated_date"], DateTransform())
        createdDate       <- (map["created_date"], DateTransform())
        idRole            <- map["id_role"]
        idBilling         <- map["id_billing"]
        
    }
    

    
}

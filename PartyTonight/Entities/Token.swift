//
//  Token.swift
//  PartyTonight
//
//  Created by Igor Kasyanenko on 03.11.16.
//  Copyright © 2016 Igor Kasyanenko. All rights reserved.
//

import Foundation
import ObjectMapper

class Token: Mappable {
    var token: String?
    
    required init?(map: Map){
       
        
        
    }
    
    func mapping(map: Map) {
        token <- map["token"]
    }
    
    init(){
        
    }
}

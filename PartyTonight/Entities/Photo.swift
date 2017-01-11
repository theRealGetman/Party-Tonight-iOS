//
//  Photo.swift
//  PartyTonight
//
//  Created by Igor Kasyanenko on 02.12.16.
//  Copyright © 2016 Igor Kasyanenko. All rights reserved.
//

import Foundation
import ObjectMapper
class Photo:Mappable{
    
    var url: String?
    var idPhoto: Int?
    
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        url <- map["photo"]
        idPhoto <- map["idPhoto"]
    }
    
    init(url:String){
        self.url = url;
    }
    
}

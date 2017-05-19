//
//  Token.swift
//  PartyTonight
//
//  Created by Igor Kasyanenko on 03.11.16.
//  Copyright © 2016 Igor Kasyanenko. All rights reserved.
//

import Foundation
import ObjectMapper

enum UserType:String{
    case Goer = "GOER"
    case Promoter = "PROMOTER"
}

class Token: Mappable {
    
    static let AUTH_TOKEN:String = "AUTH_TOKEN";
    static let USER_TYPE:String = "USER_TYPE";
    
    var token: String?
    
    private var userType:UserType?;
    
    var type:UserType?{
        get{
            return userType
        }
        set(newVal){
            userType = newVal
        }
    }
    
    required init?(map: Map){
        
    }
    
   
    init?(){
        let defaults = UserDefaults.standard;
        guard let authToken = defaults.string(forKey: Token.AUTH_TOKEN), let uType = defaults.string(forKey: Token.USER_TYPE) else {
            return nil;
        }
        self.token = authToken
        self.userType = UserType(rawValue: uType)
    }
    

    func mapping(map: Map) {
        token <- map["token"]
    }
    
    
    func invalidate() {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: Token.AUTH_TOKEN);
        defaults.removeObject(forKey: Token.USER_TYPE);
        defaults.synchronize();
    }
    
    func save() {
        let defaults = UserDefaults.standard
        defaults.set(token, forKey: Token.AUTH_TOKEN);
        defaults.set(userType?.rawValue, forKey: Token.USER_TYPE);
        defaults.synchronize();
    }

    
    
}

//
//  APIManager.swift
//  PartyTonight
//
//  Created by Igor Kasyanenko on 30.10.16.
//  Copyright © 2016 Igor Kasyanenko. All rights reserved.
//

import Foundation
import RxSwift
import ObjectMapper
import RxAlamofire
import SwiftyJSON

class APIManager{
    static let sharedAPI = APIManager()
    
    fileprivate struct Constants {
        static let baseURL = "http://api.partytonight.org/"
    }
    
    enum PromoterPath: String {
        case SignUp = "maker/signup"
        case SignIn = "maker/signin"
        
        var path: String {
            return Constants.baseURL + rawValue
        }
    }
    
    enum GoerPath: String {
        case SignUp = "dancer/signup"
        case SignIn = "dancer/signin"
        
        var path: String {
            return Constants.baseURL + rawValue
        }
    }
    
    enum APIError: Error {
        case CannotParse
    }
    
    
    func signin(_ login:String, password:String)-> Observable<User> {
        
        let params: [String: AnyObject] = [
            "email": login as AnyObject,
            "password": password as AnyObject,
            ]
        
        return request(.get, PromoterPath.SignIn.path, parameters: params)
            .map(JSON.init)
            .flatMap { json -> Observable<User> in
                guard let user =   Mapper<User>().map(JSONString: json.stringValue) else {
                    return Observable.error(APIError.CannotParse)
                }
                return Observable.just(user)
        }
    }
    
    
}

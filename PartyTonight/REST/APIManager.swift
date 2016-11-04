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
import Alamofire
class APIManager{
    static let sharedAPI = APIManager()
    
    fileprivate struct Constants {
        static let baseURL = "http://45.55.226.134:8080/partymaker/"
    }
    
    enum PromoterPath: String {
        case SignUp = "maker/signup"
        case SignIn = "signin"
        
        var path: String {
            return Constants.baseURL + rawValue
        }
    }
    
    enum GoerPath: String {
        case SignUp = "dancer/signup"
        case SignIn = "signin"
        
        var path: String {
            return Constants.baseURL + rawValue
        }
    }
    

    
    enum APIError: Error {
        case CannotParse
        case UnsuccessfulSignup
    }
    
    
//    func signin(_ login:String, password:String)-> Observable<User> {
//        
//        let params: [String: AnyObject] = [
//            "email": login as AnyObject,
//            "password": password as AnyObject,
//            ]
//        
//        return request(.get, PromoterPath.SignIn.path, parameters: params)
//            .map(JSON.init)
//            .flatMap { json -> Observable<User> in
//                guard let user =   Mapper<User>().map(JSONString: json.stringValue) else {
//                    return Observable.error(APIError.CannotParse)
//                }
//                return Observable.just(user)
//        }
//    }
    
    func signin(user: User)-> Observable<Token> {
        let credentials = user.email! + ":" + user.password!;
        let authorizationHeader = "Basic " + credentials.toBase64();
        let headers = [
            "Authorization": authorizationHeader
        ]
        
        return request(.get, PromoterPath.SignIn.path, headers: headers)
            .flatMap({ (response) -> Observable<Any> in
                 return response.validate(statusCode: 200..<300).rx.json()
            })
            .map(JSON.init)
            .flatMap { json -> Observable<Token> in
                guard let token = Mapper<Token>().map(JSONString: json.rawString() ?? "") else {
                    return Observable.error(APIError.CannotParse)
                }
                return Observable.just(token)
        }
    }
    
    
    func signup(promoter: User)-> Observable<Token> {
        return request(.post, PromoterPath.SignUp.path, parameters: Mapper<User>().toJSON(promoter) , encoding:  JSONEncoding.default)
            .map { response  in
                return response.validate(statusCode: 201..<202)
        }.flatMap { response -> Observable<Token> in
                return self.signin(user: promoter)

        }
    }
    
    func signup(goer: User)-> Observable<Token> {
        return request(.post, GoerPath.SignUp.path, parameters: Mapper<User>().toJSON(goer) , encoding:  JSONEncoding.default)
            .map { response  in
                return response.validate(statusCode: 201..<202)
            }.flatMap { response -> Observable<Token> in
                return self.signin(user: goer)
                
        }
    }
    
}

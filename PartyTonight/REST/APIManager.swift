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

enum Result<Value> {
    case Success(Value)
    case Failure(Error)
}
enum APIError: Error {
    case CannotParse(String)
    case UnsuccessfulSignup(String)
    case UnsuccessfulSignin(String)
    case BadStatusCode(String)
}


extension APIError: CustomStringConvertible {
    
    var description: String {
        switch self {
            
        case .UnsuccessfulSignup(let val):
            return  val;
        case .UnsuccessfulSignin(let val):
            return  val;
        case .BadStatusCode(let val):
            return  val;
        case .CannotParse(let val):
            return  val;
            //default: return "Undefined error";
            
        }
    }
}

class APIManager{
    static let sharedAPI = APIManager()
    
    var userToken: Token?
    
    fileprivate struct Constants {
        static let baseURL = "http://45.55.226.134:8080/partymaker/"
    }
    
    enum PromoterPath: String {
        case SignUp = "maker/signup"
        case SignIn = "signin"
        
        case CreateEvent = "maker/event/create"
        case GetEvents = "maker/event/get"
        case GetRevenue = "maker/event/revenue"
        case GetBottles = "maker/event/bottles"
        case GetTables = "maker/event/tables"
        case GetTotal = "maker/event/total"
        case Image = "maker/event/image"
        
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
    
    
    
    private let successfulStatusCodes = 200...201;
    
    
    func event(create event: Event) -> Observable<Result<Int>> {
        
        let headers = (userToken?.token != nil) ? ["x-auth-token": userToken!.token!] : [:]
        return request(.post, PromoterPath.CreateEvent.path, parameters: Mapper<Event>().toJSON(event),   encoding:  JSONEncoding.default,  headers: headers  )
            .map { response  in
                return response.validate(statusCode: self.successfulStatusCodes)
            }.flatMap { response -> Observable<Result<Int>> in
                return Observable.just(Result.Success(201))
            }.catchError({ (err) -> Observable<Result<Int>> in
                return Observable.just(Result.Failure(APIError.BadStatusCode(err.localizedDescription)));
                
            })
        //.catchErrorJustReturn(Result.Failure(APIError.BadStatusCode("")))
    }
    
    
    func event() -> Observable<Result<[Event]>> {
        let headers = (userToken?.token != nil) ? ["x-auth-token": userToken!.token!] : [:]
        return request(.get, PromoterPath.GetEvents.path,  headers: headers  )
            .flatMap({ (response) -> Observable<Any> in
                return response.validate(statusCode: self.successfulStatusCodes).rx.json()
            }).map(JSON.init)
            .flatMap { json -> Observable<Result<[Event]>> in
                guard let events = Mapper<Event>().mapArray(JSONString: json.rawString() ?? "" ) else {
                    return Observable.just(Result.Failure(APIError.CannotParse("")))
                }
                return Observable.just(Result.Success(events))
            }.catchError({ (err) -> Observable<Result<[Event]>> in
                return Observable.just(Result.Failure(APIError.BadStatusCode(err.localizedDescription)));
                
            })
        //.catchErrorJustReturn(Result.Failure(APIError.BadStatusCode("")))
    }
    
    
    func signin(user: User)-> Observable<Result<Token>> {
        let credentials = user.email! + ":" + user.password!;
        let authorizationHeader = "Basic " + credentials.toBase64();
        let headers = ["Authorization": authorizationHeader]
        return request(.get, PromoterPath.SignIn.path, headers: headers)
            .flatMap({ (response) -> Observable<Any> in
                return response.validate(statusCode: self.successfulStatusCodes).rx.json()
            })
            .map(JSON.init)
            .flatMap { json -> Observable<Result<Token>> in
                guard let token = Mapper<Token>().map(JSONString: json.rawString() ?? "") else {
                    return Observable.just(Result.Failure(APIError.CannotParse("")))
                }
                print("Got token: \(token.token)")
                return Observable.just(Result.Success(token))
            }.catchError({ (err) -> Observable<Result<Token>> in
                
                return Observable.just(Result.Failure(APIError.UnsuccessfulSignin(err.localizedDescription)));
                
            })
        
        
        
        //
        //.catchErrorJustReturn(Result.Failure(APIError.UnsuccessfulSignin))
    }
    
    func signup(promoter: User)-> Observable<Result<Token>> {
        return request(.post, PromoterPath.SignUp.path, parameters: Mapper<User>().toJSON(promoter) , encoding:  JSONEncoding.default)
            .map { response  in
                return response.validate(statusCode: self.successfulStatusCodes)
            }.flatMap { response -> Observable<Result<Token>> in
                return self.signin(user: promoter)
            }.catchError({ (err) -> Observable<Result<Token>> in
                return Observable.just(Result.Failure(APIError.UnsuccessfulSignup(err.localizedDescription)));
                
            })
        
        
        //.catchErrorJustReturn(Result.Failure(APIError.UnsuccessfulSignup("")))
    }
    
    func signup(goer: User)-> Observable<Result<Token>> {
        return request(.post, GoerPath.SignUp.path, parameters: Mapper<User>().toJSON(goer) , encoding:  JSONEncoding.default)
            .map { response  in
                return response.validate(statusCode: self.successfulStatusCodes)
            }.flatMap { response -> Observable<Result<Token>> in
                return self.signin(user: goer)
            }.catchError({ (err) -> Observable<Result<Token>> in
                return Observable.just(Result.Failure(APIError.UnsuccessfulSignup(err.localizedDescription)));
                
            })
        
        // .catchErrorJustReturn(Result.Failure(APIError.UnsuccessfulSignup("")))
        
    }
    
    
    
    func revenue(getFor partyName: String) ->  Observable<Result<Revenue>> {
        var headers = (userToken?.token != nil) ? ["x-auth-token": userToken!.token!] : [:]
        headers["partyName"] = partyName
        return request(.get, PromoterPath.GetRevenue.path,  headers: headers  )
            .flatMap({ (response) -> Observable<Any> in
                return response.validate(statusCode: self.successfulStatusCodes).rx.json()
            }).map(JSON.init)
            .flatMap { json -> Observable<Result<Revenue>> in
                
                guard let revenue = Mapper<Revenue>().map(JSONString: json.rawString() ?? "" ) else {
                    return Observable.just(Result.Failure(APIError.CannotParse("")))
                }
                return Observable.just(Result.Success(revenue))
            }.catchError({ (err) -> Observable<Result<Revenue>> in
                return Observable.just(Result.Failure(APIError.BadStatusCode(err.localizedDescription)));
                
            })
    }
    
    func bottles(getFor partyName: String) ->  Observable<Result<[Bottle]>> {
        var headers = (userToken?.token != nil) ? ["x-auth-token": userToken!.token!] : [:]
        headers["partyName"] = partyName
        return request(.get, PromoterPath.GetBottles.path,  headers: headers  )
            .flatMap({ (response) -> Observable<Any> in
                return response.validate(statusCode: self.successfulStatusCodes).rx.json()
            }).map(JSON.init)
            .flatMap { json -> Observable<Result<[Bottle]>> in
                guard let bottles = Mapper<Bottle>().mapArray(JSONString: json.rawString() ?? "" ) else {
                    return Observable.just(Result.Failure(APIError.CannotParse("")))
                }
                return Observable.just(Result.Success(bottles))
            }.catchError({ (err) -> Observable<Result<[Bottle]>> in
                return Observable.just(Result.Failure(APIError.BadStatusCode(err.localizedDescription)));
                
            })
    }
    
    
    func tables(getFor partyName: String) ->  Observable<Result<[Table]>> {
        var headers = (userToken?.token != nil) ? ["x-auth-token": userToken!.token!] : [:]
        headers["partyName"] = partyName
        return request(.get, PromoterPath.GetTables.path,  headers: headers  )
            .flatMap({ (response) -> Observable<Any> in
                return response.validate(statusCode: self.successfulStatusCodes).rx.json()
            }).map(JSON.init)
            .flatMap { json -> Observable<Result<[Table]>> in
                guard let tables = Mapper<Table>().mapArray(JSONString: json.rawString() ?? "" ) else {
                    return Observable.just(Result.Failure(APIError.CannotParse("")))
                }
                return Observable.just(Result.Success(tables))
            }.catchError({ (err) -> Observable<Result<[Table]>> in
                return Observable.just(Result.Failure(APIError.BadStatusCode(err.localizedDescription)));
                
            })
    }
    
    
    func total(getFor partyName: String) ->  Observable<Result<Total>> {
        var headers = (userToken?.token != nil) ? ["x-auth-token": userToken!.token!] : [:]
        headers["partyName"] = partyName
        return request(.get, PromoterPath.GetTotal.path,  headers: headers  )
            .flatMap({ (response) -> Observable<Any> in
                return response.validate(statusCode: self.successfulStatusCodes).rx.json()
            }).map(JSON.init)
            .flatMap { json -> Observable<Result<Total>> in
                
                guard let revenue = Mapper<Total>().map(JSONString: json.rawString() ?? "" ) else {
                    return Observable.just(Result.Failure(APIError.CannotParse("")))
                }
                return Observable.just(Result.Success(revenue))
            }.catchError({ (err) -> Observable<Result<Total>> in
                return Observable.just(Result.Failure(APIError.BadStatusCode(err.localizedDescription)));
                
            })
    }
    
    
    func uploadData(images:[UIImage]) -> Observable<[String]>{
        return Observable.combineLatest(images.map { (img)  in
            uploadImage(image: img)
        }, {el in el})
    }
    
    
    func uploadImage(image:UIImage) ->  Observable<String>{
        return Observable<String>.create({observer in
            let parameters:[String:String] = [:]
            let headers = (self.userToken?.token != nil) ? ["x-auth-token": self.userToken!.token!] : [:]
            
            
            Alamofire.upload(multipartFormData: { multipartFormData in
                if let imageData = UIImageJPEGRepresentation(image, 0.8) {
                    multipartFormData.append(imageData, withName: "file", fileName: "file.jpg", mimeType: "image/jpg")
                }
                
                for (key, value) in parameters {
                    multipartFormData.append((value.data(using: .utf8))!, withName: key)
                }}, to: PromoterPath.Image.path, method: .post, headers: headers,
                    encodingCompletion: { encodingResult in
                        switch encodingResult {
                        case .success(let upload, _, _):
                            
                            upload.responseJSON { [weak self] response in
                                
                                guard self != nil else {
                                    return
                                }
                                
                                guard response.result.error == nil else {
                                    print("error response")
                                    print(response.result.error!)
                                    return
                                }
                                if let value: Any = response.result.value {
                                    
                                    observer.onNext(JSON(value)["path"].stringValue)
                                    // completion(response: JSON(value))
                                }
                                
                            }
                        case .failure(let encodingError):
                            print("error:\(encodingError)")
                        }
            })
            
            
            return Disposables.create();
            
        })
        
    }
    
}

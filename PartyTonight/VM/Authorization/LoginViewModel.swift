//
//  LoginViewModel.swift
//  PartyTonight
//
//  Created by Igor Kasyanenko on 30.10.16.
//  Copyright © 2016 Igor Kasyanenko. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class LoginViewModel{
    fileprivate let disposeBag = DisposeBag()
    
    var username: Observable<String>
    var password: Observable<String>
    var signedUser: Observable<User>
    
    
    init(input: (
        username: Observable<String>,
        password: Observable<String>,
        loginTaps: Observable<Void>
        ),
         API: (
        APIManager

        )
        ) {

        self.username = input.username;
        self.password = input.username;
        
        
        let usernameAndPassword = Observable.combineLatest(input.username, input.password) { ($0, $1) }
      
        signedUser = input.loginTaps.withLatestFrom(usernameAndPassword)
            .flatMapLatest { (username, password) in
                
                
                return API.signin(username, password: password)
                    .observeOn(MainScheduler.instance)
                    //.catchErrorJustReturn(nil)
                    //.trackActivity(signingIn)
        }
            .shareReplay(1)
        
        
        /*
         
         //test
        signedUser.subscribe(onNext: { (user) in
            print("User signed: \(user)")
            }, onError: { (error) in
            print("Caught an error: \(error)")
        } )
        */
        
    }
}

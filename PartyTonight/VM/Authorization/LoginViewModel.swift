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
    
    var email: Observable<String>
    var password: Observable<String>
    var userToken: Observable<Token>
    
    
    init(input: (
        email: Observable<String>,
        password: Observable<String>,
        loginTaps: Observable<Void>
        ),
         API: (
        APIManager

        )
        ) {

        self.email = input.email;
        self.password = input.password;
        
        
        let usernameAndPassword = Observable.combineLatest(input.email, input.password) { ($0, $1) }
      
        userToken = input.loginTaps.withLatestFrom(usernameAndPassword)
            .flatMap ({ (email, password) -> Observable<Token> in
                
               // let user = User();
                
                               
                return API.signin(user: User(email: email, password: password))
                    .observeOn(MainScheduler.instance)
                    //.catchErrorJustReturn(nil)
                    //.trackActivity(signingIn)
        })
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

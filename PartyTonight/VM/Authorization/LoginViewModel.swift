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
    
    var userToken: Observable<Result<Token>>
    
    
    init(input: (
        email: Observable<String>,
        password: Observable<String>,
        loginTaps: Observable<Void>
        ), API: (APIManager)) {
        
        let usernameAndPassword = Observable.combineLatest(input.email, input.password) { ($0, $1) }
        userToken = input.loginTaps.withLatestFrom(usernameAndPassword)
            .flatMap ({ (email, password) -> Observable<Result<Token>> in
                
                if(!ValidationService.validate(email: email)){
                    return Observable.just(Result.Failure(ValidationResult.failed(message: "Incorrect email")));
                }
                return API.signin(user: User(email: email, password: password))
                    .observeOn(MainScheduler.instance)
            }).shareReplay(1)
        
    }
}

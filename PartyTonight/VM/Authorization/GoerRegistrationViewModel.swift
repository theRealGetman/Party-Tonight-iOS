//
//  GoerRegistrationViewModel.swift
//  PartyTonight
//
//  Created by Igor Kasyanenko on 02.12.16.
//  Copyright © 2016 Igor Kasyanenko. All rights reserved.
//

import Foundation
import RxSwift

class GoerRegistrationViewModel {
    var userToken: Observable<Result<Token>>
    
    init(input: (
        username: Observable<String>,
        address: Observable<String>,
        birthday: Observable<String>,
        email: Observable<String>,
        password: Observable<String>,
        signupTaps: Observable<Void>
        
        ), API: (APIManager)) {
        
        let signupCredentials = Observable.combineLatest(input.username, input.address, input.birthday, input.email,  input.password) { ($0, $1, $2, $3, $4) }
        
        userToken = input.signupTaps.withLatestFrom(signupCredentials)
            .flatMapLatest ({ (username, address, birthday, email, password) -> Observable<Result<Token>> in
                
                let validatedPassword = ValidationService.validate(password: password);
                if(!validatedPassword.isValid){
                    return Observable.just(Result.Failure(validatedPassword))
                }
                if(!ValidationService.validate(email: email)){
                    return Observable.just(Result.Failure(ValidationResult.failed(message: "Incorrect email")));
                }
                
                return API.signup(goer: User(username: username, address: address, birthday: birthday, phone: nil, email: email, billingInfo: nil, emergencyContact: nil, password: password))
                    .observeOn(MainScheduler.instance)
            }).shareReplay(1)
    }

}

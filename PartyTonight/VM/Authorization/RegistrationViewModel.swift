//
//  RegistrationViewModel.swift
//  PartyTonight
//
//  Created by Igor Kasyanenko on 04.11.16.
//  Copyright © 2016 Igor Kasyanenko. All rights reserved.
//

import Foundation

import UIKit
import RxSwift

class RegistrationViewModel{
    var userToken: Observable<Result<Token>>
    
    init(input: (
        username: Observable<String>,
        birthday: Observable<String>,
        phone: Observable<String>,
        email: Observable<String>,
        billingInfo: Observable<String>,
        emergencyContact: Observable<String>,
        password: Observable<String>,
        signupTaps: Observable<Void>
        
        ), API: (APIManager)) {
        
        let signupCredentials = Observable.combineLatest(input.username, input.birthday, input.phone, input.email, input.billingInfo, input.emergencyContact, input.password) { ($0, $1, $2, $3, $4, $5, $6) }
        
        userToken = input.signupTaps.withLatestFrom(signupCredentials)
            .flatMapLatest ({ (username, birthday, phone, email, billingInfo, emergencyContact, password) -> Observable<Result<Token>> in
                
                let validatedPassword = ValidationService.validate(password: password);
                if(!validatedPassword.isValid){
                    return Observable.just(Result.Failure(validatedPassword))
                }
                if(!ValidationService.validate(email: email)){
                    return Observable.just(Result.Failure(ValidationResult.failed(message: "Incorrect email")));
                }
                
                return API.signup(promoter: User(username: username, address: nil, birthday: birthday, phone: phone, email: email, billingInfo: BillingInfo(cardNumber: billingInfo), emergencyContact: emergencyContact, password: password))
                    .observeOn(MainScheduler.instance)
            }).shareReplay(1)
    }
}

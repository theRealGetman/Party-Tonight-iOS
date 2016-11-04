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
    fileprivate let disposeBag = DisposeBag()

    var userToken: Observable<Token>
    
    
    init(input: (
        username: Observable<String>,
        phone: Observable<String>,
        email: Observable<String>,
        billingInfo: Observable<String>,
        emergencyContact: Observable<String>,
        password: Observable<String>,
        signupTaps: Observable<Void>

        ),
         API: (
        APIManager
        
        )
        ) {
        
        let signupCredentials = Observable.combineLatest(input.username, input.phone, input.email, input.billingInfo, input.emergencyContact, input.password) { ($0, $1, $2, $3, $4, $5) }
        
        userToken = input.signupTaps.withLatestFrom(signupCredentials)
            .flatMapLatest { (username, phone, email, billingInfo, emergencyContact, password) in
                return API.signup(promoter: User(username: username, phone: phone, email: email, billingInfo: BillingInfo(cardNumber: billingInfo), emergencyContact: emergencyContact, password: password))
                    .observeOn(MainScheduler.instance)
            }
            .shareReplay(1)

    }
}

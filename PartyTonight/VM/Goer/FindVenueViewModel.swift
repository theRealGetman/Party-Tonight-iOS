//
//  FindVenueViewModel.swift
//  PartyTonight
//
//  Created by Igor Kasyanenko on 06.12.16.
//  Copyright © 2016 Igor Kasyanenko. All rights reserved.
//

import Foundation
import RxSwift
class FindVenueViewModel{
    var events: Observable<Result<[Event]>>;
    init(input:(
        zip:Observable<String>,
        findTouched:Observable<Void>
        ),API: (APIManager)) {
        
       events = input.findTouched.withLatestFrom(input.zip).flatMapLatest { (zipCode) -> Observable<Result<[Event]>> in
        print("api events! zip: \(zipCode)")
            return  API.event(zip: zipCode);
        }
        
        
    }
    
}

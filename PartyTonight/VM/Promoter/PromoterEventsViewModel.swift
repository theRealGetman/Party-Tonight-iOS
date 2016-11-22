//
//  PromoterEventsViewModel.swift
//  PartyTonight
//
//  Created by Igor Kasyanenko on 15.11.16.
//  Copyright © 2016 Igor Kasyanenko. All rights reserved.
//

import Foundation
import RxSwift

class PromoterEventsViewModel{
    var events: Observable<Result<[Event]>>;
    init(API: (APIManager)) {
        
        events = API.event();
        
    }
}

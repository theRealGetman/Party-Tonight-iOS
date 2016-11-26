//
//  PromoterEventViewModel.swift
//  PartyTonight
//
//  Created by Igor Kasyanenko on 26.11.16.
//  Copyright © 2016 Igor Kasyanenko. All rights reserved.
//

import Foundation
import RxSwift
class PromoterEventViewModel {
    var revenue:Observable<Revenue>
    init(dependency:(API:APIManager,event:Event)) {
        
        if let partyName = dependency.event.partyName{
            revenue =   dependency.API.revenue(getFor: partyName).map({ (result) -> Revenue in
                switch result{
                case .Success(let revenue):
                    
                    return revenue
                case .Failure(let error):
                    print(error)
                    if let e = error as? APIError{
                        DefaultWireframe.presentAlert(e.description)
                    }
                    return Revenue(revenue: "0")
                }
    
            })
        }else{
            DefaultWireframe.presentAlert("Undefined party name")
            revenue = Observable.just(Revenue(revenue: "0"))
        }
    }
}

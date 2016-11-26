//
//  EventStatementTotalViewModel.swift
//  PartyTonight
//
//  Created by Igor Kasyanenko on 26.11.16.
//  Copyright © 2016 Igor Kasyanenko. All rights reserved.
//

import Foundation
import RxSwift
class EventStatementTotalViewModel {
    var statementTotal:Observable<Total>
    init(dependency:(API:APIManager,event:Event)) {
        if let partyName = dependency.event.partyName{
            statementTotal =   dependency.API.total(getFor: partyName).map({ (result) -> Total in
                switch result{
                case .Success(let total):
                    
                    return total
                case .Failure(let error):
                    print(error)
                    if let e = error as? APIError{
                        DefaultWireframe.presentAlert(e.description)
                    }
                    return Total()
                }
                
            })
        }else{
            DefaultWireframe.presentAlert("Undefined party name")
            statementTotal = Observable.just(Total())
        }

    }
}

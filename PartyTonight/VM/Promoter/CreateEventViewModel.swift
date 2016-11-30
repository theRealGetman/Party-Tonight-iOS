//
//  CreateEventViewModel.swift
//  PartyTonight
//
//  Created by Igor Kasyanenko on 11.11.16.
//  Copyright © 2016 Igor Kasyanenko. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
class CreateEventViewModel{
    
    private var tablesArray:[Observable<Table>] = [];
    private var bottlesArray:[Observable<Bottle>] = [];
    var eventResponse: Observable<Result<Int>>!
    
    
    init(input: (
        clubName: Observable<String>,
        dateTime: Observable<String>,
        location: Observable<(address: String, zip: String?)>,
        uploadPhotosTaps: Observable<Void>,
        clubCapacity: Observable<String>,
        ticketsPrice: Observable<String>,
        partyName: Observable<String>,
        bottles: Observable<Observable<Bottle>>,
        tables: Observable<Observable<Table>>,
        createEventTaps: Observable<Void>
        ),
         API: (APIManager)) {
        
        let rxTables = input.tables.flatMapLatest{(v) -> Observable<[Table]> in
            self.tablesArray.append(v)
            return  Observable.combineLatest(self.tablesArray) { (elem) -> [Table] in
                return elem;
            }
        }
        
        let rxBottles = input.bottles.flatMapLatest{(v) -> Observable<[Bottle]> in
            self.bottlesArray.append(v)
            return  Observable.combineLatest(self.bottlesArray) { (elem) -> [Bottle] in
                return elem;
            }
        }
        
        
        
        
        
        let eventInfo = input.createEventTaps.withLatestFrom(Observable.combineLatest(input.clubName ,input.dateTime,input.location,input.clubCapacity, input.ticketsPrice, input.partyName,rxTables.startWith([]), rxBottles.startWith([])) { (clubName: $0,dateTime: $1 ,location: $2 ,clubCapacity: $3,ticketsPrice: $4,partyName: $5, tables: $6, bottles: $7) })
        
        eventResponse = eventInfo.flatMapLatest({ (clubName,dateTime ,location,clubCapacity,ticketsPrice,partyName, tables, bottles) -> Observable<Result<Int>> in
            
            // validating data
            
            if(!ValidationService.validate(quantity: clubCapacity)){
                return Observable.just(Result.Failure(ValidationResult.failed(message: "Incorrect club capacity")));
            }
            if(!ValidationService.validate(price: ticketsPrice)){
                return Observable.just(Result.Failure(ValidationResult.failed(message: "Incorrect tickets price")));
            }
            
            for (index,table) in tables.enumerated(){
                if(!ValidationService.validate(quantity: table.available) || !ValidationService.validate(price: table.price)){
                    return Observable.just(Result.Failure(ValidationResult.failed(message: "Incorrect \(index+1) bottle type")));
                }
            }
            for (index,bottle) in bottles.enumerated(){
                if(!ValidationService.validate(quantity: bottle.available) || !ValidationService.validate(price: bottle.price)){
                    return Observable.just(Result.Failure(ValidationResult.failed(message: "Incorrect \(index+1) table type")));
                }
            }
            //---------
            
            let df = DateFormatter();
            df.dateFormat = "EEEE, d MMM yyyy HH:mm"
            return API.event(create: Event(clubName: clubName,dateTime: df.date(from: dateTime) ?? Date() ,location: location.address,zipCode: location.zip,clubCapacity: clubCapacity,ticketsPrice: ticketsPrice,partyName: partyName, tables: tables, bottles: bottles))
        }).shareReplay(1)
        
    }
    
    
}

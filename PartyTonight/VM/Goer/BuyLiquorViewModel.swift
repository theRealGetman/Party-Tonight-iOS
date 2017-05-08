//
//  BuyLiquorViewModel.swift
//  PartyTonight
//
//  Created by Igor Kasyanenko on 03.02.17.
//  Copyright © 2017 Igor Kasyanenko. All rights reserved.
//

import Foundation
import RxSwift
class BuyLiquorViewModel{
    
    private var bottlesArray:[Observable<Bottle>] = [];
    var validatedBottles: Observable<Result<[Bottle]>>!
    
    
    init(input: (
        eventId:Int?,
        addToCartTap:Observable<Void>,
        bottles: Observable<Observable<Bottle>>),
         API: (APIManager)) {
        
        
        
        
        let rxBottles = input.bottles.flatMapLatest{(v) -> Observable<[Bottle]> in
            
            self.bottlesArray.append(v)
            
            return  Observable.combineLatest(self.bottlesArray) { elem -> [Bottle] in
                
                return elem;
            }
        }
        
        validatedBottles =  input.addToCartTap.withLatestFrom(rxBottles).flatMapLatest { (bottles) -> Observable<Result<[Bottle]>> in
            if(bottles.count == 0){
                return Observable.just(Result.Failure(ValidationResult.failed(message: "Bottles should be added")));
            }
            for (index,bottle) in bottles.enumerated(){
                if(!ValidationService.validate(quantity: bottle.available) || !ValidationService.validate(price: bottle.price)){
                    return Observable.just(Result.Failure(ValidationResult.failed(message: "Incorrect \(index+1) bottle type")));
                }
                
                if let available = bottle.available, let booked = bottle.booked{
                    print("booked \(booked) available \(available)")
                    if let available = Int(available), let booked = Int(booked){
                        let bookedAlready = bottle.id != nil && input.eventId != nil ? 0 : SharedCart.shared[input.eventId].get(bottleById: bottle.id!)?.booked ?? 0
                        if ((available - booked + bookedAlready) < 0){
                            return Observable.just(Result.Failure(ValidationResult.failed(message: "Tried to book (\(bookedAlready+booked) items) more items than available (\(available) items)")));
                        }
                    }else {
                        return Observable.just(Result.Failure(ValidationResult.failed(message: "Wrong input data on bottle type: \(bottle.type ?? "empty bottle type field")")));
                    }
                }else {
                    return Observable.just(Result.Failure(ValidationResult.failed(message: "Wrong input data on bottle type: \(bottle.type ?? "empty bottle type field")")));
                }
                
                
            }
            //mock
            return Observable.just(Result.Success(bottles))
            
        }
        
        
        
    }
}

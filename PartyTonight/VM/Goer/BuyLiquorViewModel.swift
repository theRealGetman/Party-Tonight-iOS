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
    
    
    init(
        bottles: Observable<Observable<Bottle>>,
        API: (APIManager)) {
        
        
        
        
        let rxBottles = bottles.flatMapLatest{(v) -> Observable<[Bottle]> in
            
            self.bottlesArray.append(v)
            
            return  Observable.combineLatest(self.bottlesArray) { elem -> [Bottle] in
                
                return elem;
            }
        }
        
        validatedBottles =  rxBottles.flatMapLatest { (bottles) -> Observable<Result<[Bottle]>> in
            if(bottles.count == 0){
                return Observable.just(Result.Failure(ValidationResult.failed(message: "Bottles should be added")));
            }
            for (index,bottle) in bottles.enumerated(){
                if(!ValidationService.validate(quantity: bottle.available) || !ValidationService.validate(price: bottle.price)){
                    return Observable.just(Result.Failure(ValidationResult.failed(message: "Incorrect \(index+1) bottle type")));
                }
            }
            //mock
            return Observable.just(Result.Success(bottles))
            
        }
        
        
        
    }
}

//
//  BuyLiquorViewController.swift
//  PartyTonight
//
//  Created by Igor Kasyanenko on 03.02.17.
//  Copyright © 2017 Igor Kasyanenko. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol BottleChosenDelegate {
    func choose(bottle:Bottle)
}


class BuyLiquorViewController: UIViewController,BottleChosenDelegate {
  

    @IBOutlet weak var addMoreLiquorTypeButton: UIButton!

    @IBOutlet weak var bottlesStackView: UIStackView!
    var vm:BuyLiquorViewModel?
    
    @IBOutlet weak var addToCartButton: UIButton!
    
   
    @IBAction func addToCartButtonTouched(_ sender: UIButton) {
        
    }
    var disposeBag = DisposeBag();
    var bottles:[Bottle] = [];
    var eventId:Int? = 0
    var ticket:Ticket?
    
    func choose(bottle: Bottle) {
        
    }
    
    func addToCart(orderedBottles:[Bottle]){
        do{
            SharedCart.shared[eventId].ticket = ticket
         try SharedCart.shared[eventId].add(bottles: orderedBottles)
            navigationController?.popViewController(animated: true)
        } catch {
           print("addToCart bottle error \(error)")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        

//             let bottlesResponse = Observable.from([1,3,7]).map({ (tst) -> Bottle in
//                print("one \(tst)")
//                let bottle = Bottle(price:"6",type:"\(tst)", available: "99");
//                bottle.id = 666
//                 self.bottles.append(bottle)
//                return bottle;
//             }).toArray()
        
        
      //  let bottlesResponse = Observable.from(bottles)
        let rxBottles = addMoreLiquorTypeButton.rx.tap.asObservable().map{ (bottlesList) -> Observable<Bottle> in
            let view = LiquorView(frame: CGRect(x: 0, y: 0, width: 144, height: 200))
   
            
            view.typeTextField.delegate = self;
            
            
            self.bottlesStackView.addArrangedSubview(view);
            
            let typeEntity = view.typeEntity.asObservable()
            let type = view.typeTextField.rx.text.orEmpty.asObservable()
            let price = view.priceTextField.rx.text.orEmpty.asObservable()
            let quantity = view.quantityTextField.rx.text.orEmpty.asObservable()
            let bottleEntity = Observable.combineLatest(type, typeEntity, price, quantity) { ($0, $1, $2, $3)}.flatMap({  (type, typeEntity, price, quantity) -> Observable<Bottle> in
                
                var avail = 0
                if let entity = typeEntity{
                    if let available = entity.available, let booked = entity.booked{
                        if let available = Int(available), let booked = Int(booked){
                            avail = available - booked
                        }
                    }
                    
                }
                
                
                let b = Bottle(price: typeEntity?.price,type: typeEntity?.type ?? type,available: String(avail), booked: quantity)
                b.id = typeEntity?.id;
                
                return  Observable.just(b);
            })
            return bottleEntity;
        }
//            .subscribe(onNext: { (b) in
//           
//        }, onError: { (err) in
//            
//        }, onCompleted: {
//            
//        }) { 
//            
//        }
        vm = BuyLiquorViewModel(input:(eventId: eventId, addToCartTap: addToCartButton.rx.tap.asObservable() , bottles: rxBottles), API: APIManager.sharedAPI)
        
        
       vm?.validatedBottles.subscribe(onNext: { (result) in
        switch result {
        case .Success(let bottles):
            
            self.addToCart(orderedBottles: bottles)
           
            
        case .Failure(let error):
            
            DefaultWireframe.presentAlert("\(error)")
        }

       }, onError: { (err) in
        
       }, onCompleted: {
        
       }, onDisposed: {
        
       }).addDisposableTo(disposeBag)
        // Do any additional setup after loading the view.
        
        addMoreLiquorTypeButton.sendActions(for: UIControlEvents.touchUpInside)
    }

    
    func myTargetFunction(textField: UITextField) {
        // user touch field
    }
    
    func popover(sourceView: LiquorView, data:[Bottle]){
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "LiquorTypePickerViewController") as! LiquorTypePickerViewController; // your initialization goes here
        controller.bottleList = data;
        
        // set modal presentation style to popover on your view controller
        // must be done before you reference controller.popoverPresentationController
        controller.modalPresentationStyle = .popover;
        controller.preferredContentSize = CGSize(width:sourceView.typeTextField.bounds.width, height:220);
        
        
        
        // configure popover style & delegate
        let popover =  controller.popoverPresentationController;
        controller.delegate = sourceView
        popover?.delegate = controller;
        popover?.sourceView = sourceView.typeTextField;
        popover?.sourceRect = CGRect(x:sourceView.typeTextField.frame.origin.x+100,y:sourceView.typeTextField.frame.origin.y+sourceView.typeTextField.frame.height,width:1,height:1);
        popover?.permittedArrowDirections = .any;
        
        // display the controller in the usual way
        self.present(controller, animated:true, completion:nil);
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

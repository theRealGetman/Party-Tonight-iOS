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
    
    @IBAction func addToCartButtonTouched(_ sender: UIButton) {
        print("addToCart")
    }
    var disposeBag = DisposeBag();
    var bottles:[Bottle] = [];
    
    func choose(bottle: Bottle) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

             let bottlesResponse = Observable.from([1,3,7]).map({ (tst) -> Bottle in
                print("one \(tst)")
                let bottle = Bottle(price:"6",type:"\(tst)", available: "99");
                 self.bottles.append(bottle)
                return bottle;
             }).toArray()
        
        
        let rxBottles = addMoreLiquorTypeButton.rx.tap.asObservable().withLatestFrom(bottlesResponse).map{ (bottlesList) -> Observable<Bottle> in
            print("array$$$")
            print(bottlesList)
            
            let view = LiquorView(frame: CGRect(x: 0, y: 0, width: 144, height: 200))
            
            
         
            
//            view.typeTextField.rx.controlEvent(UIControlEvents.allEvents).subscribe(onNext: { (_) in
//                print("kl")
//                
//                
//             
//                self.popover(sourceView: view, data: self.bottles)
//                
//              
//            }, onError: { (_) in
//                
//            }, onCompleted: {
//               
//            }, onDisposed: {
//                
//            }).addDisposableTo(self.disposeBag)
                
//                .asObservable().map({ (_) -> Void in
//                print("test")
//                view.typeTextField.text = "hghghgh";
//            })
            
            
            //addTarget(self, action: #selector(BuyLiquorViewController.myTargetFunction(textField:)), for: UIControlEvents.touchDown)
            
            view.typeTextField.delegate = self;
            
            
            self.bottlesStackView.addArrangedSubview(view);
            
            let typeEntity = view.typeEntity.asObservable()
            let type = view.typeTextField.rx.text.orEmpty.asObservable()
            let price = view.priceTextField.rx.text.orEmpty.asObservable()
            let quantity = view.quantityTextField.rx.text.orEmpty.asObservable()
            let bottleEntity = Observable.combineLatest(type, typeEntity, price, quantity) { ($0, $1, $2, $3)}.flatMap({  (type, typeEntity, price, quantity) -> Observable<Bottle> in
                
                return  Observable.just(Bottle(price: price,type: type,available: quantity));
            })
            return bottleEntity;
        }.subscribe(onNext: { (bottle) in
            
        }, onError: { (err) in
            
        }, onCompleted: {
            
        }) { 
            
        }
        addMoreLiquorTypeButton.sendActions(for: UIControlEvents.touchUpInside)
        // Do any additional setup after loading the view.
    }

    
    func myTargetFunction(textField: UITextField) {
        // user touch field
    }
    
    func popover(sourceView: LiquorView, data:[Bottle]){
        var controller = self.storyboard?.instantiateViewController(withIdentifier: "LiquorTypePickerViewController") as! LiquorTypePickerViewController; // your initialization goes here
        controller.bottleList = data;
        
        // set modal presentation style to popover on your view controller
        // must be done before you reference controller.popoverPresentationController
        controller.modalPresentationStyle = .popover;
        controller.preferredContentSize = CGSize(width:sourceView.typeTextField.bounds.width, height:220);
        
        
        
        // configure popover style & delegate
        var popover =  controller.popoverPresentationController;
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

//
//  CreateEventViewController.swift
//  PartyTonight
//
//  Created by Igor Kasyanenko on 11.11.16.
//  Copyright © 2016 Igor Kasyanenko. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
class CreateEventViewController: UIViewController, DataEnteredDelegate {
    
    @IBAction func createTouched(_ sender: UIButton) {
        
        //print("location! \(locationTextField.text)")
    }
    
    @IBOutlet weak var uploadPhotosButton: UIButton!
    @IBOutlet weak var bottlesStackView: UIStackView!
    @IBOutlet weak var addMoreLiquorTypeButton: UIButton!
    @IBOutlet weak var addMoreTableTypeButton: UIButton!
    @IBOutlet weak var tablesStackView: UIStackView!
    
    @IBOutlet weak var clubNameTextField: UITextField!
    
    @IBOutlet weak var dateAndTimeTextField: UITextField!
    
    @IBOutlet weak var locationTextField: UITextField!
    
    @IBOutlet weak var clubCapacityTextField: UITextField!
    
    @IBOutlet weak var ticketsPriceTextView: UITextField!
    
    @IBOutlet weak var partyNameTextView: UITextField!
    
    @IBOutlet weak var createEventButton: UIButton!
    
    let disposeBag = DisposeBag();
    
    var zipCode = Variable<String?>("");
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTextFieldPlaceholders()
        
        
        locationTextField.delegate = self;
        dateAndTimeTextField.delegate = self;
        
        let rxTables = addMoreTableTypeButton.rx.tap.asObservable().map{ (_) -> Observable<Table> in
            let tableView = TypePriceQuantityView(frame: CGRect(x: 0, y: 0, width: 144, height: 200))
            self.tablesStackView.addArrangedSubview(tableView);
            let type = tableView.typeTextField.rx.text.orEmpty.asObservable()
            let price = tableView.priceTextField.rx.text.orEmpty.asObservable()
            let quantity = tableView.quantityTextField.rx.text.orEmpty.asObservable()
            let tableEntity = Observable.combineLatest(type, price, quantity) { ($0, $1, $2)}.flatMap({  (type, price, quantity) -> Observable<Table> in
                return  Observable.just(Table(price: price,type: type,available: quantity));
            })
            return tableEntity;
        }
        
        let rxBottles = addMoreLiquorTypeButton.rx.tap.asObservable().map{ (_) -> Observable<Bottle> in
            let tableView = TypePriceQuantityView(frame: CGRect(x: 0, y: 0, width: 144, height: 200))
            self.bottlesStackView.addArrangedSubview(tableView);
            let type = tableView.typeTextField.rx.text.orEmpty.asObservable()
            let price = tableView.priceTextField.rx.text.orEmpty.asObservable()
            let quantity = tableView.quantityTextField.rx.text.orEmpty.asObservable()
            let bottleEntity = Observable.combineLatest(type, price, quantity) { ($0, $1, $2)}.flatMap({  (type, price, quantity) -> Observable<Bottle> in
                return  Observable.just(Bottle(price: price,type: type,available: quantity));
            })
            return bottleEntity;
        }
        
        
        // locationTextField.rx.te
        
        //let c = Observable.combineLatest( locationTextField.rx.text.orEmpty.asObservable()) { ($0) }
        let t = Observable.combineLatest(locationTextField.rx.text.orEmpty.asObservable(), zipCode.asObservable()) { (address: $0, zip: $1) }
        let viewModel = CreateEventViewModel(input: (clubName: clubNameTextField.rx.text.orEmpty.asObservable(), dateTime: dateAndTimeTextField.rx.text.orEmpty.asObservable(), location: t, uploadPhotosTaps: uploadPhotosButton.rx.tap.asObservable(), clubCapacity: clubCapacityTextField.rx.text.orEmpty.asObservable(), ticketsPrice: ticketsPriceTextView.rx.text.orEmpty.asObservable(), partyName: partyNameTextView.rx.text.orEmpty.asObservable(), bottles: rxBottles, tables: rxTables,createEventTaps: createEventButton.rx.tap.asObservable()), API: APIManager.sharedAPI);
        
        
        
        
        viewModel.eventResponse.subscribe (onNext: { (code) in
            switch code {
            case .Success(let code):
                print("Created: \(code)")
                
                self.goToPromoterScreen()
            case .Failure(let error):
                print(error)
                if let e = error as? APIError{
                    DefaultWireframe.presentAlert(e.description)
                }
            }
        }).addDisposableTo(disposeBag)
        
        
        
        
    }
    
    func goToPromoterScreen() {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    
    func setTextFieldPlaceholders(){
        clubNameTextField.attributedPlaceholder = NSAttributedString(string:"Club Name", attributes:[NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: UIFont(name: "Aguda-Regular2", size: 18.0)! ])
        
        dateAndTimeTextField.attributedPlaceholder = NSAttributedString(string:"Date and Time", attributes:[NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: UIFont(name: "Aguda-Regular2", size: 18.0)! ])
        
        locationTextField.attributedPlaceholder = NSAttributedString(string:"Location", attributes:[NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: UIFont(name: "Aguda-Regular2", size: 18.0)! ])
        
        clubCapacityTextField.attributedPlaceholder = NSAttributedString(string:"Club capacity", attributes:[NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: UIFont(name: "Aguda-Regular2", size: 18.0)! ])
        
        ticketsPriceTextView.attributedPlaceholder = NSAttributedString(string:"Tickets price", attributes:[NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: UIFont(name: "Aguda-Regular2", size: 18.0)! ])
        
        partyNameTextView.attributedPlaceholder = NSAttributedString(string:"Party name", attributes:[NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: UIFont(name: "Aguda-Regular2", size: 18.0)! ])
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

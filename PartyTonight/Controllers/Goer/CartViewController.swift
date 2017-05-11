//
//  CartViewController.swift
//  PartyTonight
//
//  Created by Igor Kasyanenko on 05.05.17.
//  Copyright © 2017 Igor Kasyanenko. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class CartViewController: UIViewController{
    
    @IBOutlet weak var payWithPayPalButton: UIButton!
    @IBOutlet weak var clearBarButton: UIBarButtonItem!
    
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    private var allCarts = [Cart]()
    var carts: [Cart]{
        get {
            return allCarts
        }
        set (newVal){
            allCarts = newVal
            updateTotalPrice()
        }
    }
    var vm:CartViewModel?
    var disposeBag = DisposeBag()
    
    @IBAction func clearButtonTouched(_ sender: UIBarButtonItem) {
        SharedCart.shared.clear()
        carts = SharedCart.shared.asArray
        tableView.reloadData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        setViewModel()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setViewModel() {
        carts = SharedCart.shared.asArray
        
        vm = CartViewModel(input: (payWithPaypalTap: payWithPayPalButton.rx.tap.asObservable() , clearCartTap: clearBarButton.rx.tap.asObservable()), API: APIManager.sharedAPI)
        vm?.transaction.asObservable().subscribe(onNext: { (tr) in
            SharedCart.shared.bookings = tr.order
            self.carts = SharedCart.shared.asArray
            self.tableView.reloadData()
        }, onError: { (error) in
            print("sharedCart error \(error.localizedDescription)")
        }, onCompleted: {
            
        }, onDisposed: {
            
        }).addDisposableTo(disposeBag)
        
    }
    
    
    func updateTotalPrice(){
        totalLabel.text = "\(SharedCart.shared.total)"
    }
    
    
}

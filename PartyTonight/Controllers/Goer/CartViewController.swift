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

class CartViewController: UIViewController
    //, PayPalPaymentDelegate
{
    
//    public func paymentSuccess(withKey payKey: String!, andStatus paymentStatus: PayPalPaymentStatus) {
//        
//    }

    
//    
//    var environment:String = PayPalEnvironmentNoNetwork {
//        willSet(newEnvironment) {
//            if (newEnvironment != environment) {
//                PayPalMobile.preconnect(withEnvironment: newEnvironment)
//            }
//        }
//    }
//    var payPalConfig = PayPalConfiguration()
//    
//    func setPayPal(){
//        payPalConfig.acceptCreditCards = false
//        payPalConfig.merchantName = "Awesome Shirts, Inc."
//        payPalConfig.merchantPrivacyPolicyURL = URL(string: "https://www.paypal.com/webapps/mpp/ua/privacy-full")
//        payPalConfig.merchantUserAgreementURL = URL(string: "https://www.paypal.com/webapps/mpp/ua/useragreement-full")
//        
//        
//        payPalConfig.languageOrLocale = Locale.preferredLanguages[0]
//        
//        
//        
//        
//         print("PayPal iOS SDK Version: \(PayPalMobile.libraryVersion())")
//    }
//    
//    
//    func payWithPayPal(){
//        // Optional: include multiple items
//        let item1 = PayPalItem(name: "Old jeans with holes", withQuantity: 2, withPrice: NSDecimalNumber(string: "84.99"), withCurrency: "USD", withSku: "Hip-0037")
//        let item2 = PayPalItem(name: "Free rainbow patch", withQuantity: 1, withPrice: NSDecimalNumber(string: "0.00"), withCurrency: "USD", withSku: "Hip-00066")
//        let item3 = PayPalItem(name: "Long-sleeve plaid shirt (mustache not included)", withQuantity: 1, withPrice: NSDecimalNumber(string: "37.99"), withCurrency: "USD", withSku: "Hip-00291")
//        
//        let items = [item1, item2, item3]
//        let subtotal = PayPalItem.totalPrice(forItems: items)
//        
//        // Optional: include payment details
//        let shipping = NSDecimalNumber(string: "5.99")
//        let tax = NSDecimalNumber(string: "2.50")
//        let paymentDetails = PayPalPaymentDetails(subtotal: subtotal, withShipping: shipping, withTax: tax)
//        
//        let total = subtotal.adding(shipping).adding(tax)
//        
//        let payment = PayPalPayment(amount: total, currencyCode: "USD", shortDescription: "Hipster Clothing", intent: .sale)
//       
//        
//        
//        payment.items = items
//        payment.paymentDetails = paymentDetails
//        
//        if (payment.processable) {
//            let paymentViewController = PayPalPaymentViewController(payment: payment, configuration: payPalConfig, delegate: self)
//            present(paymentViewController!, animated: true, completion: nil)
//        }
//        else {
//            // This particular payment will always be processable. If, for
//            // example, the amount was negative or the shortDescription was
//            // empty, this payment wouldn't be processable, and you'd want
//            // to handle that here.
//            print("Payment not processalbe: \(payment)")
//        }
//
//    }
//    
//    
//    
//    func payPalPaymentDidCancel(_ paymentViewController: PayPalPaymentViewController) {
//        print("PayPal Payment Cancelled")
////        resultText = ""
////        successView.isHidden = true
//        paymentViewController.dismiss(animated: true, completion: nil)
//    }
//    
//    func payPalPaymentViewController(_ paymentViewController: PayPalPaymentViewController, didComplete completedPayment: PayPalPayment) {
//        print("PayPal Payment Success !")
//        paymentViewController.dismiss(animated: true, completion: { () -> Void in
//            // send completed confirmaion to your server
//            print("Here is your proof of payment:\n\n\(completedPayment.confirmation)\n\nSend this to your server for confirmation and fulfillment.")
//            
////            self.resultText = completedPayment.description
////            self.showSuccess()
//        })
//    }
//    
//    
//    
//    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        PayPalMobile.preconnect(withEnvironment: environment)
//    }
//    
    
    
    @IBOutlet weak var payWithPayPalButton: UIButton!
    @IBOutlet weak var clearBarButton: UIBarButtonItem!
    
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    
    var carts = [Cart]()
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
        
        // Do any additional setup after loading the view.
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
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

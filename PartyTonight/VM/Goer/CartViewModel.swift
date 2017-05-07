//
//  CartViewModel.swift
//  PartyTonight
//
//  Created by Igor Kasyanenko on 06.05.17.
//  Copyright © 2017 Igor Kasyanenko. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class CartViewModel {
    var disposeBag = DisposeBag()
    var sharedCart:Variable<SharedCart> = Variable(SharedCart.shared)
    
    init(input:(payWithPaypalTap:Observable<Void>,clearCartTap:Observable<Void>),API: APIManager) {
        
        
        
        
        input.payWithPaypalTap.withLatestFrom(sharedCart.asObservable()).flatMapLatest { (c) -> Observable<Result<[Booking]>> in
            return API.validate(bookings: c.bookings)
            }.subscribe(onNext: { (items) in
                
                switch items {
                case .Success(let bookings):
                    
                    self.sharedCart.value.bookings = bookings
                    
                case .Failure(let error):
                    print(error)
                    if let e = error as? APIError{
                        DefaultWireframe.presentAlert(e.description)
                    } else if let e = error as? ValidationResult{
                        DefaultWireframe.presentAlert(e.description)
                    }
                }
                
            }, onError: { (err) in
                DefaultWireframe.presentAlert(err.localizedDescription)
            }, onCompleted: {
                
            }) {
                
            }.addDisposableTo(disposeBag)
    }
    
    
    
    
    
    var forDelivery = false
    var paymentType = ""
    func payWithPayPal() {
        //Advanced Payment
        guard var ppMEP = PayPal.getInst()  else {
            
        }
       
        
        ppMEP.shippingEnabled = forDelivery;
        ppMEP.dynamicAmountUpdateEnabled = false;
        ppMEP.feePayer = FEEPAYER_EACHRECEIVER;
        
        var payment = PayPalAdvancedPayment()
        payment.paymentCurrency = "USD";
        // payment.paymentType = paymentType;
        // payment.paymentSubType = "";
        payment.receiverPaymentDetails = [];
        var emails = ["recipient1@email.com", "recipient2@email.com", "recipient3@email.com", nil];
        
        for i in 0..<emails.count
        {
            var details: PayPalReceiverPaymentDetails = PayPalReceiverPaymentDetails()
            var order, tax, shipping: String;
            
            tax = taxAmount[i];
            shipping = shippingAmount[i];
            details.invoiceData = PayPalInvoiceData();
            
            
            details.invoiceData.totalTax = NSDecimalNumber(string:tax);
            details.invoiceData.totalShipping = NSDecimalNumber(string:shipping);
            details.description = description;
            details.recipient = emails[i];
            details.merchantName = String(format:"Recipient %d",i+1);
            payment.receiverPaymentDetails.add(details);
        }
        ppMEP.advancedCheckout(with: payment);
    }
    
    
    
    
}

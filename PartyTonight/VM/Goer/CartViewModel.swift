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

enum PayPalError:Error{
    case InstanceError
    case MissingParametersForPayment
}

class CartViewModel {
    
    var transaction:Variable<Transaction> = Variable(Transaction(sharedCart: SharedCart.shared))
    
    private var forDelivery = false
    private var disposeBag = DisposeBag()
    
    init(input:(payWithPaypalTap:Observable<Void>,clearCartTap:Observable<Void>),API: APIManager) {
        
        
        
//        
//        input.payWithPaypalTap.withLatestFrom(sharedCart.asObservable()).flatMapLatest { (c) -> Observable<Result<[Booking]>> in
//            return API.validate(bookings: c.bookings)
//            }.subscribe(onNext: { (items) in
//                
//                switch items {
//                case .Success(let bookings):
//                    
//                    self.sharedCart.value.bookings = bookings
//                    
//                case .Failure(let error):
//                    print(error)
//                    if let e = error as? APIError{
//                        DefaultWireframe.presentAlert(e.description)
//                    } else if let e = error as? ValidationResult{
//                        DefaultWireframe.presentAlert(e.description)
//                    }
//                }
//                
//            }, onError: { (err) in
//                DefaultWireframe.presentAlert(err.localizedDescription)
//            }, onCompleted: {
//                
//            }) {
//                
//            }.addDisposableTo(disposeBag)
        
        
        
        
        input.payWithPaypalTap.withLatestFrom(transaction.asObservable()).flatMapLatest { (t) -> Observable<Result<Transaction>> in
            return API.transaction(bookings: t.order)
            }.subscribe(onNext: { (t) in
                
                switch t {
                case .Success(let trans):
                    
                    self.transaction.value = trans
                    
                    do{
                        try self.payWithPayPal(transaction: trans)
                    } catch {
                        DefaultWireframe.presentAlert(error.localizedDescription)
                    }
                    
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
    
    func payWithPayPal(transaction:Transaction) throws {
        //Advanced Payment
        guard let ppMEP = PayPal.getInst()  else {
            throw PayPalError.InstanceError
        }
        ppMEP.shippingEnabled = forDelivery;
        ppMEP.dynamicAmountUpdateEnabled = false;
        ppMEP.feePayer = FEEPAYER_SENDER//FEEPAYER_EACHRECEIVER;
        let payment = PayPalAdvancedPayment()
        payment.paymentCurrency = "USD";
        // payment.paymentType = paymentType;
        // payment.paymentSubType = "";
        payment.receiverPaymentDetails = [];

        if let sellerBillingEmail = transaction.sellerBillingEmail, let subtotal = transaction.subtotal, let serviceBillingEmail = transaction.serviceBillingEmail, let serviceTax = transaction.serviceTax {
            let orderPayment = orderPaymentDetails(sellerBillingEmail: sellerBillingEmail, order: transaction.order, subtotal: subtotal, description: "Payment for order")
            let taxForOrderPayment = taxForOrderPaymentDetails(serviceBillingEmail: serviceBillingEmail, serviceTax: serviceTax, description: "Payment for tax of the order")
            
            payment.receiverPaymentDetails.add(orderPayment);
            payment.receiverPaymentDetails.add(taxForOrderPayment);
        }else {
            throw PayPalError.MissingParametersForPayment
        }
        OperationQueue.main.addOperation {
            ppMEP.advancedCheckout(with: payment);
        }
    }
    
   private func orderPaymentDetails(sellerBillingEmail: String, order:[Booking], subtotal:Double, description: String, tax: String = "0", totalShipping: String = "0") -> PayPalReceiverPaymentDetails {
        let details: PayPalReceiverPaymentDetails = PayPalReceiverPaymentDetails()
        details.invoiceData = PayPalInvoiceData();
        details.invoiceData.totalTax = NSDecimalNumber(string:tax);
        details.invoiceData.totalShipping = NSDecimalNumber(string:totalShipping);
        details.description = description;
        details.recipient = sellerBillingEmail;
        details.merchantName = String(format:"Recipient %@",sellerBillingEmail);
        
        var items = [PayPalInvoiceItem]()
        for booking in order {
            
            if let bottles = booking.bottles{
                for bottle in bottles {
                    let item = PayPalInvoiceItem()
                    item.itemId = String(bottle.id)
                    item.name = bottle.type
                    item.itemCount = NSNumber(value: bottle.booked)
                    item.itemPrice = NSDecimalNumber(string: bottle.price)
                    items.append(item)
                }
            }
            
            if let table = booking.table{
                let item = PayPalInvoiceItem()
                item.itemId = String(table.id)
                item.name = table.type
                item.itemCount = NSNumber(value: table.booked)
                item.itemPrice = NSDecimalNumber(string: table.price)
                items.append(item)
            }
        }
        
        details.subTotal = NSDecimalNumber(value:subtotal);
        
        return details
    }
    
   private func taxForOrderPaymentDetails(serviceBillingEmail: String, serviceTax: Double, description: String, tax: String = "0", totalShipping: String = "0") -> PayPalReceiverPaymentDetails {
        let details: PayPalReceiverPaymentDetails = PayPalReceiverPaymentDetails()
        details.invoiceData = PayPalInvoiceData();
        details.invoiceData.totalTax = NSDecimalNumber(string:tax);
        details.invoiceData.totalShipping = NSDecimalNumber(string:totalShipping);
        details.description = description;
        details.recipient = serviceBillingEmail;
        details.subTotal = NSDecimalNumber(value:serviceTax);
        details.merchantName = String(format:"Recipient %@",serviceBillingEmail)
        
        return details
    }
    
    
    
    
    //    var forDelivery = false
    //    var paymentType = ""
    //    var taxAmount = "0"
    //    var shippingAmount = "0"
    //    func payWithPayPal(transactions:[Transaction]) {
    //        //Advanced Payment
    //        guard var ppMEP = PayPal.getInst()  else {
    //
    //        }
    //
    //
    //        ppMEP.shippingEnabled = forDelivery;
    //        ppMEP.dynamicAmountUpdateEnabled = false;
    //        ppMEP.feePayer = FEEPAYER_SENDER//FEEPAYER_EACHRECEIVER;
    //
    //        var payment = PayPalAdvancedPayment()
    //        payment.paymentCurrency = "USD";
    //        // payment.paymentType = paymentType;
    //        // payment.paymentSubType = "";
    //        payment.receiverPaymentDetails = [];
    //        var emails = ["recipient1@email.com", "recipient2@email.com", "recipient3@email.com", nil];
    //
    //        for i in 0..<transactions.count
    //        {
    //            var details: PayPalReceiverPaymentDetails = PayPalReceiverPaymentDetails()
    //            var order, tax, shipping: String;
    //
    //            tax = taxAmount;
    //            shipping = shippingAmount;
    //
    //
    //            details.invoiceData = PayPalInvoiceData();
    //
    //
    //            details.invoiceData.totalTax = NSDecimalNumber(string:tax);
    //            details.invoiceData.totalShipping = NSDecimalNumber(string:shipping);
    //            details.description = description;
    //            details.recipient = transactions[i].billingEmail;
    //            details.merchantName = String(format:"Recipient %d",i+1);
    //            payment.receiverPaymentDetails.add(details);
    //        }
    //        ppMEP.advancedCheckout(with: payment);
    //    }
    //    
    //    
    
    
}

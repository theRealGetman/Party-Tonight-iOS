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
    case NotInitialized
    case InvalidBooking
    case NoItemsToPayFor
}

class CartViewModel {
    
    var transaction:Variable<Transaction> = Variable(Transaction(sharedCart: SharedCart.shared))
    
    private var forDelivery = false
    private var disposeBag = DisposeBag()
    
    init(input:(payWithPaypalTap:Observable<Void>,clearCartTap:Observable<Void>),API: APIManager) {
        
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
        
        
        let orderPayments = try orderPaymentDetails( transaction: transaction)
        
        if orderPayments.count > 0 {
            for p in orderPayments{
                payment.receiverPaymentDetails.add(p);
            }
        }else {
            throw PayPalError.NoItemsToPayFor
        }
        
        
        if (PayPal.initializationStatus() == STATUS_COMPLETED_SUCCESS) {
            //We have successfully initialized and are ready to pay
            OperationQueue.main.addOperation {
                ppMEP.advancedCheckout(with: payment);
            }
        } else {
            PayPal.initialize(withAppID: PayPalUtils.appId, for: ENV_LIVE)
            throw PayPalError.NotInitialized
            //An error occurred
        }
    }
    
    private func orderPaymentDetails( transaction:Transaction, totalShipping: String = "0", totalTax:String = "0") throws -> [PayPalReceiverPaymentDetails] {
        
        
        let order = transaction.order
        
        var detailsList = [PayPalReceiverPaymentDetails]()
        
        for booking in order {
            
            if let sellerBillingEmail = booking.sellerBillingEmail, let subtotal = booking.subtotal{
                
                let details: PayPalReceiverPaymentDetails = PayPalReceiverPaymentDetails()
                details.invoiceData = PayPalInvoiceData();
                details.invoiceData.totalTax = NSDecimalNumber(string:totalTax);
                details.invoiceData.totalShipping = NSDecimalNumber(string:totalShipping);
                details.description = "Payment for order in event #\(booking.idEvent)";
                details.recipient = sellerBillingEmail;
                details.merchantName = String(format:"Recipient %@",sellerBillingEmail);
                
                
                
                var items = [PayPalInvoiceItem]()
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
                
                if let ticket = booking.ticket{
                    if let booked = ticket.booked, let price = ticket.price{
                        let item = PayPalInvoiceItem()
                        item.itemId = "\(ticket.id)"
                        item.name =  ticket.type
                        item.itemCount = NSNumber(value: Int(booked) ?? 1)
                        item.itemPrice = NSDecimalNumber(string: price)
                        items.append(item)
                    }
                }
                
                for item in items{
                    details.invoiceData.invoiceItems.add(item)
                }
                details.subTotal = NSDecimalNumber(value:subtotal);
                
                detailsList.append(details)
            }else{
                throw PayPalError.InvalidBooking
                //todo throw
            }
            
        }
        
        
        if let serviceBillingEmail = transaction.serviceBillingEmail, let serviceTax = transaction.serviceTax{
            let taxForOrderPayment = taxForOrderPaymentDetails(serviceBillingEmail: serviceBillingEmail, serviceTax: serviceTax, description: "Transaction tax",tax: totalTax, totalShipping: totalShipping)
            detailsList.append(taxForOrderPayment)
        }else{
            print("Payment without tax")
        }
        
        
        
        return detailsList
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

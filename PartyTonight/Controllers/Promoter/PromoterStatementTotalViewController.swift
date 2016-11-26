//
//  PromoterStatementTotalViewController.swift
//  PartyTonight
//
//  Created by Igor Kasyanenko on 19.11.16.
//  Copyright © 2016 Igor Kasyanenko. All rights reserved.
//

import UIKit
import RxSwift
class PromoterStatementTotalViewController: UIViewController {

    @IBOutlet weak var statementTotalAmountLabel: UILabel!
    
    @IBOutlet weak var ticketsSalesAmountLabel: UILabel!
    
    @IBOutlet weak var bottlesSalesAmount: UILabel!
    
    @IBOutlet weak var tableSalesAmount: UILabel!
    
    @IBOutlet weak var refundsAmountLabel: UILabel!
    @IBOutlet weak var withdrawAmountLabel: UILabel!
    
    var event:Event?
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let evt = event else {
            return
        }
        print("statement")
        let viewModel = EventStatementTotalViewModel(dependency: (API: APIManager.sharedAPI, event: evt))
        viewModel.statementTotal.subscribe(onNext: { (total) in
            
            self.statementTotalAmountLabel.text = "$\(total.withdrawn ?? "$0")";
            self.ticketsSalesAmountLabel.text = "$\(total.ticketsSales ?? "$0")";
            self.bottlesSalesAmount.text = "$\(total.bottleSales ?? "$0")";
            self.tableSalesAmount.text = "$\(total.tableSales ?? "$0")";
            self.refundsAmountLabel.text = "$\(total.refunds ?? "$0")";
            self.withdrawAmountLabel.text = "$\(total.withdrawn ?? "$0")";
            
        }, onError: { (error) in
            print("Caught an error: \(error)")
        }, onCompleted:{
            
        }).addDisposableTo(disposeBag)
        // Do any additional setup after loading the view.
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

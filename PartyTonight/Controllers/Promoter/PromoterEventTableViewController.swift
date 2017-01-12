//
//  PromoterEventTableViewController.swift
//  PartyTonight
//
//  Created by Igor Kasyanenko on 18.11.16.
//  Copyright © 2016 Igor Kasyanenko. All rights reserved.
//

import UIKit
import RxSwift
class PromoterEventTableViewController: UITableViewController {
    @IBOutlet weak var doorRevenueAmountLabel: UILabel!
    let disposeBag = DisposeBag();
    var event:Event?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("promEvVC")
        initView()
        
        guard let evt = event else {
            return
        }
        
        let viewModel = PromoterEventViewModel(dependency: (API: APIManager.sharedAPI, event: evt))
        
        
        
        viewModel.revenue.subscribe(onNext: { (rev) in
            self.doorRevenueAmountLabel.text = "$\(rev.revenue ?? "0")"
            
        }, onError: { (error) in
            print("Caught an error: \(error)")
        }, onCompleted:{
            
        }).addDisposableTo(disposeBag)
        
        //APIManager.sharedAPI.revenue(getFor: event?.partyName)
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    
    func initView(){
        // Add a background view to the table view
        let backgroundImage = UIImage(named: "bg_blur")
        let imageView = UIImageView(image: backgroundImage)
        self.tableView.backgroundView = imageView
        imageView.contentMode = .scaleAspectFill
        
        navigationItem.title = event?.partyName
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "StatementTotalVCSegue"?:
            let vc = segue.destination as? PromoterStatementTotalViewController
            vc?.event = event
        case "BottlesVCSegue"?:
            let vc = segue.destination as? PromoterBottlesViewController
            vc?.bottles = event?.bottles ?? []
        case "TablesVCSegue"?:
            let vc = segue.destination as? PromoterTablesViewController
            vc?.tables = event?.tables ?? []
        default:
            break;
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        switch indexPath.row {
        case 1:
            if(event?.bottles?.count ?? 0 > 0){
            performSegue(withIdentifier: "BottlesVCSegue", sender: nil);
            }
            
        case 2:
            if(event?.tables?.count ?? 0 > 0){
            performSegue(withIdentifier: "TablesVCSegue", sender: nil);
            }
        case 3:
            performSegue(withIdentifier: "StatementTotalVCSegue", sender: nil);
        default:
            break;
        }
    }
    
    
    //    // MARK: - Table view data source
    //
    //    override func numberOfSections(in tableView: UITableView) -> Int {
    //        // #warning Incomplete implementation, return the number of sections
    //        return 0
    //    }
    //
    //    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    //        // #warning Incomplete implementation, return the number of rows
    //        return 0
    //    }
    
    /*
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
     
     // Configure the cell...
     
     return cell
     }
     */
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

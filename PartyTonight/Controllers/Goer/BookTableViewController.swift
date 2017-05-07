//
//  BookTableViewController.swift
//  PartyTonight
//
//  Created by Igor Kasyanenko on 04.05.17.
//  Copyright © 2017 Igor Kasyanenko. All rights reserved.
//

import UIKit

class BookTableViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var selectableTables = [[(table: Table, isSelected: Bool)]]()
    var vm: BookTableViewModel?
    var tables: [Table] = []
    var eventId:Int? = 0
    var ticket:Ticket?
    
    @IBAction func addToCartButtonTouched(_ sender: UIButton) {
        do {
            let selected = vm?.selectedTables(tables: selectableTables) ?? []
            if let firstTable = selected.first {
                firstTable.booked = "1"
                
                SharedCart.shared[eventId].ticket = ticket
                SharedCart.shared[eventId].clearTables()
                try SharedCart.shared[eventId].add(tables:  [firstTable])
                
                navigationController?.popViewController(animated: true)
            }else{
                print("Table was not chosen")
            }
        } catch CartError.AboveLimit {
            
        }
        catch {
            
            print("addToCart table error \(error)")
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        
        vm = BookTableViewModel(tables: tables)
        selectableTables = vm?.sortedTables ?? []
        //        tables.append([])
        //        tables.append([])
        //        tables[0].append(Table())
        //        tables[1].append(Table())
        //        tables[1].append(Table())
        
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

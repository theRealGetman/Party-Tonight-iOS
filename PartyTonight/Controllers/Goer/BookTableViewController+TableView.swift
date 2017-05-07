//
//  BookTableViewController+TableView.swift
//  PartyTonight
//
//  Created by Igor Kasyanenko on 05.05.17.
//  Copyright © 2017 Igor Kasyanenko. All rights reserved.
//

import Foundation
import UIKit
extension BookTableViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     
        
        let wasSelected = selectableTables[indexPath.section][indexPath.row].isSelected
       
        for section in 0..<selectableTables.count{
            for row in 0..<selectableTables[section].count{
                selectableTables[section][row].isSelected = false
                (tableView.cellForRow(at: IndexPath(row: row, section: section)) as? BookTableTableViewCell)?.isChosenButton.isHidden = true
            }
        }
    
    
    
        selectableTables[indexPath.section][indexPath.row].isSelected = !wasSelected

        let cell = tableView.cellForRow(at: indexPath) as! BookTableTableViewCell
        cell.isChosenButton.isHidden = !selectableTables[indexPath.section][indexPath.row].isSelected
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return selectableTables.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return selectableTables[section].count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BookTableCell", for: indexPath) as! BookTableTableViewCell
        let currentTable = selectableTables[indexPath.section][indexPath.row]
        cell.isChosenButton.isHidden = !currentTable.isSelected
        cell.titleLabel.text = "Table #\(indexPath.row + 1) (\(currentTable.table.type ?? "") - $\(currentTable.table.price ?? ""))"
        
        return cell
    }
    
    
}

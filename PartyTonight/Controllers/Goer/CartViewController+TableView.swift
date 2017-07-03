//
//  CartViewController+TableView.swift
//  PartyTonight
//
//  Created by Igor Kasyanenko on 05.05.17.
//  Copyright © 2017 Igor Kasyanenko. All rights reserved.
//

import Foundation
import UIKit

extension CartViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return carts.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let rowsCount = carts[section].ticket == nil ? carts[section].bookedTables.count + carts[section].bookedBottles.count : carts[section].bookedTables.count + carts[section].bookedBottles.count + 1
        return rowsCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CartCell", for: indexPath) as! CartTableViewCell
        if (indexPath.row < carts[indexPath.section].bookedTables.count){
            cell.titleLabel.text = "Table (\(carts[indexPath.section].bookedTables[indexPath.row].type ))"
            print("#table c \(carts[indexPath.section].bookedTables.count)")
            let priceForBookedItems = (Double(carts[indexPath.section].bookedTables[indexPath.row].price) ?? 0) * (Double(carts[indexPath.section].bookedTables[indexPath.row].booked) ?? 0 )
            
            cell.priceLabel.text = "$\(priceForBookedItems)"
            
        }else if (indexPath.row >= carts[indexPath.section].bookedTables.count && indexPath.row < carts[indexPath.section].bookedTables.count + carts[indexPath.section].bookedBottles.count){
            let bottleRow = indexPath.row - carts[indexPath.section].bookedTables.count
            cell.titleLabel.text = "Bottle \(carts[indexPath.section].bookedBottles[bottleRow].type ) x\(carts[indexPath.section].bookedBottles[bottleRow].booked )"
            let priceForBookedItems = (Double(carts[indexPath.section].bookedBottles[bottleRow].price) ?? 0) * (Double(carts[indexPath.section].bookedBottles[bottleRow].booked) ?? 0)
            cell.priceLabel.text = "$\(priceForBookedItems)"
            
            
        }else{
            if let price = carts[indexPath.section].ticket?.price, let booked = carts[indexPath.section].ticket?.booked {
                cell.titleLabel.text = "Ticket \(carts[indexPath.section].ticket?.type ?? "") x\(booked )"
                let priceForBookedItems = (Double(price) ?? 0) * (Double(booked) ?? 0)
                cell.priceLabel.text = "$\(priceForBookedItems)"
            }
        }
        
        return cell
    }
}

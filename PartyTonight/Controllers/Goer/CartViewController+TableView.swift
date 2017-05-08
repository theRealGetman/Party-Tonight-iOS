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
        
        return carts[section].bookedTables.count + carts[section].bookedBottles.count
//        switch section {
//        case 0:
//            return cart?.bookedTables.count ?? 0
//        case 1:
//            return cart?.bookedBottles.count ?? 0
//        default:
//            return 0
//        }
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CartCell", for: indexPath) as! CartTableViewCell
        if (indexPath.row < carts[indexPath.section].bookedTables.count){
            cell.titleLabel.text = "Table (\(carts[indexPath.section].bookedTables[indexPath.row].type ))"
            
            let priceForBookedItems = (Double(carts[indexPath.section].bookedTables[indexPath.row].price) ?? 0) * (Double(carts[indexPath.section].bookedTables[indexPath.row].booked) ?? 0 )
            
            cell.priceLabel.text = "$\(priceForBookedItems)"

        }else{
            let bottleRow = indexPath.row - carts[indexPath.section].bookedTables.count
            cell.titleLabel.text = "Bottle \(carts[indexPath.section].bookedBottles[bottleRow].type ) x\(carts[indexPath.section].bookedBottles[bottleRow].booked )"
            let priceForBookedItems = (Double(carts[indexPath.section].bookedBottles[bottleRow].price) ?? 0) * (Double(carts[indexPath.section].bookedBottles[bottleRow].booked) ?? 0)
            cell.priceLabel.text = "$\(priceForBookedItems)"
            
            print("bottle price \(carts[indexPath.section].bookedBottles[bottleRow].price) booked \(carts[indexPath.section].bookedBottles[bottleRow].booked) priceForBookedItems \(priceForBookedItems)")
        }
        
//        switch indexPath.section {
//        case 0:
//            cell.titleLabel.text = "Table (\(cart?.bookedTables[indexPath.row].type ?? "-"))"
//            cell.priceLabel.text = "$\(cart?.bookedTables[indexPath.row].price ?? "0")"
//        case 1:
//            
//            cell.titleLabel.text = "Bottle \(cart?.bookedBottles[indexPath.row].type ?? "-") x\(cart?.bookedBottles[indexPath.row].booked ?? 0)"
//            cell.priceLabel.text = "$\(cart?.bookedBottles[indexPath.row].price ?? "0")"
//        default:
//           break
//        }
        
        return cell
}
}

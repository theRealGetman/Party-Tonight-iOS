//
//  BookTableViewModel.swift
//  PartyTonight
//
//  Created by Igor Kasyanenko on 05.05.17.
//  Copyright © 2017 Igor Kasyanenko. All rights reserved.
//

import Foundation
class BookTableViewModel {
    var tables:[Table] = []
    var sortedTables: [[(table: Table, isSelected: Bool)]] {
        get {
           return sort(toSections: tables).map({ (tables) -> [(table: Table, isSelected: Bool)] in
                return tables.map({ (table) -> (table: Table, isSelected: Bool) in
                    return (table: table, isSelected: false)
                })
            })
        }
    }
    
    func selectedTables(tables:[[(table: Table, isSelected: Bool)]]) -> [Table]{
         return tables.map{ (tables) -> [Table] in
            return tables.flatMap({ (tableTuple) -> Table? in
                return tableTuple.isSelected ? tableTuple.table : nil
            })
            }.flatMap { $0 }
    
    }

    
    init(tables:[Table]) {
        self.tables = tables
    }
    
//    private func sort(toSections array: [Table]) -> [String : [Table]] {
//        let sortedArray = array.group  { $0.type ?? "" }
//        return sortedArray
//        
//    }
    
    private func sort(toSections arr: [Table]) -> [[Table]] {
//        var array = arr
//        var sortedArray = [[Table]]()
//        
//        for i in 0..<array.count {
//            let curVal = array[i]
//            sortedArray.append([curVal])
//            for j in i+1..<array.count {
//                if(curVal.type == array[j].type){
//                   sortedArray[i].append(array.remove(at: j))
//                }
//            }
//            array.remove(at: i)
//        }
//        
//        
//        return sortedArray
        var sortedArray = [[Table]]()
        
        for val in arr {
            
            let available = (Int(val.available ?? "0") ?? 0) - (Int(val.booked ?? "0") ?? 0)
            if (available <= 0){
                continue
            }
            sortedArray.append([])
            for _ in 0..<available {
                sortedArray[sortedArray.count - 1].append(val)
            }

        }
        
        return sortedArray
        
    }
    
    
}

public extension Sequence {
    func group<U: Hashable>(by key: (Iterator.Element) -> U) -> [U:[Iterator.Element]] {
        var categories: [U: [Iterator.Element]] = [:]
        for element in self {
            
            let key = key(element)
            if case nil = categories[key]?.append(element) {
                categories[key] = [element]
            }
        }
        return categories
    }
}

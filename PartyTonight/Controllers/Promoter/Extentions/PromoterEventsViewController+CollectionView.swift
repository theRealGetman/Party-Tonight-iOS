//
//  PromoterEventsViewController+CollectionView.swift
//  PartyTonight
//
//  Created by Igor Kasyanenko on 11.11.16.
//  Copyright © 2016 Igor Kasyanenko. All rights reserved.
//

import Foundation
import UIKit
extension PromoterEventsViewController:UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("nothing");
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellName, for: indexPath) as! EventCollectionViewCell;
        return cell;
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10;
    }


}

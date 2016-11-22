//
//  PromoterEventsViewController.swift
//  PartyTonight
//
//  Created by Igor Kasyanenko on 09.11.16.
//  Copyright © 2016 Igor Kasyanenko. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
class PromoterEventsViewController: UIViewController{
    @IBOutlet weak var eventsCollectionView: UICollectionView!
    let disposeBag = DisposeBag();
    
    let cellName = "EventCollectionViewCell";
    override func viewDidLoad() {
        super.viewDidLoad()
    
        eventsCollectionView.register(UINib(nibName: cellName, bundle: nil), forCellWithReuseIdentifier: cellName)

        let viewModel = PromoterEventsViewModel(API: APIManager.sharedAPI);        
        viewModel.events.map({ (it) -> [Event] in
                switch it {
                case .Success(let events):
                    print("events")
                    print(events)
                    return events;
                    
                case .Failure(let error):
                    print("#error")
                    print(error)
                    return [];
                }
        }).bindTo(eventsCollectionView.rx.items(cellIdentifier: cellName, cellType: EventCollectionViewCell.self)) { (row, element, cell) in
           // cell.textLabel?.text = "\(element) @ row \(row)"
           print("cell show")
            }
            .addDisposableTo(disposeBag)
        
        
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

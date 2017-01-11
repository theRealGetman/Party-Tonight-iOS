//
//  FindVenueViewController.swift
//  PartyTonight
//
//  Created by Igor Kasyanenko on 02.12.16.
//  Copyright © 2016 Igor Kasyanenko. All rights reserved.
//

import UIKit
import RxSwift
class FindVenueViewController: UIViewController {
    @IBOutlet weak var eventsCollectionView: UICollectionView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var findButton: UIButton!
    
    let df = DateFormatter();
    let cellName = "EventCollectionViewCell";
    let disposeBag = DisposeBag();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTextFieldInsets()
        
        df.dateFormat = "h:mm a dd.MM.yyyy"
        
        eventsCollectionView.register(UINib(nibName: cellName, bundle: nil), forCellWithReuseIdentifier: cellName)
        
        let viewModel = FindVenueViewModel(input: (
            zip: searchTextField.rx.text.orEmpty.asObservable(),
            findTouched: findButton.rx.tap.asObservable()
            ),API: APIManager.sharedAPI);
        
        viewModel.events.map({ (it) -> [Event] in
            switch it {
            case .Success(let events):
                
                self.emptyView(isSet: events.count > 0 ? false : true, collectionView: self.eventsCollectionView)
                return events;
                
            case .Failure(let error):
                print("#error")
                print(error)
                self.emptyView(isSet: true, collectionView: self.eventsCollectionView)
                return [];
            }
        }).bindTo(eventsCollectionView.rx.items(cellIdentifier: cellName, cellType: EventCollectionViewCell.self)) { (row, element, cell) in
            
            cell.event = element;
            cell.eventTitleLabel.text = element.partyName;
            if let date = element.date{
                cell.dateLabel.text = self.df.string(from: date);
            }
            cell.eventDescriptionLabel.text = "";
            }
            .addDisposableTo(disposeBag)
        
        eventsCollectionView.rx.itemSelected.subscribe(onNext: { index in
            self.performSegue(withIdentifier: "EventDetailsVCSegue", sender: self.eventsCollectionView.cellForItem(at: index))
        }).addDisposableTo(disposeBag)
        
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setTextFieldInsets(){
        searchTextField.leftView = UIView(frame:CGRect(x: 0, y: 0, width: 60, height: 30))
        searchTextField.leftViewMode = UITextFieldViewMode.always
        searchTextField.attributedPlaceholder = NSAttributedString(string:"Zip code",
                                                                  attributes:[NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: UIFont(name: "Aguda-Regular2", size: 18.0)! ])
    }

    func emptyView(isSet:Bool,collectionView:UICollectionView)  {
        if (!isSet) {
            collectionView.backgroundView = nil
        } else {
            
            let noDataLabel: UILabel = UILabel(frame: CGRect(x:0, y:0, width: collectionView.bounds.size.width, height: collectionView.bounds.size.height))
            noDataLabel.attributedText = NSAttributedString(string:"No data available", attributes:[NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: UIFont(name: "Aguda-Regular2", size: 18.0)! ])
            noDataLabel.textAlignment = NSTextAlignment.center
            collectionView.backgroundView = noDataLabel
        }
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

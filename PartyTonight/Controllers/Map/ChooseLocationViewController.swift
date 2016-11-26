//
//  ChooseLocationViewController.swift
//  PartyTonight
//
//  Created by Igor Kasyanenko on 15.11.16.
//  Copyright © 2016 Igor Kasyanenko. All rights reserved.
//

import UIKit
import MapKit

protocol DataEnteredDelegate: class {
    func userDidChooseLocation(info: String,zipVal:String?)
    func userDidChooseDateTime(date: Date)
}

class ChooseLocationViewController: UIViewController {
    @IBOutlet weak var mapView: MKMapView!
    let annotation = MKPointAnnotation()
    weak var delegate: DataEnteredDelegate? = nil
    var address:(address:String,zip: String?)?
    
    @IBAction func doneButtonTouched(_ sender: UIBarButtonItem) {
        // call this method on whichever class implements our delegate protocol
        if let location = address{
            delegate?.userDidChooseLocation(info: location.address, zipVal: location.zip);
            _ = self.navigationController?.popViewController(animated: true)
        }
        // go back to the previous view controller
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let longPressRecogniser = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongPress(getstureRecognizer:)))
        
        mapView.addAnnotation(annotation)
        longPressRecogniser.minimumPressDuration = 1.0
        mapView.addGestureRecognizer(longPressRecogniser)
        // Do any additional setup after loading the view.
    }

    
    func handleLongPress(getstureRecognizer : UIGestureRecognizer){
        if getstureRecognizer.state != .began { return }
        
        address = nil
        let touchPoint = getstureRecognizer.location(in: self.mapView)
        let touchMapCoordinate = mapView.convert(touchPoint, toCoordinateFrom: mapView)
        
        
        annotation.coordinate = touchMapCoordinate
        
        // Add below code to get address for touch coordinates.
        
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: touchMapCoordinate.latitude, longitude: touchMapCoordinate.longitude)
        
        geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
            
            // Place details
            let placeMark: CLPlacemark! = placemarks?[0]
//            
//            // Address dictionary
//            print(placeMark.addressDictionary)
//            
//            // Location name
//            if let locationName = placeMark.addressDictionary!["Name"] as? NSString {
//                print(locationName)
//            }
//            
//            // Street address
//            if let street = placeMark.addressDictionary!["Thoroughfare"] as? NSString {
//                print(street)
//            }
//            
//            // City
//            if let city = placeMark.addressDictionary!["City"] as? NSString {
//                print(city)
//            }
//            
//            // Zip code
//            if let zip = placeMark.addressDictionary!["ZIP"] as? NSString {
//                print(zip)
//            }
//
//            // Country
//            if let country = placeMark.addressDictionary!["Country"] as? NSString {
//                print(country)
//            }
//            
            // FormattedAddressLines
            if let formattedAddressLines = placeMark.addressDictionary?["FormattedAddressLines"] as? [String] {
                // Zip code
                 let zip:String? = placeMark.addressDictionary?["ZIP"] as? String
                self.address = (address: formattedAddressLines.joined(separator: ", "),zip: zip)
                //self.address?.address = formattedAddressLines.joined(separator: ", ")
            }
            
            
        })
    
        
       
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

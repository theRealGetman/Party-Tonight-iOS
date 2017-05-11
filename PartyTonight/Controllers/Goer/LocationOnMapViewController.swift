//
//  LocationOnMapViewController.swift
//  PartyTonight
//
//  Created by Igor Kasyanenko on 09.05.17.
//  Copyright © 2017 Igor Kasyanenko. All rights reserved.
//

import UIKit
import MapKit
class LocationOnMapViewController: UIViewController, MKMapViewDelegate {
    @IBOutlet weak var mapView: MKMapView!
    var event:Event?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mapView.delegate = self;
        
        if let stringLocation = event?.location{
            setMarker(fromStringLocation: stringLocation)
        }else {
            DefaultWireframe.presentAlert("Location not found on map", completion: { (action) in
                self.navigationController?.popViewController(animated: true)
            })
        }
        //event?.location =
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func setMarker(fromStringLocation stringLocation:String){
        print("string location for event \(stringLocation)")
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(stringLocation) { [weak self] placemarks, error in
            if let placemark = placemarks?.first, let location = placemark.location {
                let mark = MKPlacemark(placemark: placemark)
                
                if var region = self?.mapView.region {
                    region.center = location.coordinate
                    region.span.longitudeDelta /= 25.0
                    region.span.latitudeDelta /= 25.0
                    self?.mapView.setRegion(region, animated: true)
                    self?.mapView.addAnnotation(mark)
                }
            } else {
                DefaultWireframe.presentAlert("Location not found on map", completion: { (action) in
                    self?.navigationController?.popViewController(animated: true)
                })
            }
        }
        
        
        //        let region:MKCoordinateRegion  = MKCoordinateRegionMakeWithDistance(location.coordinate, 800, 800);
        //        self.mapView.setRegion(self.mapView.regionThatFits(region), animated:true);
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

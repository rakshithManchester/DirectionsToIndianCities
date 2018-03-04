//
//  CityDetailsViewController.swift
//  DirectionsToIndianCities
//
//  Created by rakshith appaiah on 3/4/18.
//  Copyright © 2018 rakshith appaiah. All rights reserved.
//

import UIKit
import GoogleMaps

class CityDetailsViewController: UIViewController {
    
    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var cityDescription: UILabel!
    @IBOutlet weak var viewForMap: UIView!
    
    var cityDetails: Place?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.showInMap()
        cityName.text = cityDetails?.name
        cityDescription.text = cityDetails?.cityDescription
    }
    
    func showInMap() {
        let cgRect = CGRect(x: self.view.bounds.origin.x, y: self.view.bounds.origin.y, width: self.view.frame.width, height: self.view.bounds.height/2.5)
        if let latitude = cityDetails?.latitude ,let longitude = cityDetails?.longitude,let city = cityDetails?.name {
            let gmsCameraPosition = GMSCameraPosition.camera(withLatitude: latitude, longitude:longitude, zoom: 12) /// Note :Destination Lat,Lon in CameraPosition.
            let mapView = GMSMapView.map(withFrame: cgRect, camera: gmsCameraPosition) /// Note : Custom 'viewForMap' position and CameraPosition is passed to MapView.
            self.viewForMap.addSubview(mapView)
            
            let cityLocation = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            let marker = GMSMarker(position: cityLocation) /// Note : Marker on current City Lat,Lon
            marker.title = "\(city) is here"
            marker.map = mapView
        }
        
    }
    @IBAction func getDirections(_ sender: Any) {
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let directions = segue.destination as? DirectionsViewController {
            directions.cityDetails = self.cityDetails
        }
    }
}

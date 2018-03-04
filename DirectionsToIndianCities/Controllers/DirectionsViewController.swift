//
//  DirectionsViewController.swift
//  DirectionsToIndianCities
//
//  Created by rakshith appaiah on 3/4/18.
//  Copyright © 2018 rakshith appaiah. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import GoogleMaps

class DirectionsViewController: UIViewController,CLLocationManagerDelegate {
    
    var cityDetails: Place?
    let manager = CLLocationManager()  /// Location Manager instantiated.
    
    var mapView : GMSMapView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        
        let cgRect = CGRect(x: self.view.bounds.origin.x, y: self.view.bounds.origin.y, width: self.view.frame.width, height: self.view.bounds.height)
        if let latitude = cityDetails?.latitude ,let longitude = cityDetails?.longitude {
            let gmsCameraPosition = GMSCameraPosition.camera(withLatitude: latitude, longitude:longitude, zoom: 7)
            self.mapView = GMSMapView.map(withFrame: cgRect, camera: gmsCameraPosition)
            if let mapView = self.mapView {
                self.view.addSubview(mapView)
            }
            let currentLocation = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            let marker = GMSMarker(position: currentLocation)
            marker.map = self.mapView
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        if let destinationLatitude = cityDetails?.latitude, let destinationLongitude = cityDetails?.longitude {
            directions(curLatitude: location.coordinate.latitude, curLongitude: location.coordinate.longitude, destiLatitude: destinationLatitude, destiLongitude: destinationLongitude)
        }
    }
    
    func directions(curLatitude:Double,curLongitude:Double,destiLatitude:Double,destiLongitude:Double) {
        //        let directionURL = "https://maps.googleapis.com/maps/api/directions/json?"+"origin=\(curLatitude),\(curLongitude)&destination=\(destiLatitude),\(destiLongitude)&"+"key=AIzaSyAtya6hOAZnvsQMB5k99dp04V6Pfxs48MM"
        //                Alamofire.request(directionURL).responseJSON
        //                    { response in
        //                        if let JSON = response.result.value {
        //                            let mapResponse: [String: AnyObject] = JSON as! [String : AnyObject]
        //                            let routesArray = (mapResponse["routes"] as? Array) ?? []
        //                            let routes = (routesArray.first as? Dictionary<String, AnyObject>) ?? [:]
        //                            let overviewPolyline = (routes["overview_polyline"] as? Dictionary<String,AnyObject>) ?? [:]
        //                            let polypoints = (overviewPolyline["points"] as? String) ?? ""
        //                            let line  = polypoints
        //                                }
        //    }
        
        // TODO : This IP, site or mobile application is not authorized to use this API key with IP authorized
        
        let path = GMSMutablePath()
        path.addLatitude(curLatitude, longitude:curLongitude)
        path.addLatitude(destiLatitude, longitude:destiLongitude)
        
        let polyline = GMSPolyline(path: path)
        polyline.strokeColor = .blue
        polyline.strokeWidth = 5.0
        polyline.map = self.mapView
    }
}

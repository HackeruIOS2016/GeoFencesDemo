//
//  ViewController.swift
//  MapGeoFences
//
//  Created by HackerU on 19/05/2016.
//  Copyright © 2016 HackerU. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initLocationManager()
    }
    
    func initLocationManager(){
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        mapView.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 10.0
        locationManager.startUpdatingLocation()
        mapView.showsUserLocation = true
        
        
        addGeoFenceForHackeru()
    }
    
    func addGeoFenceForHackeru(){
        //32.0843985,34.800728
        
        let coordinate = CLLocationCoordinate2D(latitude: 32.0843985, longitude: 34.800728)
        let region = CLCircularRegion(center: coordinate, radius: 50, identifier: "HackerU")
        
        region.notifyOnEntry = true
        region.notifyOnExit = true
        
        locationManager.startMonitoringForRegion(region)
    }
}

extension ViewController : CLLocationManagerDelegate{
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        print(status)
        
        
    }
    
    func locationManager(manager: CLLocationManager, didEnterRegion region: CLRegion) {
        print("Entered Region")
    }
    
    func locationManager(manager: CLLocationManager, didExitRegion region: CLRegion) {
        print("Exit Region")
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(locations)
        changeMapLocation(locations[0])
    }
    
    func changeMapLocation(location:CLLocation){
        //get the coordinate from the location:
        let coordinate = location.coordinate
        
        let region = MKCoordinateRegionMakeWithDistance(coordinate, 100, 100)
        
        mapView.setRegion(region, animated: true)
    }
}


extension ViewController : MKMapViewDelegate{
    
}
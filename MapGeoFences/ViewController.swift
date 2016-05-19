//
//  ViewController.swift
//  MapGeoFences
//
//  Created by HackerU on 19/05/2016.
//  Copyright © 2016 HackerU. All rights reserved.
//

import UIKit
import MapKit

//let delegate = UIApplication.sharedApplication().delegate as! AppDelegate

class ViewController: UIViewController {
    @IBOutlet weak var inOutLabel: UILabel!{
        didSet{
            inOutLabel.text = ""
        }
    }
    
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
        //locationManager.distanceFilter = 10.0
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
        
        
        let circleOverlay = MKCircle(centerCoordinate: coordinate, radius: 50)
        circleOverlay.title = "Hackeru"
        mapView.addOverlay(circleOverlay)
    }
}

extension ViewController : CLLocationManagerDelegate{
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
       // print(status)
        
        
    }
    
    func locationManager(manager: CLLocationManager, didEnterRegion region: CLRegion) {
        print("Entered Region")
        inOutLabel.text = "In"
    }
    
    func locationManager(manager: CLLocationManager, didExitRegion region: CLRegion) {
        print("Exit Region")
        inOutLabel.text = "Out"
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //print(locations)
        changeMapLocation(locations[0])
    }
    
    func changeMapLocation(location:CLLocation){
        //get the coordinate from the location:
        let coordinate = location.coordinate
        
        let region = MKCoordinateRegionMakeWithDistance(coordinate, 500, 500)
        
        mapView.setRegion(region, animated: true)
        
       
    }
}


extension ViewController : MKMapViewDelegate{
    //Renderer: How to draw - define the paint
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay.title! == "Hackeru"{
            let circleOverlay = MKCircleRenderer(overlay: overlay)
            circleOverlay.strokeColor = UIColor.redColor().colorWithAlphaComponent(0.5)
            circleOverlay.lineWidth = 0.5
            circleOverlay.fillColor = UIColor.purpleColor().colorWithAlphaComponent(0.4)
            return circleOverlay
        }
        //default:
        let poly =  MKPolylineRenderer(overlay: overlay)
        poly.lineWidth = 5
        poly.strokeColor = UIColor.blackColor()
        return poly
    }
}
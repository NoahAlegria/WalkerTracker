//
//  SecondViewController.swift
//  walkerTracker
//
//  Created by user144566 on 10/12/18.
//  Copyright © 2018 user144566. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Contacts
import Material

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    var homeAddress : String?
    var coords: CLLocationCoordinate2D?
    var locationManager = CLLocationManager()
    var currentPlacemark: CLPlacemark?
    var sourcePlacemark: CLPlacemark?
    var destinationPlacemark: CLPlacemark?
    var passedJson : NSArray?
    var passedIndex : Int?
    
    var currentTransportType = MKDirectionsTransportType.automobile
    var currentRoute: MKRoute?
    
    @IBOutlet weak var showResults: UIButton!
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var control: UISegmentedControl!
    override func viewDidLoad() {
        super.viewDidLoad()
        map.delegate = self
        showResults.isHidden = true
        showResults.setTitleColor(.white, for: .normal)
        showResults.backgroundColor = Color.blue.base
        view.backgroundColor = Color.grey.lighten2
        prepareButtons()
        //navigationController?.navigationBar.barTintColor = Color.grey.lighten3
    }
    @objc func getLocation(button: UIButton) {
        
        switch(control.selectedSegmentIndex) {
        case 0:
            if homeAddress != nil {
                addressToLoc(addressString: homeAddress!)
            }
        case 1:
            startStandardUpdates()
            sleep(2)
        default:
            print("Uhh")
        }
    }
    
    @IBAction func searchButton(_ sender: Any) {
        let alert = UIAlertController(title: "Address To Search", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = "Enter New Zip"
        })
        alert.addAction(UIAlertAction(title: "Search", style: .default, handler: { action in
            let search = (alert.textFields?.first?.text)!
            if !(search.isEmpty) {
                self.addressToLoc(addressString: search)
            }
        }))
        self.present(alert, animated: true)
    }
    
    @objc func locate(button: UIButton) {
        DispatchQueue.main.async {
            self.getAPI()
        }
    }
    
    func getAPI() {
        if coords != nil {
            var long = String(self.coords!.longitude)
            var lat = String(self.coords!.latitude)
            let Url = String(format: "https://services-qa.walgreens.com/api/stores/search")
            guard let serviceUrl = URL(string: Url) else { return }
            let paramDict = ["apiKey" : "679949ShpcekJrWIhbW4sAFDzGQABwUe", "affId" : "storesapi", "lat" : lat, "lng" : long, "requestType" : "locator", "act" : "fndStore", "view" : "fndStoreJSON"]
            var request = URLRequest(url: serviceUrl)
            request.httpMethod = "POST"
            request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
            guard let httpBody = try? JSONSerialization.data(withJSONObject: paramDict, options: []) else {
                return
            }
            request.httpBody = httpBody
            
            let session = URLSession.shared
            session.dataTask(with: request) { (data, response, error) in
                if let response = response {
                    print(response)
                }
                if let data = data {
                    if data.count != 0 {
                    var err : NSError?
                    let jsonResult = (try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) as! NSDictionary
                    print(jsonResult)
                    if (err != nil) {
                        print("JSON Error \(err!.localizedDescription)")
                    }
                    let stores = jsonResult["stores"] as! NSArray
                    self.passedJson = stores
                    DispatchQueue.main.async {
                        for i in 0..<stores.count {
                            let store = stores[i] as! NSDictionary
                            let long = store["stlng"]! as! String
                            let lat = store["stlat"]! as! String
                            let addrs = store["stadd"] as! String
                            let ani = MKPointAnnotation()
                            ani.coordinate.longitude = (NumberFormatter().number(from: long)?.doubleValue)!
                            ani.coordinate.latitude = (NumberFormatter().number(from: lat)?.doubleValue)!
                            ani.title = "Walgreens"
                            ani.subtitle = addrs
                            self.map.addAnnotation(ani)
                        }
                    }
                    }
                }
                }.resume()
            let span = MKCoordinateSpan(latitudeDelta: 0.4, longitudeDelta: 0.4)
            let region = MKCoordinateRegion(center: self.coords!, span: span)
            self.map.setRegion(region, animated: true)
            sleep(1)
            self.showResults.isHidden = false
        }
        else {
            let innerAlert = UIAlertController(title: "No Location Set", message: nil, preferredStyle: .alert)
            innerAlert.addAction(UIAlertAction(title: "OK", style: .default, handler:nil))
            self.present(innerAlert, animated: true, completion: nil)
            print("No Location Set")
        }
    }
    
    func addressToLoc(addressString: String) {
        print(addressString)
        //map.removeAnnotations(map.annotations)
        _ = CLGeocoder();
        CLGeocoder().geocodeAddressString(addressString, completionHandler:
            {(placemarks, error) in
                
                if error != nil {
                    print("Geocode failed: \(error!.localizedDescription)")
                } else if placemarks!.count > 0 {
                    let placemark = placemarks![0]
                    self.destinationPlacemark = placemark
                    let location = placemark.location
                    self.coords = location!.coordinate
                    print(location as Any)
                    
                    let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
                    let region = MKCoordinateRegion(center: placemark.location!.coordinate, span: span)
                    self.map.setRegion(region, animated: true)
                    let ani = MKPointAnnotation()
                    ani.coordinate = placemark.location!.coordinate
                    ani.title = placemark.locality
                    ani.subtitle = placemark.subLocality
                    
                    self.map.addAnnotation(ani)
                    
                }
        })
    }
    
    func startStandardUpdates() {
        if (CLLocationManager.locationServicesEnabled())
        {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            //locationManager.distanceFilter = 5
            if ((UIDevice.current.systemVersion as NSString).floatValue >= 8)
            {
                locationManager.requestWhenInUseAuthorization()
            }
            print("Starting Location")
            locationManager.startUpdatingLocation()
            locationManager.requestLocation()
        }
        else
        {
            #if debug
            println("Location services are not enabled");
            #endif
        }
        
    }
    
    func mapStuff(location: CLLocation) {
        map.removeAnnotations(map.annotations)
        print("Mapping Stuff")
        self.coords = location.coordinate
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        let region = MKCoordinateRegion(center: location.coordinate, span: span)
        self.map.setRegion(region, animated: true)
        let ani = MKPointAnnotation()
        ani.coordinate = location.coordinate
        ani.title = "You are Here"
        self.map.addAnnotation(ani)
    }
    
    func getDirections() {
        if destinationPlacemark != nil {
            // get the directions
            let directionRequest = MKDirections.Request()
            
            // Set the source and destination of the route
            
            directionRequest.source = MKMapItem.forCurrentLocation()
            
            let destinationPM = MKPlacemark(placemark: self.destinationPlacemark!)
            directionRequest.destination = MKMapItem(placemark: destinationPM)
            
            directionRequest.transportType = currentTransportType
            
            // Calculate the direction
            let directions = MKDirections(request: directionRequest)
            
            directions.calculate { (routeResponse, routeError) -> Void in
                
                guard let routeResponse = routeResponse else {
                    if let routeError = routeError {
                        print("Error: \(routeError)")
                    }
                    
                    return
                }
                
                let route = routeResponse.routes[0]
                print("Printing route")
                for step in route.steps {
                    print(step.instructions)
                }
                
                
                self.currentRoute = route
                self.map.removeOverlays(self.map.overlays)
                self.map.addOverlay(route.polyline, level: MKOverlayLevel.aboveRoads)
                
                let rect = route.polyline.boundingMapRect
                self.map.setRegion(MKCoordinateRegion(rect), animated: true)
            }
        }
        else {
            print("This is your own Location")
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {return nil}
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        if pinView == nil {
            print("Placing Pin")
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.animatesDrop = true
            let calloutButton = UIButton(type: .detailDisclosure)
            pinView!.rightCalloutAccessoryView = calloutButton
            pinView!.sizeToFit()
        }
        else {
            pinView!.annotation = annotation
        }
        
        
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView{
            print(view.annotation!.title) // your annotation's title
            DispatchQueue.main.async {
            self.getDirections()
            //self.performSegueWithIdentifier("yourSegue")
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
        print("Stopping Location")
        if ((error) != nil)
        {
            print(error as Any)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locationArray = locations as NSArray
        let locationObj = locationArray.lastObject as! CLLocation
        let coord = locationObj.coordinate
        print(coord.latitude)
        print(coord.longitude)
        let eventDate = locationObj.timestamp
        let howRecent = eventDate.timeIntervalSinceNow
        if (abs(howRecent) < 15.0) {
            print("Calling mapStuff")
            mapStuff(location: locationObj)
        }
        
    }

    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = (currentTransportType == .automobile) ? UIColor.blue : UIColor.orange
        renderer.lineWidth = 3.0
        
        return renderer
    }
    
    @IBAction func viewResults(_ sender: Any) {
        performSegue(withIdentifier: "toTable", sender: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if(segue.identifier == "toTable"){
            let destinationNavigationController = segue.destination as! UINavigationController
            let targetController = destinationNavigationController.topViewController as! TableViewController
            targetController.json = passedJson
            targetController.passedIndex = passedIndex
        }
    }
    
    @IBAction func unwindToMap(sender: UIStoryboardSegue) {
        print("Please work")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let nav = self.navigationController?.navigationBar
        nav?.barTintColor = Color.grey.lighten2
    }
}

extension MapViewController {
    
    
    fileprivate func prepareButtons() {
        let button = RaisedButton(title: "Get Location", titleColor: .white)
        button.pulseColor = .white
        button.backgroundColor = Color.blue.base
        button.addTarget(self, action: #selector(getLocation), for: .touchUpInside)
        
        view.layout(button)
            .width(175)
            .height(35)
            .top(140).left(10)
        
        let button2 = RaisedButton(title: "Find Nearby Stores", titleColor: .white)
        button2.pulseColor = .white
        button2.backgroundColor = Color.blue.base
        button2.addTarget(self, action: #selector(locate), for: .touchUpInside)
        
        view.layout(button2)
            .width(175)
            .height(35)
            .top(140).right(10)
        
    }
    
}



//
//  AddGeoViewController.swift
//  VKclient_Kirillov_Anton
//
//  Created by Антон Кириллов on 20.11.2017.
//  Copyright © 2017 Barpost. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class AddGeoController: UIViewController, CLLocationManagerDelegate {
    
    let locationManager = CLLocationManager()
    var coordForPost: (Double, Double)?
    //let nothing = "НЕТ ИНФЫ"
    var nameOfLocation = ""
    
    @IBOutlet weak var mapView: MKMapView!
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let currentLocation = locations.last?.coordinate {
            print(currentLocation)
            coordForPost = (currentLocation.latitude, currentLocation.longitude)
            
            let coordinate = CLLocation(latitude: currentLocation.latitude, longitude: currentLocation.longitude)
            let coder = CLGeocoder()
            coder.reverseGeocodeLocation(coordinate) {(myPlaces,Error) -> Void in
                if let place = myPlaces?.first {
                    self.nameOfLocation = place.name!
                    //print("вот name твоей геопозидции - \(place.name ?? self.nothing)")
                    //print("вот areas of interest твоей геопозидции - \(place.areasOfInterest ?? [self.nothing])")
                   }
            }
            let currentRadius: CLLocationDistance = 500
            let currentRegion = MKCoordinateRegionMakeWithDistance((currentLocation), currentRadius * 2.0, currentRadius * 2.0)
            self.mapView.setRegion(currentRegion, animated: true)
            self.mapView.showsUserLocation = true
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension AddGeoController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddGeoTableViewCell", for: indexPath)
        return cell
    }
}

extension AddGeoController: UITableViewDelegate {
}


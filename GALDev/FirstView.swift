//
//  FirstPage.swift
//  GetALiftDev
//
//  Created by Loan Aubergeon on 11/08/2017.
//  Copyright © 2017 Loan Aubergeon. All rights reserved.
//

import UIKit
import GoogleMaps


/// The first view of the app when you are authenticated
class FirstView: UIViewController, CLLocationManagerDelegate {


    // Variables

    var token = Home.GlobalsVariables.userToken

    @IBOutlet weak var menuButton: UIBarButtonItem!

    @IBOutlet var viewMap : GMSMapView?

    let locationManager = CLLocationManager()

    var didFindMyLocation = false

    var mapTasks = MapTasks()

    var locationMarker: GMSMarker!


    // ***********************************************************************************************************************


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }

        //print("Voici le token :")
        //print(token)


        let camera: GMSCameraPosition = GMSCameraPosition.camera(withLatitude: 48.857165, longitude: 2.354613, zoom: 8.0)
        viewMap?.camera = camera
        viewMap?.settings.myLocationButton = true

        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func changeMapType(sender: AnyObject) {

        // For change the map type with little menu

        let actionSheet = UIAlertController(title: "Map Types", message: "Select map type :", preferredStyle: UIAlertControllerStyle.actionSheet)

        let normalMapTypeAction = UIAlertAction(title: "Normal", style: UIAlertActionStyle.default) { (alertAction) -> Void in
            self.viewMap?.mapType = kGMSTypeNormal
        }

        let terrainMapTypeAction = UIAlertAction(title: "Terrain", style: UIAlertActionStyle.default) { (alertAction) -> Void in
            self.viewMap?.mapType = kGMSTypeTerrain
        }

        let hybridMapTypeAction = UIAlertAction(title: "Hybrid", style: UIAlertActionStyle.default) { (alertAction) -> Void in
            self.viewMap?.mapType = kGMSTypeHybrid
        }

        let cancelAction = UIAlertAction(title: "Close", style: UIAlertActionStyle.cancel) { (alertAction) -> Void in

        }

        actionSheet.addAction(normalMapTypeAction)
        actionSheet.addAction(terrainMapTypeAction)
        actionSheet.addAction(hybridMapTypeAction)
        actionSheet.addAction(cancelAction)

        present(actionSheet, animated: true, completion: nil)
    }



    // ***********************************************************************************************************************

    // Verify the location authorization
    @nonobjc func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.authorizedWhenInUse {
            locationManager.startUpdatingLocation()
            viewMap?.isMyLocationEnabled = true
            viewMap?.settings.myLocationButton = true
        }
    }

    // For indicate the current location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation = locations.last
        let camera = GMSCameraPosition.camera(withLatitude: userLocation!.coordinate.latitude,
                                              longitude: userLocation!.coordinate.longitude, zoom: 13.0)
        viewMap?.isMyLocationEnabled = true
        viewMap?.camera = camera

        locationManager.stopUpdatingLocation()
    }


    // Fonction pour affficher une fenetre d'alerte
    func showAlertWithMessage(message: String) {
        let alertController = UIAlertController(title: "GetALift", message: message, preferredStyle: UIAlertControllerStyle.alert)

        let closeAction = UIAlertAction(title: "Close", style: UIAlertActionStyle.cancel) { (alertAction) -> Void in

        }

        alertController.addAction(closeAction)

        present(alertController, animated: true, completion: nil)
    }

}

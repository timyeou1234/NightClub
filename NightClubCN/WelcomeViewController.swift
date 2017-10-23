//
//  WelcomeViewController.swift
//  NightClubCN
//
//  Created by YeouTimothy on 2017/8/30.
//  Copyright © 2017年 Wework. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class WelcomeViewController: UIViewController ,CLLocationManagerDelegate{
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }else{
            User.user.inCn = true
            self.performSegue(withIdentifier: "CNSegue", sender: nil)
            return
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0]
        let lon = userLocation.coordinate.longitude;
        let lat = userLocation.coordinate.latitude;
        
        print(lon, lat)
        
        Location.userLocation.currentLat = "\(lat)"
        Location.userLocation.currentLon = "\(lon)"
        
        if Double(Location.userLocation.currentLat!)! >= 39.459900 && Double(Location.userLocation.currentLat!)! <= 41.045502 && Double(Location.userLocation.currentLon!)! >= 115.445238 && Double(Location.userLocation.currentLon!)! <= 117.356015{
            User.user.inCn = true
            self.performSegue(withIdentifier: "CNSegue", sender: nil)
        }else{
            User.user.inCn = false
            self.performSegue(withIdentifier: "GlobalSegue", sender: nil)
        }
        //Do What ever you want with it
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

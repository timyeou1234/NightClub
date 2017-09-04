//
//  MainMapViewController.swift
//  NightClubCN
//
//  Created by YeouTimothy on 2017/7/27.
//  Copyright © 2017年 Wework. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import CoreLocation
import MapKit

class MainMapViewController: UIViewController ,CLLocationManagerDelegate{
    
    let locationManager = CLLocationManager()
    var pubType = 0

    @IBAction func nightClubAction(_ sender: Any) {
        getData(pubType: 1)
    }
    
    @IBAction func musicPubAction(_ sender: Any) {
        getData(pubType: 2)
    }
    
    @IBAction func loungeBarAction(_ sender: Any) {
        getData(pubType: 3)
    }
    
    @IBAction func sportBarAction(_ sender: Any) {
        getData(pubType: 4)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
            
        }else{
            self.locationManager.requestAlwaysAuthorization()
            
            // For use in foreground
            self.locationManager.requestWhenInUseAuthorization()
        }
        
        Location.userLocation.currentLat = "\(locationManager.location?.coordinate.latitude ?? 116.26281)"
        Location.userLocation.currentLon = "\(locationManager.location?.coordinate.longitude ?? 39.55463)"
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationController = segue.destination as? MapViewController{
            destinationController.pubtype = pubType
            destinationController.locationList = sender as? [Location]
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0]
        let lon = userLocation.coordinate.longitude;
        let lat = userLocation.coordinate.latitude;
        
        print(lon, lat)
        
        Location.userLocation.currentLat = "\(lat)"
        Location.userLocation.currentLon = "\(lon)"
        //Do What ever you want with it
    }
    
    func getData(pubType:Int){
        let parameters: Parameters = [
            "pubtype":pubType,
            "user_lat": Location.userLocation.currentLat ?? "",
            "user_lon": Location.userLocation.currentLon ?? "",
            ]
        
        WebConfig.Manager.request("\(WebConfig.webUrl)publist", method: .post, parameters: parameters, encoding: URLEncoding.default, headers: WebConfig.headers).response { response in
            if let data = response.data {
                let json: JSON = JSON(data: data)
                print(json)
                if let error = json["error"].bool{
                    if error{
                        return
                    }
                }
                
                if let data = json["data"].array{
                    var locationList = [Location]()
                    
                    for locationData in data{
                        let location = Location()
                        if let id = locationData["id"].string{
                            location.id = id
                        }
                        if let pub_type = locationData["pub_type"].string{
                            location.pub_type = pub_type
                        }
                        if let pub_name = locationData["pub_name"].string{
                            location.pub_name = pub_name
                        }
                        if let pub_addr = locationData["pub_addr"].string{
                            location.pub_addr = pub_addr
                        }
                        if let pub_desc = locationData["pub_desc"].string{
                            location.pub_desc = pub_desc
                        }
                        if let pub_news = locationData["pub_news"].string{
                            location.pub_news = pub_news
                        }
                        if let pub_tel = locationData["pub_tel"].string{
                            location.pub_tel = pub_tel
                        }
                        if let pub_name = locationData["pub_name"].string{
                            location.pub_name = pub_name
                        }
                        if let open_time = locationData["open_time"].string{
                            location.open_time = open_time
                        }
                        if let lon = locationData["lon"].string{
                            location.lon = lon
                        }
                        if let lat = locationData["lat"].string{
                            location.lat = lat
                        }
                        if let img = locationData["img"].string{
                            location.img = img
                        }
                        if let created_at = locationData["created_at"].string{
                            location.created_at = created_at
                        }
                        locationList.append(location)
                    }
                    self.pubType = pubType
                    self.performSegue(withIdentifier: "showDetail", sender: locationList)
                }
            }
        }
    }

}

class Location:NSObject{
    
    static let userLocation = Location()
    
    var currentLat:String?
    var currentLon:String?
    
    
    var id:String?
    var pub_type:String?
    var pub_name:String?
    var pub_addr:String?
    var pub_desc:String?
    var pub_news:String?
    var open_time:String?
    var pub_tel:String?
    var lon:String?
    var lat:String?
    var img:String?
    var created_at:String?
    
}



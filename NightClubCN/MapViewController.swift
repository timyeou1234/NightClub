//
//  MapViewController.swift
//  NightClubCN
//
//  Created by YeouTimothy on 2017/7/27.
//  Copyright © 2017年 Wework. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import SwiftyJSON
import Alamofire

class MapViewController: UIViewController , BMKMapViewDelegate, CLLocationManagerDelegate, BMKPoiSearchDelegate, BMKRouteSearchDelegate{
    
    var pubtype = 0
    var selectLoaction = Location()
    var searchPoint:CLLocationCoordinate2D?
    var searchList = [MapSearchResult]()
    let locationManager = CLLocationManager()
    var locationList:[Location]?
    var _poisearcher = BMKPoiSearch()
    var routeSearch: BMKRouteSearch!
    
    @IBOutlet weak var mapView: BMKMapView!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var addrTextField: UITextField!
    @IBOutlet weak var searchTableView: UITableView!
    @IBOutlet weak var detailView: UIView!
    @IBOutlet weak var titleLable: UILabel!
    @IBOutlet weak var addrLable: UILabel!
    @IBOutlet weak var phoneLable: UILabel!
    @IBOutlet weak var timeLable: UILabel!
    @IBOutlet weak var routeButton: UIButton!
    @IBOutlet weak var durationLable: UILabel!
    
    @IBAction func searchAction(_ sender: Any) {
        
        
        let from = BMKPlanNode()
        if let coor = searchPoint{
            from.pt = coor
        }else{
            from.pt = CLLocationCoordinate2D(latitude: Double(Location.userLocation.currentLat!)!, longitude: Double(Location.userLocation.currentLon!)!)
        }
        
        let to = BMKPlanNode()
        to.pt = CLLocationCoordinate2D(latitude: Double(selectLoaction.lat!)!, longitude: Double(selectLoaction.lon!)!)
        
        let drivingRouteSearchOption = BMKDrivingRoutePlanOption()
        drivingRouteSearchOption.from = from
        drivingRouteSearchOption.to = to
        drivingRouteSearchOption.drivingRequestTrafficType = BMK_DRIVING_REQUEST_TRAFFICE_TYPE_NONE//不获取路况信息
        
        let flag = routeSearch.drivingSearch(drivingRouteSearchOption)
        if flag {
            print("驾乘检索发送成功")
        }else {
            print("驾乘检索发送失败")
        }
    }
    
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        // Ask for Authorisation from the User.
        
        // For use in foreground
        routeSearch = BMKRouteSearch()
        self.locationManager.requestWhenInUseAuthorization()
        _poisearcher.delegate = self
        cityTextField.delegate = self
        addrTextField.delegate = self
        searchTableView.dataSource = self
        searchTableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        mapView?.viewWillAppear()
        routeSearch.delegate = self
        mapView?.delegate = self// 此处记得不用的时候需要置nil，否则影响内存的释放
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
            
        }else{
            
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //地图中心点坐标
        detailView.isHidden = true
        routeButton.isHidden = true
        durationLable.isHidden = true
        var center = CLLocationCoordinate2D(latitude: 39.907488, longitude: 116.393745)
        if Double(Location.userLocation.currentLat!)! >= 39.459900 && Double(Location.userLocation.currentLat!)! <= 41.045502 && Double(Location.userLocation.currentLon!)! >= 115.445238 && Double(Location.userLocation.currentLon!)! <= 117.356015{
            center = CLLocationCoordinate2D(latitude: Double(Location.userLocation.currentLat!)!, longitude: Double(Location.userLocation.currentLon!)!)
            
        }
        //设置地图的显示范围（越小越精确）
        let span = BMKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        //设置地图最终显示区域
        let region = BMKCoordinateRegion(center: center, span: span)
        mapView?.region = region
        
        
        if locationList != nil{
            for location in locationList!{
                // 添加一个标记点(PointAnnotation）
                let annotation =  BMKPointAnnotation()
                var coor = CLLocationCoordinate2D()
                coor.latitude = Double(location.lat!)!
                coor.longitude = Double(location.lon!)!
                annotation.coordinate = coor
                annotation.title = location.pub_name
                
                
                mapView!.addAnnotation(annotation)
                
            }
        }
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        mapView?.viewWillDisappear()
        mapView?.delegate = nil // 不用时，置nil
        routeSearch.delegate = nil
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func mapView(_ mapView: BMKMapView!, didSelect view: BMKAnnotationView!) {
        for location in locationList!{
            if location.pub_name == view.annotation.title!(){
                selectLoaction = location
                routeButton.isHidden = false
                detailView.isHidden = false
                titleLable.text = location.pub_name
                addrLable.text = location.pub_addr
                phoneLable.text = location.pub_tel
                timeLable.text = location.open_time
                print("select succes")
                return
            }
        }
        showAlert(title: "查無資料", Message: nil)
    }
    
    func onGetDrivingRouteResult(_ searcher: BMKRouteSearch!, result: BMKDrivingRouteResult!, errorCode error: BMKSearchErrorCode) {
        print("onGetDrivingRouteResult: \(error)")
        
        mapView.removeOverlays(mapView.overlays)
        
        if error == BMK_SEARCH_NO_ERROR {
            let plan = result.routes[0] as! BMKDrivingRouteLine
            
            durationLable.text = "需要 \(plan.duration.minutes)分 共\(plan.distance)公尺"
            durationLable.isHidden = false
            let size = plan.steps.count
            var planPointCounts = 0
            for i in 0..<size {
                let transitStep = plan.steps[i] as! BMKDrivingStep
                if i == 0 {
                    let item = RouteAnnotation()
                    item.coordinate = plan.starting.location
                    item.title = "起点"
                    item.type = 0
                    mapView.addAnnotation(item)  // 添加起点标注
                }
                if i == size - 1 {
                    let item = RouteAnnotation()
                    item.coordinate = plan.terminal.location
                    item.title = "终点"
                    item.type = 1
                    mapView.addAnnotation(item)  // 添加终点标注
                }
                
                // 添加 annotation 节点
                let item = RouteAnnotation()
                item.coordinate = transitStep.entrace.location
                item.title = transitStep.instruction
                item.degree = Int(transitStep.direction) * 30
                item.type = 4
                mapView.addAnnotation(item)
                
                // 轨迹点总数累计
                planPointCounts = Int(transitStep.pointsCount) + planPointCounts
            }
            
            // 添加途径点
            if plan.wayPoints != nil {
                for tempNode in plan.wayPoints as! [BMKPlanNode] {
                    let item = RouteAnnotation()
                    item.coordinate = tempNode.pt
                    item.type = 5
                    item.title = tempNode.name
                    mapView.addAnnotation(item)
                }
            }
            
            // 轨迹点
            var tempPoints = Array(repeating: BMKMapPoint(x: 0, y: 0), count: planPointCounts)
            var i = 0
            for j in 0..<size {
                let transitStep = plan.steps[j] as! BMKDrivingStep
                for k in 0..<Int(transitStep.pointsCount) {
                    tempPoints[i].x = transitStep.points[k].x
                    tempPoints[i].y = transitStep.points[k].y
                    i += 1
                }
            }
            
            // 通过 points 构建 BMKPolyline
            let polyLine = BMKPolyline(points: &tempPoints, count: UInt(planPointCounts))
            // 添加路线 overlay
            mapView.add(polyLine)
            mapViewFitPolyLine(polyLine)
        } else if error == BMK_SEARCH_AMBIGUOUS_ROURE_ADDR {
            //检索地址有歧义,返回起点或终点的地址信息结果：BMKSuggestAddrInfo，获取到推荐的poi列表
            print("检索地址有岐义，请重新输入。")
            self.showAlert(title: "導航失敗", Message: nil)
        }
    }

    //根据polyline设置地图范围
    func mapViewFitPolyLine(_ polyline: BMKPolyline!) {
        if polyline.pointCount < 1 {
            return
        }
        
        let pt = polyline.points[0]
        var leftTopX = pt.x
        var leftTopY = pt.y
        var rightBottomX = pt.x
        var rightBottomY = pt.y
        
        for i in 1..<polyline.pointCount {
            let pt = polyline.points[Int(i)]
            leftTopX = pt.x < leftTopX ? pt.x : leftTopX;
            leftTopY = pt.y < leftTopY ? pt.y : leftTopY;
            rightBottomX = pt.x > rightBottomX ? pt.x : rightBottomX;
            rightBottomY = pt.y > rightBottomY ? pt.y : rightBottomY;
        }
        
        let rect = BMKMapRectMake(leftTopX, leftTopY, rightBottomX - leftTopX, rightBottomY - leftTopY)
        mapView.visibleMapRect = rect
    }

    // MARK: - BMKMapViewDelegate
    
    /**
     *根据anntation生成对应的View
     *@param mapView 地图View
     *@param annotation 指定的标注
     *@return 生成的标注View
     */
    func mapView(_ mapView: BMKMapView!, viewFor annotation: BMKAnnotation!) -> BMKAnnotationView! {
        if let routeAnnotation = annotation as? RouteAnnotation? {
            return getViewForRouteAnnotation(routeAnnotation)
        }
        return nil
    }
    
    /**
     *根据overlay生成对应的View
     *@param mapView 地图View
     *@param overlay 指定的overlay
     *@return 生成的覆盖物View
     */
    func mapView(_ mapView: BMKMapView!, viewFor overlay: BMKOverlay!) -> BMKOverlayView! {
        if overlay as! BMKPolyline? != nil {
            let polylineView = BMKPolylineView(overlay: overlay as! BMKPolyline)
            polylineView?.strokeColor = UIColor(red: 0, green: 0, blue: 1, alpha: 0.7)
            polylineView?.lineWidth = 3
            return polylineView
        }
        return nil
    }
    
    // MARK: -
    
    func getViewForRouteAnnotation(_ routeAnnotation: RouteAnnotation!) -> BMKAnnotationView? {
        var view: BMKAnnotationView?
        
        var imageName: String?
        switch routeAnnotation.type {
        case 0:
            imageName = "nav_start"
        case 1:
            imageName = "nav_end"
        case 2:
            imageName = "nav_bus"
        case 3:
            imageName = "nav_rail"
        case 4:
            imageName = "direction"
        case 5:
            imageName = "nav_waypoint"
        default:
            return nil
        }
        let identifier = "\(String(describing: imageName))_annotation"
        view = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        if view == nil {
            view = BMKAnnotationView(annotation: routeAnnotation, reuseIdentifier: identifier)
            view?.centerOffset = CGPoint(x: 0, y: -(view!.frame.size.height * 0.5))
            view?.canShowCallout = true
        }
        
        view?.annotation = routeAnnotation
        
        let bundlePath = (Bundle.main.resourcePath)! + "/mapapi.bundle/"
        let bundle = Bundle(path: bundlePath)
        var tmpBundle : String?
        tmpBundle = (bundle?.resourcePath)! + "/images/icon_\(imageName!).png"
        if let imagePath = tmpBundle {
            var image = UIImage(contentsOfFile: imagePath)
            if routeAnnotation.type == 4 {
                image = imageRotated(image, degrees: routeAnnotation.degree)
            }
            if image != nil {
                view?.image = image
            }
        }
        
        return view
    }

    //旋转图片
    func imageRotated(_ image: UIImage!, degrees: Int!) -> UIImage {
        let width = image.cgImage?.width
        let height = image.cgImage?.height
        let rotatedSize = CGSize(width: width!, height: height!)
        UIGraphicsBeginImageContext(rotatedSize);
        let bitmap = UIGraphicsGetCurrentContext();
        bitmap?.translateBy(x: rotatedSize.width/2, y: rotatedSize.height/2);
        bitmap?.rotate(by: CGFloat(Double(degrees) * Double.pi / 180.0));
        bitmap?.rotate(by: CGFloat(Double.pi));
        bitmap?.scaleBy(x: -1.0, y: 1.0);
        bitmap?.draw(image.cgImage!, in: CGRect(x: -rotatedSize.width/2, y: -rotatedSize.height/2, width: rotatedSize.width, height: rotatedSize.height));
        let newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return newImage!;
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

extension MapViewController: UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate{
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.view.endEditing(true)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.isHidden = true
        
        let center = searchList[indexPath.row].coor
        getData(coor: center!)
        searchPoint = center
        //设置地图的显示范围（越小越精确）
        let span = BMKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        //设置地图最终显示区域
        let region = BMKCoordinateRegion(center: center!, span: span)
        mapView?.region = region
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        cell.detailTextLabel?.text = searchList[indexPath.row].name
        cell.textLabel?.text = searchList[indexPath.row].name
        return cell
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        routeButton.isHidden = true
        durationLable.isHidden = true
        detailView.isHidden = true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        if textField == cityTextField{
            return true
        }
        
        if cityTextField.text == "" || cityTextField.text == nil{
            let nearbySeachOption = BMKNearbySearchOption()
            nearbySeachOption.pageIndex = 0
            nearbySeachOption.pageCapacity = 20
            nearbySeachOption.keyword = textField.text!
            
            nearbySeachOption.location = CLLocationCoordinate2D(latitude: Double(Location.userLocation.currentLat!)!, longitude: Double(Location.userLocation.currentLon!)!)
            
            let flag = _poisearcher.poiSearchNear(by: nearbySeachOption)
            if flag{
                print("Success nearby")
            }else{
                showAlert(title: "查詢失敗", Message: nil)
                print("Fail nearby")
            }
        }else{
            let citySearchOption = BMKCitySearchOption()
            citySearchOption.pageIndex = 0
            citySearchOption.pageCapacity = 20
            citySearchOption.city = cityTextField.text!
            citySearchOption.keyword = textField.text!
            let flag = _poisearcher.poiSearch(inCity: citySearchOption)
            if flag{
                print("Success city")
            }else{
                showAlert(title: "查詢失敗", Message: nil)
                print("Fail city")
            }
        }
        return true
    }
    
    func onGetPoiResult(_ searcher: BMKPoiSearch!, result poiResult: BMKPoiResult!, errorCode: BMKSearchErrorCode) {
        if errorCode == BMK_SEARCH_NO_ERROR{
            searchList = [MapSearchResult]()
            if poiResult.poiInfoList != nil{
                for info in poiResult.poiInfoList{
                    let poi = info as! BMKPoiInfo
                    let map = MapSearchResult()
                    map.name = poi.name
                    map.coor = poi.pt
                    searchList.append(map)
                }
                
                searchTableView.reloadData()
                searchTableView.isHidden = false
            }else{
                showAlert(title: "查無資料", Message: nil)
            }
        }else{
            showAlert(title: "查無資料", Message: nil)
            print("No result")
        }
    }
    
    func showAlert(title:String, Message:String?){
        let alert = UIAlertController(title: title, message: Message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "確認", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func getData(coor:CLLocationCoordinate2D){
        let parameters: Parameters = [
            "pubtype":pubtype,
            "user_lat": String(coor.latitude),
            "user_lon": String(coor.longitude),
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
                    
                    if locationList.count > 0{
                        for location in locationList{
                            // 添加一个标记点(PointAnnotation）
                            let annotation =  BMKPointAnnotation()
                            var coor = CLLocationCoordinate2D()
                            coor.latitude = Double(location.lat!)!
                            coor.longitude = Double(location.lon!)!
                            annotation.coordinate = coor
                            annotation.title = location.pub_name
                            
                            
                            self.mapView!.addAnnotation(annotation)
                        }
                    }
                    self.locationList! += locationList
                    
                }
            }
        }
    }

    
}

class MapSearchResult{
    
    var name:String?
    var coor:CLLocationCoordinate2D?
    
}

class RouteAnnotation: BMKPointAnnotation {
    
    var type: Int!///<0:起点 1：终点 2：公交 3：地铁 4:驾乘 5:途经点
    var degree: Int!
    
    override init() {
        super.init()
    }
    
    init(type: Int, degree: Int) {
        self.type = type
        self.degree = degree
    }
    
}


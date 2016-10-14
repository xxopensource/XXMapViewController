//
//  XXMapViewController.swift
//  XXMapViewController
//
//  Created by Wangyun on 16/9/28.
//  Copyright © 2016年 Wangyun. All rights reserved.
//

import UIKit
//import SearchKeyWordViewController

class XXMapViewController: UIViewController,BMKMapViewDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate, UISearchControllerDelegate, UISearchBarDelegate,UITextFieldDelegate,SearchKeyWordDelegate,KeywordListDidSelectDelegate,BMKPoiSearchDelegate,ListCellDidSelectDelegate,UIGestureRecognizerDelegate,BackActionDelegate {
    var _mapView: BMKMapView?
    var locationService: BMKLocationService!
    var geoCodeSearch: BMKGeoCodeSearch!
    var addressListView: AddressListView!
    var favManager: BMKFavPoiManager!
    var favPoiInfo = BMKFavPoiInfo()
    var poiSearcher = BMKPoiSearch()
    var pan: UIPanGestureRecognizer!
    var locationButton: UIButton!
    
    private func initSearchC() {
        let topView = UIView()
        topView.backgroundColor = UIColor.whiteColor()
        topView.frame = CGRect(x: 10, y: 20, width: self.view.frame.width-20, height: 40)
        topView.layer.cornerRadius = 3
        topView.layer.borderWidth = 0.5;
        topView.layer.borderColor = UIColor.whiteColor().CGColor;
        self.view.addSubview(topView)
        let addressTextField = UITextField()
        addressTextField.frame = CGRect(x: 20, y: 0, width: topView.frame.width-20, height: 40)
        addressTextField.placeholder = "搜索";
        addressTextField.delegate = self
        topView.addSubview(addressTextField)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        _mapView = BMKMapView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        self.view.addSubview(_mapView!)
        locationButton = UIButton(type: UIButtonType.Custom)
        locationButton.frame = CGRect(x: 20, y: self.view.frame.height-100, width: 30, height: 30)
        locationButton.backgroundColor = UIColor.whiteColor()
        locationButton.layer.cornerRadius = 3
        locationButton.setImage(UIImage.init(named: "iconfont_location_request"), forState: UIControlState.Normal)
        locationButton.addTarget(self, action: #selector(locationRequest(_:)), forControlEvents: .TouchUpInside)
        self.view.addSubview(locationButton)
        addressListView = AddressListView(frame: CGRect(x: 0, y: self.view.frame.height-260, width: self.view.frame.width, height: 260))
        addressListView.frame.origin.y = self.view.frame.height-60
        addressListView.delegate = self
        self.view.addSubview(addressListView!)
        initSearchC();
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        _mapView?.delegate = self
        _mapView?.viewWillAppear()
        //_mapView?.showsUserLocation = false//先关闭显示的定位图层
        _mapView?.userTrackingMode = BMKUserTrackingModeFollow;//设置定位的状态
        _mapView?.showsUserLocation = true//显示定位图层
        _mapView?.zoomLevel = 18;
        locationService = BMKLocationService()
        locationService.allowsBackgroundLocationUpdates = true
        geoCodeSearch = BMKGeoCodeSearch()
        favManager = BMKFavPoiManager()
        locationService.delegate = self
        locationService.startUserLocationService()
        geoCodeSearch.delegate = self;
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        _mapView?.viewWillDisappear()
        _mapView?.delegate = nil // 不用时，置nil
        locationService.delegate = nil
        geoCodeSearch.delegate = nil
    }
    // MARK: - BMKMapViewDelegate
    func mapView(mapView: BMKMapView!, regionWillChangeAnimated animated: Bool) {
        
    }
    
    func mapView(mapView: BMKMapView!, viewForAnnotation annotation: BMKAnnotation!) -> BMKAnnotationView! {
        if annotation.isKindOfClass(BMKPointAnnotation.self) {
            let newAnnotationView = BMKPinAnnotationView(annotation: annotation, reuseIdentifier: "annotation")
            newAnnotationView.animatesDrop = true
            newAnnotationView.canShowCallout = true
            mapView.setCenterCoordinate(annotation.coordinate, animated: true)
            return newAnnotationView
        }
        return nil
    }
    
    // MARK: - BMKLocationServiceDelegate
    
    /**
     *在地图View将要启动定位时，会调用此函数
     *@param mapView 地图View
     */
    func willStartLocatingUser() {
        print("willStartLocatingUser");
    }
    
    /**
     *用户方向更新后，会调用此函数
     *@param userLocation 新的用户位置
     */
    func didUpdateUserHeading(userLocation: BMKUserLocation!) {
        _mapView!.updateLocationData(userLocation)
    }
    
    /**
     *用户位置更新后，会调用此函数
     *@param userLocation 新的用户位置
     */
    func didUpdateBMKUserLocation(userLocation: BMKUserLocation!) {
        _mapView!.updateLocationData(userLocation)
        let pt = CLLocationCoordinate2DMake(userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude)
        let reverseGeocodeSearchOption = BMKReverseGeoCodeOption()
        reverseGeocodeSearchOption.reverseGeoPoint = pt
        let flag = geoCodeSearch.reverseGeoCode(reverseGeocodeSearchOption)
        if flag {
            print("反geo 检索发送成功")
        } else {
            print("反geo 检索发送失败")
        }
    }
    
    /**
     *在地图View停止定位后，会调用此函数
     *@param mapView 地图View
     */
    func didStopLocatingUser() {
        print("didStopLocatingUser")
    }
    
    //MARK:- BMKGeoCodeSearchDelegate
    /**
     *返回地址信息搜索结果
     *@param searcher 搜索对象
     *@param result 搜索结BMKGeoCodeSearch果
     *@param error 错误号，@see BMKSearchErrorCode
     */
    func onGetGeoCodeResult(searcher: BMKGeoCodeSearch!, result: BMKGeoCodeResult!, errorCode error: BMKSearchErrorCode) {
        _mapView!.removeAnnotations(_mapView!.annotations)
        var coor = CLLocationCoordinate2D()
        if error == BMK_SEARCH_NO_ERROR {
            let annotation = BMKPointAnnotation()
            coor.latitude = result.location.latitude
            coor.longitude = result.location.longitude
            annotation.coordinate = coor
            annotation.title = result.address
            _mapView?.addAnnotation(annotation)
            favPoiInfo.pt = coor
            let poiInfoArray = NSMutableArray()
            poiInfoArray.addObjectsFromArray(favManager.getAllFavPois())
            
            let addressArray = NSMutableArray()
            for favPoiInfo in poiInfoArray{
                addressArray.addObject(favPoiInfo.poiName)
            }
            
            if !(addressArray.containsObject(favPoiInfo.poiName)) {
                let res = favManager.addFavPoi(favPoiInfo)
                if res == 1 {
                    print("保存成功")
                } else {
                    print("保存失败")
                }
            }
        } else {
            // 各种情况的判断……
        }
        poiSearcher.delegate = self
        let option = BMKNearbySearchOption()
        option.pageIndex = 0
        option.pageCapacity = 10
        option.location = coor
        option.keyword = result.address
        let flag = poiSearcher.poiSearchNearBy(option)
        if flag {
            print("周边检索发送成功")
        }else{
            print("周边检索发送失败")
        }
        
    }
    
    //MARK -- PoiSearchDeleage
    func onGetPoiResult(searcher: BMKPoiSearch!, result poiResult: BMKPoiResult!, errorCode: BMKSearchErrorCode) {
        let array = NSMutableArray()
        array.addObjectsFromArray(poiResult.poiInfoList)
        addressListView.listArray = array
        addressListView.tableView.reloadData()
        let height = addressListView.tableView.contentSize.height
        addressListView.tableView.setContentOffset(CGPointMake(0, height-addressListView.tableView.frame.size.height), animated: true)
        
        for bmkPoiInfo in array {
            var coor = CLLocationCoordinate2D()
            let annotation = BMKPointAnnotation()
            coor.latitude = bmkPoiInfo.pt.latitude
            coor.longitude = bmkPoiInfo.pt.longitude
            annotation.coordinate = coor
            annotation.title = bmkPoiInfo.name
            _mapView?.addAnnotation(annotation)
        }
        addressListView.frame.origin.y = SCREEN_HEIGHT - 200
        pan = UIPanGestureRecognizer(target: self, action:#selector(XXMapViewController.cutScreen(_:)))
        addressListView.addGestureRecognizer(pan)
    }
    
    func cutScreen(sender:UIPanGestureRecognizer){
      let point =  sender.locationInView(self.view)
        if SCREEN_HEIGHT-point.y > 60 {
            addressListView.frame = CGRect(x: 0, y: point.y, width: SCREEN_WIDTH, height: SCREEN_HEIGHT-point.y)
            addressListView.tableView.frame.size.height = addressListView.frame.size.height
        }else{
            addressListView.frame.origin.y = SCREEN_HEIGHT - 60
        }
        
    }

    
    /**
     *返回反地理编码搜索结果
     *@param searcher 搜索对象
     *@param result 搜索结果
     *@param error 错误号，@see BMKSearchErrorCode
     */
    func onGetReverseGeoCodeResult(searcher: BMKGeoCodeSearch!, result: BMKReverseGeoCodeResult!, errorCode error: BMKSearchErrorCode) {
        addressListView.addressTitleLabel.text = result.address
        addressListView.addressTitleLabel.textAlignment = NSTextAlignment.Left
        locationButton.setImage(UIImage(named: "iconfont-location"), forState: .Normal)
    }
    
    //MARK -- TextFieldDelegate
    func textFieldDidBeginEditing(textField: UITextField) {
        textField.resignFirstResponder()
        let searchKeyWordVC = SearchKeyWordViewController()
        searchKeyWordVC.transitioningDelegate = SearchKeyWordTransitioning.sharedInstance()
        searchKeyWordVC.modalPresentationStyle = UIModalPresentationStyle.Custom;
        searchKeyWordVC.delegate = self
        searchKeyWordVC.listSelectDelegate = self
        self.presentViewController(searchKeyWordVC, animated: false, completion: nil)
    }
    
    //MARK -- SearchKeyWordDelegate
    func searchKeyWordResult(textFiled:UITextField){
        let geocodeSearchOption = BMKGeoCodeSearchOption()
        geocodeSearchOption.address = textFiled.text
        let flag = geoCodeSearch.geoCode(geocodeSearchOption)
        if flag {
            favPoiInfo.poiName = textFiled.text
            favPoiInfo.address = textFiled.text
            addressListView.addressTitleLabel.textAlignment = NSTextAlignment.Center
            addressListView.addressTitleLabel.text = textFiled.text
            self.stopLocation()
            print("geo 检索发送成功")
        } else {
            print("geo 检索发送失败")
        }
        textFiled.resignFirstResponder()
    }
    
    //MARK -- KeywordListDidSelectDelegate
    func keyWordListDidSelectPoiInfo(poiInfo: BMKFavPoiInfo) {
        _mapView!.removeAnnotations(_mapView!.annotations)
        let annotation = BMKPointAnnotation()
        var coor = CLLocationCoordinate2D()
        coor.latitude = poiInfo.pt.latitude
        coor.longitude = poiInfo.pt.longitude
        annotation.coordinate = coor
        annotation.title = poiInfo.address
        _mapView?.addAnnotation(annotation)
        let geocodeSearchOption = BMKGeoCodeSearchOption()
        geocodeSearchOption.address = poiInfo.address
        addressListView.addressTitleLabel.text = poiInfo.address
        addressListView.addressTitleLabel.textAlignment = NSTextAlignment.Center
        let flag = geoCodeSearch.geoCode(geocodeSearchOption)
        if flag {
            favPoiInfo.poiName = poiInfo.address
            favPoiInfo.address = poiInfo.address
            self.stopLocation()
            print("geo 检索发送成功")
        } else {
            print("geo 检索发送失败")
        }
    }
    
    func listCellDidSelectAtIndexPath(indexPath: NSInteger) {
        _mapView!.removeAnnotations(_mapView!.annotations)
        let annotation = BMKPointAnnotation()
        var coor = CLLocationCoordinate2D()
        let poiInfo = addressListView.listArray[indexPath]
        coor.latitude = poiInfo.pt.latitude
        coor.longitude = poiInfo.pt.longitude
        annotation.coordinate = coor
        annotation.title = poiInfo.name
        _mapView?.addAnnotation(annotation)
        addressListView.hidden = true
        let addressDetailVC = AddressDetailViewController()
        addressDetailVC.poiInfo = poiInfo as! BMKPoiInfo
        addressDetailVC.delegate = self
        addressDetailVC.modalPresentationStyle = UIModalPresentationStyle.Custom
        addressDetailVC.transitioningDelegate = AddressDetailTransitioning.shareTransitioning()
        self.presentViewController(addressDetailVC, animated: false, completion: nil)
    }
    
    //MARK -- BackActionDelegate
    func returnBackAction() {
        addressListView.hidden = false
    }

    //MARK -- CustomizedFunction
    //重新定位
    func locationRequest(sender:UIButton) {
        addressListView.frame.origin.y = SCREEN_HEIGHT - 60
        addressListView.removeGestureRecognizer(pan)
        locationService.startUserLocationService()
        _mapView?.userTrackingMode = BMKUserTrackingModeFollow
        _mapView?.zoomLevel = 18
        locationButton.setImage(UIImage(named: "iconfont-location"), forState: .Normal)
    }
    
    //结束定位
    func stopLocation() {
        locationService.stopUserLocationService()
        locationButton.setImage(UIImage(named: "iconfont_location_request"), forState: .Normal)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

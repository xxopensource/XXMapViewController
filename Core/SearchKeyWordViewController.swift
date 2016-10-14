//
//  SearchKeyWordViewController.swift
//  XXMapViewController
//
//  Created by Wangyun on 16/9/29.
//  Copyright © 2016年 Wangyun. All rights reserved.
//

import UIKit

public let SCREEN_WIDTH = UIScreen.mainScreen().bounds.width;
public let SCREEN_HEIGHT = UIScreen.mainScreen().bounds.height;

protocol SearchKeyWordDelegate: NSObjectProtocol {
    func searchKeyWordResult(textFiled:UITextField);
}

protocol KeywordListDidSelectDelegate: NSObjectProtocol {
    func keyWordListDidSelectPoiInfo(poiInfo:BMKFavPoiInfo);
}


class SearchKeyWordViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate{
    var topView = UIView()
    var textFieldBagView = UIView()
    var search = BMKPoiSearch()
    var favManager: BMKFavPoiManager!
    var favPoiInfos = [BMKFavPoiInfo]()
    
    var backButton = UIButton()
    var contentView = UIView()
    var keyWord: NSString?
    var bagViewWidth: CGFloat?
    var searchTextField = UITextField()
    var tableView = UITableView()
    var searchArray = NSMutableArray()
    weak var delegate:SearchKeyWordDelegate?;
    weak var listSelectDelegate:KeywordListDidSelectDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        topView.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 64)
        topView.backgroundColor = UIColor(colorLiteralRed: 230.0/255.0, green: 230.0/255.0, blue: 230.0/255.0, alpha: 1.0)
        self.view.addSubview(topView)
        
        contentView.frame = CGRect(x: 0, y: 64, width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
        contentView.backgroundColor = UIColor(colorLiteralRed: 240.0/255.0, green: 240.0/255.0, blue: 240.0/255.0, alpha: 1.0)
        self.view.addSubview(contentView)
        
        favManager = BMKFavPoiManager()

        backButton.frame = CGRect(x: 0, y: 24, width: 35, height: 35)
        backButton.setImage(UIImage(named: "img_left_arrow"), forState:UIControlState.Normal)
        backButton.addTarget(self, action: #selector(SearchKeyWordViewController.backButtonAction), forControlEvents: UIControlEvents.TouchUpInside)
        topView.addSubview(backButton)
        
        textFieldBagView.frame = CGRect(x: 50, y: 24, width: topView.frame.width-70, height: 35)
        textFieldBagView.backgroundColor = UIColor.whiteColor()
        textFieldBagView.layer.borderWidth = 0.5;
        textFieldBagView.layer.borderColor = UIColor.lightGrayColor().CGColor;
        textFieldBagView.layer.cornerRadius = 3;
        topView.addSubview(textFieldBagView)
        
        let searchIcon = UIImageView(image: UIImage(named: "img_search"))
        searchIcon.frame = CGRect(x: 8, y: 10, width: 20, height: 20)
        textFieldBagView.addSubview(searchIcon)
        
        searchTextField.frame = CGRect(x: 30, y: 0, width: textFieldBagView.frame.width, height: 35)
        searchTextField.delegate = self
        textFieldBagView.addSubview(searchTextField)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if let favPois = favManager.getAllFavPois() as? [BMKFavPoiInfo] {
            favPoiInfos.removeAll()
            favPoiInfos.appendContentsOf(favPois)
            searchArray.addObjectsFromArray(favPois)
        }
        tableView.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: CGFloat(searchArray.count*50))
        tableView.rowHeight = 50
        tableView.separatorStyle = .SingleLine
        tableView.separatorInset = UIEdgeInsetsZero
        tableView.layoutMargins = UIEdgeInsetsZero
        contentView.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: NSStringFromClass(UITableViewCell))
    }
    
    func backButtonAction(){
        self.dismissViewControllerAnimated(false, completion: nil)
    }
    
    //MARK -- UITableViewDataSource
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(NSStringFromClass(UITableViewCell), forIndexPath: indexPath)
        cell.imageView?.image = UIImage(named: "img_search_list")
        cell.textLabel?.textColor = UIColor(colorLiteralRed: 70.0/255.0, green: 70.0/255.0, blue: 70.0/255.0, alpha: 1.0)
        var poiInfo = BMKFavPoiInfo()
        poiInfo = searchArray[indexPath.row] as! BMKFavPoiInfo
        cell.textLabel?.text = poiInfo.poiName
        cell.separatorInset = UIEdgeInsetsZero
        cell.layoutMargins = UIEdgeInsetsZero
        return cell
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return searchArray.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.dismissViewControllerAnimated(false) { 
            self.listSelectDelegate?.keyWordListDidSelectPoiInfo(self.searchArray[indexPath.row] as! BMKFavPoiInfo)
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool{
        self.dismissViewControllerAnimated(false) { 
           self.delegate?.searchKeyWordResult(textField) 
        }
        return true
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

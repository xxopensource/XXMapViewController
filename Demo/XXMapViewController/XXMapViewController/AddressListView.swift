//
//  AddressListView.swift
//  XXMapViewController
//
//  Created by Wangyun on 16/9/29.
//  Copyright © 2016年 Wangyun. All rights reserved.
//

import UIKit

protocol ListCellDidSelectDelegate: NSObjectProtocol {
    func listCellDidSelectAtIndexPath(indexPath: NSInteger);
}

class AddressListView: UIView,UITableViewDelegate,UITableViewDataSource {
    var addressTitleLabel = UILabel();
    var tableView = UITableView()
    var listArray = NSMutableArray()
    weak var delegate: ListCellDidSelectDelegate?
    
     override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.whiteColor()
        addressTitleLabel.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 59.5)
        addressTitleLabel.font = UIFont.systemFontOfSize(16.0)
        self.addSubview(addressTitleLabel)
        let line = UIView()
        line.frame = CGRect(x: 0, y: 59.5, width: SCREEN_WIDTH, height: 0.5)
        line.backgroundColor = UIColor(colorLiteralRed: 224.0/255.0, green: 224.0/255.0, blue: 224.0/255.0, alpha: 1.0)
        self.addSubview(line)
        
        tableView.frame = CGRect(x: 0, y: 60, width: SCREEN_WIDTH, height: CGFloat(SCREEN_HEIGHT-60))
        tableView.rowHeight = 70
        tableView.separatorStyle = .SingleLine
        tableView.separatorInset = UIEdgeInsetsZero
        tableView.layoutMargins = UIEdgeInsetsZero
        tableView.scrollsToTop = true
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerClass(AddressListTableViewCell.self, forCellReuseIdentifier: NSStringFromClass(AddressListTableViewCell))
        self.addSubview(tableView)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(NSStringFromClass(AddressListTableViewCell), forIndexPath: indexPath) as! AddressListTableViewCell
        var poiInfo = BMKPoiInfo()
        poiInfo = listArray[indexPath.row] as! BMKPoiInfo
        cell.titleLabel.text = poiInfo.name
        cell.descLabel.text = poiInfo.address
        cell.separatorInset = UIEdgeInsetsZero
        cell.layoutMargins = UIEdgeInsetsZero
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listArray.count
    }
    
     func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
            self.delegate?.listCellDidSelectAtIndexPath(indexPath.row)
        tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.None);
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}

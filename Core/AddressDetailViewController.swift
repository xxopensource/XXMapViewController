//
//  AddressDetailViewController.swift
//  XXMapViewController
//
//  Created by Wangyun on 16/10/13.
//  Copyright © 2016年 Wangyun. All rights reserved.
//

import UIKit

protocol BackActionDelegate: NSObjectProtocol {
    func returnBackAction();
}

class AddressDetailViewController: UIViewController {
    var poiInfo: BMKPoiInfo!
    weak var delegate:BackActionDelegate!
    var contentView: UIView!
    var pan: UIPanGestureRecognizer!
    var infoLabel = UILabel()
    var detailLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let backButton = UIButton(type: UIButtonType.Custom)
        backButton.frame = CGRect(x: 10, y: 80, width: 35, height: 35)
        backButton.setImage(UIImage(named: "img_left_arrow"), forState:UIControlState.Normal)
        backButton.addTarget(self, action: #selector(backAction), forControlEvents: .TouchUpInside)
        self.view.addSubview(backButton)
        contentView = UIView()
        contentView.frame = CGRect(x: 0, y: SCREEN_HEIGHT-200, width: SCREEN_WIDTH, height: 200)
        contentView.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(contentView)
        
        infoLabel.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 60)
        infoLabel.textAlignment = .Center
        contentView.addSubview(infoLabel)
        detailLabel.frame = CGRect(x: 0, y: 60, width: SCREEN_WIDTH, height: 60)
        detailLabel.textColor = UIColor(colorLiteralRed: 138.0/255.0, green: 138.0/255.0, blue: 138.0/255.0, alpha: 1.0)
        detailLabel.font = UIFont.systemFontOfSize(15.0)
        detailLabel.numberOfLines = 0
        contentView.addSubview(detailLabel)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        infoLabel.text = poiInfo.name
        detailLabel.text = poiInfo.address
        switch poiInfo.epoitype {
        case 1:
            infoLabel.text = infoLabel.text?.stringByAppendingString("(公交站)")
        case 2:
            infoLabel.text = infoLabel.text?.stringByAppendingString("(公交线路)")
        case 3:
            infoLabel.text = infoLabel.text?.stringByAppendingString("(地铁站)")
        case 4:
            infoLabel.text = infoLabel.text?.stringByAppendingString("(地铁线路)")
        default: break
            
        }
        detailLabel.sizeToFit()
        pan = UIPanGestureRecognizer(target: self, action:#selector(AddressDetailViewController.panScreen(_:)))
        contentView.addGestureRecognizer(pan)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    func panScreen(sender:UIPanGestureRecognizer){
        let point =  sender.locationInView(self.view)
        if SCREEN_HEIGHT-point.y > 60 {
            contentView.frame = CGRect(x: 0, y: point.y, width: SCREEN_WIDTH, height: SCREEN_HEIGHT-point.y)
        }else{
            contentView.frame.origin.y = SCREEN_HEIGHT - 60
        }
        
    }
    
    func backAction() {
        self.dismissViewControllerAnimated(false) {
          self.delegate.returnBackAction()
        }
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
